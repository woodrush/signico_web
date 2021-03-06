gulp = require 'gulp'
jade = require 'gulp-jade'
watch = require 'gulp-watch'
webserver = require 'gulp-webserver'
open = require 'gulp-open'
runSequence = require('run-sequence').use(gulp)
del = require 'del'
bowerFiles = require 'main-bower-files'

jadePattern = ['src/jade/**']
assetsPattern = ['src/assets/**']

gulp.task 'clean:all', (cb) ->
      del 'dist/*', cb

gulp.task 'jade', ->
    gulp.src jadePattern
    .pipe jade
        pretty: true
    .pipe gulp.dest('dist')

gulp.task 'assets', (callback) ->
    gulp.src [
        'bower_components/**/*.css',
        'bower_components/**/*.js'
    ]
    .pipe gulp.dest('./dist/assets')
    
    gulp.src assetsPattern
    .pipe gulp.dest('./dist/assets')

gulp.task 'watch', ->
    watch jadePattern, ->
        gulp.start ['jade']
    watch assetsPattern, ->
        gulp.start ['assets']

gulp.task 'debugserver', ->
    gulp.src 'dist'
    .pipe webserver
        host: 'localhost'
        livereload: true
        port: 8000
    .pipe open
        uri: 'http://localhost:8000'

gulp.task 'webserver', ->
    gulp.src 'dist'
    .pipe webserver
        host: '0.0.0.0'
        port: 8000

gulp.task 'debug', (cb)->
    runSequence ['clean:all'], ['assets', 'jade'], ['watch', 'debugserver'], cb

gulp.task 'run', (cb)->
    runSequence ['clean:all'], ['assets', 'jade'], ['watch', 'webserver'], cb
