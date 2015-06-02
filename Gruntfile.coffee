module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    shell:
      init_db:
        command: '[ -e gametime.db ] || sqlite3 gametime.db < db.sql'
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
        src: 'spec/*'
    coffee:
      compile:
        files: [
          expand: true
          src: ['db.coffee']
          ext: '.js'
        ]

  grunt.registerTask 'db', ['shell:init_db', 'shell:nointro',
                            'shell:gamerankings', 'shell:giantbomb']
  grunt.registerTask 'prepublish', ['coffee:compile']
  grunt.registerTask 'test', ['mochaTest']
  grunt.registerTask 'build', ['db', 'coffee:compile', 'test']
  grunt.registerTask 'default', ['build']
