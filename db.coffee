sqlite3 = require 'sqlite3'
path = require 'path'
module.exports = new sqlite3.Database path.join(__dirname, 'gametime.db')
