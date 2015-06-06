db = require '../db'
should = require 'should'

tables =
  game:
    title: [
      'Aerobiz Supersonic'
      'Super Metroid'
      'Super Mario World'
      'PowerFest 94'
      'Super Mario Kart'
    ]
  company:
    name: ['Nintendo']
  console:
    name: [
      'Super Nintendo Entertainment System'
      'Nintendo Entertainment System'
    ]

for tablename, table of tables
  describe "Looking through #{tablename}", ->
    for column, fields of table
      for field in fields
        do (tablename, column, field) ->
          it "#{field} should be in #{tablename}", (done) ->
            db.get "select * from #{tablename} where #{column} = '#{field}'",
            (err, row) ->
              should.not.exist err
              should.exist row
              if tablename is 'game'
                row.should.have.property('giantbomb_id').and.be.a.Number
                row.should.have.property('giantbomb_image')
                row.should.have.property('gameranking').and.be.a.Number
              done()
