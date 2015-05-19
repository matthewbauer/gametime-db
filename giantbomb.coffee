request = require 'request'
async = require 'async'
url = require 'url'

db = require './db'

db.all 'select name from Game where gameranking not null and giantbomb_id is null', (err, games) ->
  return if err or not games
  async.eachSeries games, (game, callback) ->
    resource = url.format
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
    request resource, (err, response, body) ->
      console.log body
      if not err and response.statusCode == 200
        search = JSON.parse body
        info = search.results[0]
        if search.error is 'Rate limit exceeded.  Slow down cowboy.'
          callback(search.error)
          return
        if info
          image = null
          if info.image
            image = info.image.small_url
          db.run 'update Game set giantbomb_id = ?, summary = ?,
                  giantbomb_image = ? where name = ?', info.id, info.deck,
                  image, game.name, callback
          return
      callback()
