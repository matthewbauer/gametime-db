fs = require 'fs'
path = require 'path'
denodeify = require 'denodeify'
xml2js = require 'xml2js'

db = require './db'

dir = 'data/no-intro'
parser = new xml2js.Parser()

db.games = {}

(denodeify fs.readdir) dir
.then (files) ->
  Promise.all files.map (file) ->
    (denodeify fs.readFile) path.join dir, file
    .then (data) ->
      (denodeify parser.parseString) data
      .then (result) ->
        longConsoleName = result.datafile.header[0].description[0]
        [[], noIntroName, company, [], consoleName] = longConsoleName.match ///
          ((. * ? ) \s - \s(? : (. * ) \s - \s)? (. * ))\sParent-Clone
        ///

        result.datafile.game.forEach (game) ->
          longName = game.description[0]

          # Using official no-intro naming conventions
          # http://datomatic.no-intro.org/stuff/The%20Official%20No-Intro%20Convention%20(20071030).zip
          noIntroROM = ///
            (? : \[([^\]] * ) \]\s)? # BIOS prefix
            ([^\) ] * ) \s\(([^\) ] * ) \) # name followed by region
            (? : \s\(([^\) ] * ) \))?
            (? : \s\(([^\) ] * ) \))?
            (? : \s\(([^\) ] * ) \))?
            (? : \s\(([^\) ] * ) \))?
            (? : \s\(([^\) ] * ) \))?
            (? : \s\(([^\) ] * ) \))?
            (? : \s\[([^\]] * ) \])?
          ///

          [[], bios, name, region, misc...] = longName.match noIntroROM
          gameName = name
          if game.$.cloneof
            match = game.$.cloneof.match noIntroROM
            if not match
              gameName = game.$.cloneof
            else
              gameName = match[2]
          if not db.games[gameName]
            db.games[gameName] =
              roms: []
          [[], title1, title2] = gameName.match /(?:(.*) - )?(.*)/
          title = title2
          subtitle = null
          if title1
            title = title1
            subtitle = title2
          db.games[gameName].name = gameName
          db.games[gameName].title = title if title
          db.games[gameName].subtitle = subtitle if subtitle
          db.games[gameName].bios = if bios then true else false
          region = game.release[0].$.region if game.release
          db.games[gameName].roms.push
            region: region
            file_name: game.rom[0].$.name
            size: parseInt game.rom[0].$.size
            md5: parseInt game.rom[0].$.md5, 16
            crc: parseInt game.rom[0].$.crc, 16
            sha1: parseInt game.rom[0].$.sha1, 16
            nointro_name: longName
            console: consoleName
.then ->
  (denodeify fs.writeFile) './db.json', JSON.stringify db
.catch console.error
