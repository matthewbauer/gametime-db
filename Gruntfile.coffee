module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    shell:
      clean:
        command: 'rm gametime.db'
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
    coffee:
      compile:
        files: [
          expand: true
          src: ['db.coffee']
          ext: '.js'
        ]
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.registerTask('db', ['shell:clean', 'shell:init_db',
                            'shell:nointro', 'shell:gamerankings'])
  grunt.registerTask('prepublish', ['build'])
  grunt.registerTask('build', ['db', 'coffee:compile'])
  grunt.registerTask('default', ['build'])
