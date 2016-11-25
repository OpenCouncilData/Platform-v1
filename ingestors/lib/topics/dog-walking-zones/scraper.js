const govScraper = require('../../common/data-dot-gov-scraper')

const includeKeywords = ['walk', 'zones', 'off leash']
const excludeKeywords = []
const tags = ['dog']

exports.scrape = function() {
  return govScraper.findZones(tags, includeKeywords, excludeKeywords)
}
