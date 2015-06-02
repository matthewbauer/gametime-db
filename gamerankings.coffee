fs = require 'fs'
path = require 'path'

db = require './db'

cheerio = require 'cheerio'

parse = (dir) ->
  fs.readdir dir, (err, files) ->
    for file in files
      fs.readFile (path.join dir, file), (err, data) ->
        $ = cheerio.load data
        $('.pod .body table tr').each ->
          col1 = $($(@).children()[0])
          col2 = $($(@).children()[1])
          col3 = $($(@).children()[2])
          col4 = $($(@).children()[3])

          thumb = col1.find('img').attr('src')
          platform = col2.text()
          name = col3.find('a').text()
          [publisher, year] = $(col3.contents()[2]).text().trim().split ', '
          year = parseInt year
          rating = parseFloat col4.find('span').text()
          reviews = parseInt $(col4.contents()[2]).text()

          db.run 'update or ignore Game set publisher = ?, year = ?,
                  gameranking = ?, gameranking_reviews = ? where
                  (name = ? or title = ? or subtitle = ?) and
                  gameranking is null',
                  publisher, year, rating, reviews, name, name, name

parse path.join 'data', 'gamerankings', 'best'
parse path.join 'data', 'gamerankings', 'worst'
for letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split ''
  parse path.join 'data', 'gamerankings', 'all', letter
