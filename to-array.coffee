fs = require 'fs'
db = require './db.json'

games = []
for game in db.games
  games.push game

games.sort (a, b) ->
  a.rating - b.rating

fs.writeFile './db.json', JSON.stringify
  games: games
