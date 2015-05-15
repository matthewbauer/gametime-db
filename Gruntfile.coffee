module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    shell:
      clean:
        command: '[ -e gametime.db ] && rm gametime.db'
      init_db:
        command: 'sqlite3 gametime.db < db.sql'
      nointro:
        command: 'coffee nointro.coffee'
      fetch:
        command: 'sh fetch.sh'
      giantbomb:
        command: 'coffee giantbomb.coffee'
      gamerankings:
        command: 'coffee gamerankings.coffee'
    mochaTest:
      test:
        options:
          reporter: 'spec',
          require: 'coffee-script/register'
        src: ['test.coffee']
    coffee:
      compile:
        files: [
          expand: true
          src: ['db.coffee']
          ext: '.js'
        ]

  grunt.registerTask 'db', ['shell:clean', 'shell:init_db', 'shell:nointro',
                            'shell:gamerankings', 'shell:giantbomb']
  grunt.registerTask 'prepublish', ['build']
  grunt.registerTask 'test', ['mochaTest']
  grunt.registerTask 'build', ['db', 'coffee:compile']
  grunt.registerTask 'default', ['build', 'test']
