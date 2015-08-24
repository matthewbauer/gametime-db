fs = require 'fs'
path = require 'path'
denodeify = require 'denodeify'

db = require './db'

cheerio = require 'cheerio'

parse = (dir) ->
  (denodeify fs.readdir) dir
  .then (files) ->
    Promise.all files.map (file) ->
      (denodeify fs.readFile) path.join dir, file
      .then (data) ->
        $ = cheerio.load data
        $('.pod .body table tr').each ->
          col1 = $ ($ @).children()[0]
          col2 = $ ($ @).children()[1]
          col3 = $ ($ @).children()[2]
          col4 = $ ($ @).children()[3]

          name = (col3.find 'a').text()
          [publisher, year] = ($ col3.contents()[2]).text().trim().split ', '

          game = undefined
          game = db.games[name] if db.games[name]
          if not game
            for key, value of db.games
              if key.indexOf name != -1
                game = value
                break
          return if not game

          game.thumb = (col1.find 'img').attr 'src'
          game.platform = col2.text()
          game.publisher = publisher
          game.year = parseInt year
          game.rating = parseFloat (col4.find 'span').text()
          game.reviews = parseInt ($ col4.contents()[2]).text()

Promise.all [
  parse path.join 'data', 'gamerankings', 'best'
  parse path.join 'data', 'gamerankings', 'worst'
].concat 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map (letter) ->
  parse path.join 'data', 'gamerankings', 'all', letter
.then ->
  (denodeify fs.writeFile) './db.json', JSON.stringify db
.catch console.error
