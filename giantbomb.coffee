url = require 'url'
denodeify = require 'denodeify'
fs = require 'fs'
db = require './db'

fetch = require 'node-fetch'

requests = (Object.keys db.games).map (name) ->
  ->
    game = db.games[name]
    return if game.giantbomb_id
    fetch url.format
      protocol: 'http'
      hostname: 'www.giantbomb.com'
      pathname: 'api/search'
      query:
        api_key: 'c2355142693b4018d6b4ef365833d7e8193f96fd'
        format: 'json'
        field_list: 'id,image,deck'
        limit: 1
        resources: 'game'
        query: game.name
    .then (response) ->
      response.json()
    .then (search) ->
      if search.error != 'OK'
        throw search.error
      info = search.results[0]
      if info
        game.giantbomb_id = info.id
        game.summary = info.deck
        game.giantbomb_image = info.image.small_url if info.image
.reduce (prev, val) ->
  prev.then val
, Promise.resolve()
.catch (err) ->
  console.error err
  return
.then ->
  (denodeify fs.writeFile) './db.json', JSON.stringify db
