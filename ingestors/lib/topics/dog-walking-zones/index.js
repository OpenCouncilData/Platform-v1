const scrape = require('./scraper').scrape
const transform = require('./transformer').transform
const load = require('./loader').load

function run() {
  return scrape().then(transform).then(load).then(() => {
    console.log('Successfully ETL\'d dog-walking-zones:')
  }).catch(err => {
    console.log('Failed to ETL dog-walking-zones: ', err, err.stack)
    return Promise.reject(err)
  })
}

exports.run = run
