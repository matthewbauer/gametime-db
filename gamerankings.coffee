fs = require 'fs'
path = require 'path'

db = require './db'

cheerio = require 'cheerio'

for letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
  fs.readdir path.join('data', 'gamerankings', 'all', letter), (err, files) ->
    for file in files
      fs.readFile path.join(''), (err, data) ->
        $ = cheerio.load data
        $('.pod .body table tr').each ->
          col1 = $($(@).children()[0])
          col2 = $($(@).children()[1])
          col3 = $($(@).children()[2])
          col4 = $($(@).children()[3])

          thumb = col1.find('img').attr('src')
          platform = col2.text()
          name = col3.find('a').text()
          publisher = $(col3.contents()[2]).text().trim().split(', ')[0]
          year = parseInt $(col3.contents()[2]).text().trim().split(', ')[1]
          rating = parseFloat col4.find('span').text()
          reviews = parseInt $(col4.contents()[2]).text()

          db.run 'update or ignore Game set publisher = ? , year = ? ,
                  gameranking = ? , gameranking_reviews = ? where
                  (name = ? or title = ? or subtitle = ? ) and
                  gameranking is null',
                  publisher, year, rating, reviews, name, name, name
