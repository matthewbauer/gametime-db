path = require 'path'

sqlite3 = require 'sqlite3'

module.exports = new sqlite3.Database path.join(__dirname, 'gametime.db')
