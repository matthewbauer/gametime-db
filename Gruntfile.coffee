module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    shell:
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
          require: [
            'coffee-script/register'
            'coffee-coverage/register-istanbul'
          ]
        src: 'spec/*'
    coveralls:
      default:
        src: 'coverage/*.info'
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
  grunt.registerTask 'build', ['db', 'coffee:compile']
  grunt.registerTask 'default', ['build', 'test']
