#!/usr/bin/env node

var db = require('./db')
var sqlite3 = require('sqlite3')
var vgdb = new sqlite3.Database('./openvgdb.sqlite')
var denodeify = require('denodeify')

// var re = /(?:\[([^\]]*)\]\s)?([^\)]*)\s\(([^\)]*)\)(?:\s\(([^\)]*)\))?(?:\s\(([^\)]*)\))?(?:\s\(([^\)]*)\))?(?:\s\(([^\)]*)\))?(?:\s\(([^\)]*)\))?(?:\s\(([^\)]*)\))?(?:\s\[([^\]]*)\])?/

Promise.all(db.map(function(game) {
  return denodeify(vgdb.get.bind(vgdb))('select * from releases, roms, systems, regions where releases.romID = roms.romID and regions.regionID = roms.regionID and systems.systemID = roms.systemID and romExtensionlessFileName = ?', game.name)
  .then(function(rom) {
    if (!rom)
      throw 'unable to find rom ' + game.name
    var result = {}
    if (rom.regionName)
      result.region = rom.regionName
    if (rom.systemName)
      result.system = rom.systemName
    if (rom.romHashCRC)
      result.crc = rom.romHashCRC
    if (rom.romHashMD5)
      result.md5 = rom.romHashMD5
    if (rom.romHashSHA1)
      result.crc = rom.romHashSHA1
    if (rom.romFileName)
      result.fileName = rom.romFileName
    if (rom.romSize)
      result.size = rom.romSize
    if (rom.releaseTitleName)
      result.title = rom.releaseTitleName
    if (rom.releaseGenre)
      result.genres = rom.releaseGenre.split(',')
    if (rom.releaseDate)
      result.date = rom.releaseDate
    if (rom.releaseReferenceURL)
      result.url = rom.releaseReferenceURL
    if (rom.releasePublisher)
      result.publisher = rom.releasePublisher
    if (rom.releaseDeveloper)
      result.developer = rom.releaseDeveloper
    if (rom.releaseDescription)
      result.description = rom.releaseDescription
    if (rom.releaseCoverFront)
      result.coverFront = rom.releaseCoverFront
    if (rom.releaseCoverBack)
      result.coverBack = rom.releaseCoverBack
    if (rom.releaseCoverDisc)
      result.coverDisc = rom.releaseCoverDisc
    if (rom.releaseCoverCart)
      result.coverCart = rom.releaseCoverCart
    return result
  })
})).then(function(results) {
  db = results
  fs.writeFile('db.json', JSON.stringify(db))
})
