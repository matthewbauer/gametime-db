path = require 'path'

sqlite3 = require 'sqlite3'

dbpath = path.join __dirname, 'gametime.db'
module.exports = new sqlite3.Database dbpath
