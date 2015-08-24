db = require './db'
should = require 'should'

games = [
  'Aerobiz'
  'Super Metroid'
  'Super Mario World'
  'PowerFest 94 - Ken Griffey Jr. Presents Major League Baseball'
  'Super Mario Kart'
]

describe 'Looking for games', ->
  for index, game of games
    do (game) ->
      it "#{game} should have all props", ->
        should.exist db.games[game]
        should.exist db.games[game].giantbomb_id
        should.exist db.games[game].giantbomb_image
