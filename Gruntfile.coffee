module.exports = (grunt) ->
  grunt.initConfig require('./grunt')(grunt)

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'build-test', ['clean:test', 'coffee:test']
  grunt.registerTask 'build', ['clean:module', 'coffee:module', 'uglify:module']
  grunt.registerTask 'test', ['clean:coverage', 'env:coverage', 'instrument', 'mochaTest', 'storeCoverage', 'makeReport']
