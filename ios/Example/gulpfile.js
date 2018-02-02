const gulp = require('gulp');
const webpack = require("webpack");
const webpackConfig = require("./webpack.config.js");
const cp = require('child_process');


gulp.task('webpack', (cb) => {
    "use strict";
    webpack(webpackConfig({})).run((err, stats) => {
        if (err) {
            console.log("webpack failed")
        }
        cb();
    })
})

gulp.task('server', function () {
    cp.exec('node ./express-server.js', function (err, stdout, stderr) {
        console.log(stdout);
        console.log(stderr);
    });
});

gulp.task('dev', ['server', 'webpack']);