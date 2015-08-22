fs = require 'fs'
path = require 'path'

xml2js = require 'xml2js'

db = require './db'

dir = 'data/no-intro'
parser = new xml2js.Parser()

fs.readdir dir, (err, files) ->
  Promise.all files.map (file) ->
    new Promise (resolve, reject) ->
      fs.readFile path.join dir, file, (err, data) ->
        parser.parseString data, (err, result) ->
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

            db.games[gameName].title = title
            db.games[gameName].subtitle = subtitle
            db.games[gameName].bios = bios

            region = null
            if game.release
              region = game.release[0].$.region
              db.run 'insert or ignore into Region (name) values (?)', region

            db.games[gameName].roms.push
              region: game.release[0].$.region
              file_name: game.rom[0].$.name
              size: parseInt game.rom[0].$.size
              md5: parseInt game.rom[0].$.md5, 16
              crc: parseInt game.rom[0].$.crc, 16
              sha1: parseInt game.rom[0].$.sha1, 16
              nointro_name: longName
              console: consoleName
