var gulp = require('gulp'),
    elm = require('gulp-elm'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'); //Concatenates files


var config = {   
    paths: {        
        css: [
            'node_modules/bootstrap/dist/css/bootstrap.min.css',
            'node_modules/bootstrap/dist/css/bootstrap-theme.min.css'            
        ],
        js: [
            'node_modules/jquery/dist/jquery.min.js',
            'node_modules/bootstrap/dist/js/bootstrap.min.js',
            'src/js/calculator.js'
        ],
        html: [
        'src/Calculator.html'
        ],
        src: 'src',
        dest: 'dest'
    }
};


gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init'], function () {
    return gulp.src('./src/Calculator.elm')
        .pipe(elm())
        .on('error', swallowError)
        .pipe(rename('calculator.js'))
        .pipe(gulp.dest('./src/js'));
});

gulp.task('copy-js-css-html', function(){    
    gulp.src(config.paths.css)
    .pipe(concat('bundle.css'))
    .pipe(gulp.dest(config.paths.dest + '/css'));

     gulp.src(config.paths.html)
    .pipe(concat('calculator.html'))
    .pipe(gulp.dest(config.paths.dest));

    return gulp.src(config.paths.js)
    .pipe(concat('bundle.js'))
    .pipe(gulp.dest(config.paths.dest + '/js'));
});

function swallowError (error) {
    console.log(error.toString());
    this.emit('end');
}

gulp.task('default', ['elm', 'copy-js-css-html'], function () {
    gulp.watch('./src/*.elm', ['elm', 'copy-js-css-html']);
});