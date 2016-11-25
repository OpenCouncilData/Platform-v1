const govScraper = require('../../common/data-dot-gov-scraper')

const includeKeywords = ['collection', 'zones']
const excludeKeywords = ['logan']
const tags = ['garbage', 'waste']

exports.scrape = function() {
  return govScraper.findZones(tags, includeKeywords, excludeKeywords)
}
