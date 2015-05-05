db = require('./db')
should = require('should')

describe 'using db', ->
  it 'should have super mario world', ->
    db.get 'select * from game where title = "Super Mario World"', (err, row) ->
      should.not.exist(err)
      should.exist(row)
