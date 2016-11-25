"use strict"

const _ = require('lodash')
const gov = require('../clients/data-dot-gov')
const request = require('request-promise')

// (Array<string>, Array<string>) => Package => boolean
function createPackagePredicate(includeWords, excludeWords) {
  const textFields = ['name', 'notes', 'title']


  return function(pkg) {
    const inc = includeWords.some(word => textFields.some(field => pkg[field].toLowerCase().indexOf(word.toLowerCase()) > -1))
    const exc = excludeWords.some(word => textFields.some(field => pkg[field].toLowerCase().indexOf(word.toLowerCase()) > -1))

    return inc && !exc
  }
}

// Resource => boolean
function isGeoJsonResource(resource) {
  const hasGeoJsonFormat = (resource.format || '').toLowerCase() == 'geojson'
  const hasJsonFormat = (resource.format || '').toLowerCase() == 'json'
  const hasGeoName = (resource.name || '').toLowerCase().indexOf('geojson') > -1
  const hasGeoDescription = (resource.description || '').toLowerCase().indexOf('geojson') > -1

  return hasGeoJsonFormat || (hasJsonFormat && (hasGeoName || hasGeoDescription))
}

// Array<Package> => Array<{ package: Package, resource: Resource }>
function chooseResourcesForPackages(packages) {
  return packages
    .map(pkg => ({ package: pkg, resource: pkg.resources.filter(isGeoJsonResource)[0] }))
    .filter(pr => pr.resource !== undefined)
}

// { package: Package, resource: Resource } => Promise<{ package: Package, resource: Resource, featureCollection: FeatureCollection }>
function fetchFeatureCollection(packageAndResource) {
  return Promise.resolve(null)
    .then(() => { console.log("Fetching resource: ", packageAndResource.resource.url) })
    .then(() => request({ uri: packageAndResource.resource.url, json: true }))
    .then(featureCollection => {
      return {
        package: packageAndResource.package,
        resource: packageAndResource.resource,
        featureCollection: featureCollection
      }
    })
}

function Zone(pkg, resource, featureCollection, feature) {
  this.geometry = _.assign({}, feature.geometry, { crs: featureCollection.crs })
  this.modifiedTimestamp = resource.last_modified || resource.created
  this.properties = feature.properties
  this.sourceUrl = resource.url
  this.resourceId = resource.id
  this.packageId = pkg.id
  this.featureId = feature.id
}

/*
Returns Promise<Array<Zone>>, with one Zone for each GeoJson feature in data.gov in a package which has:
 - at least one of the given tags
 - a text field (name, notes, title) containing at least one of the given keywords

Zone type:
{
  geometry: (geojson geometry object with crs)
  modifiedTimestamp: (iso date string)
  properties: (geojson properties hash)
  sourceUrl: string,
  packageId: string,
  resourceId: string,
  featureId: string
}
*/
function findZones(tags, includeKeywords, excludeKeywords) {
  // Package => bool
  const packagePredicate = createPackagePredicate(includeKeywords, excludeKeywords)

  // Promise<Array<Package>>
  const packagesPromise = gov.searchPackagesByTags(tags)
    .then(packages => packages.filter(packagePredicate))
    .then(packages => { console.log(`Found ${packages.length} packages`); return packages; })

  // Promise<Array<{ package: Package, resource: Resource }>>
  const resourcesPromise = packagesPromise.then(chooseResourcesForPackages)
    .then(prs => { console.log(`Found ${prs.length} packages with GeoJson resources`); return prs; })

  // Promise<Array<{ package: Package, resource: Resource, featureCollection: FeatureCollection }>>
  const featuresPromise = resourcesPromise.then(prs => Promise.all(prs.map(fetchFeatureCollection)))
    .then(prfs => { console.log(`Fetched ${prfs.length} GeoJSON resources`); return prfs; })

  // Promise<Array<Zone>>
  const zonesPromise = featuresPromise.then(prfs => {
    const zoneLists = prfs.map(prf => {
      return prf.featureCollection.features.map(feature => new Zone(prf.package, prf.resource, prf.featureCollection, feature))
    })
    return _.flatten(zoneLists)
  }).then(zones => { console.log(`Extracted ${zones.length} zones`); return zones; })

  return zonesPromise
}

exports.findZones = findZones
