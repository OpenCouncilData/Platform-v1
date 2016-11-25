const _ = require('lodash')
const postgres = require('../../clients/postgres')

const insertQuery = `
  INSERT INTO DATA(type, geometry, date, payload, source_uri)
  VALUES ($1::text, ST_transform(ST_GeomFromGeoJSON($2::text), 4326), $3::timestamp, $4::json, $5::text)
`

function insertZone(db, zone) {
  const args = [
    'dog-walking-zones',
    JSON.stringify(zone.geometry),
    zone.modifiedTimestamp,
    JSON.stringify(zone.properties),
    zone.sourceUrl
  ]

  return Promise.resolve(null)
    .then(() => { console.log("INSERT:", args) })
    .then(() => db.none(insertQuery, args))
}

// TODO: Upsert / Duplicate detection

exports.load = function(zones) {
  const db = postgres.connect()

  const p = Promise.resolve(null)

  zones.forEach(zone => {
    p = p.then(() => {
      console.log(`Inserting dog-walking-zones feature ${zone.featureId} from resource ${zone.resourceId} from package ${zone.packageId}`)
      return insertZone(db, zone)
    })
  })

  return p
}
