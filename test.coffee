db = require './db'
should = require 'should'

tables =
  game:
    title: ['Super Mario World', 'Super Metroid', 'Super Mario Bros. 3']
  company:
    name: ['Nintendo', 'Sega', 'Microsoft', 'Atari']
  console:
    name: ['Super Nintendo Entertainment System', 'Virtual Boy']

for tablename, table of tables
  describe "Looking through #{tablename}", ->
    for column, fields of table
      for field in fields
        do (tablename, column, field) ->
          it "#{field} should be in #{tablename}", (done) ->
            db.get "select * from #{tablename} where #{column} = '#{field}'", (err, row) ->
              should.not.exist err
              should.exist row
              if tablename is 'game'
                row.should.have.property('giantbomb_id').and.be.a.Number
              done()
