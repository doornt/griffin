const path = require('path');
let output = path.resolve(__dirname, '.') + '/dist'

let testRenderPath = path.resolve(path.join(__dirname, '../../..', 'GriffinWeb/packages/griffin-render/'))
let testLoadPath = path.resolve(path.join(__dirname, '../../..', 'GriffinWeb/packages/griffin-loader/'))

module.exports = env => {
    return {
        entry: {
            bundle: './Source/app.ts'
        },
        output: {
            filename: '[name].js'
        },
        module: {
            rules: [
                { test: /\.pug$/, use: testLoadPath },
                { test: /\.ts$/, use: 'ts-loader' }

            ]
        },
        resolve: {
            alias: {
                'griffin-loader': testLoadPath,
                "griffin-render": testRenderPath
            },
            extensions: [".ts", ".js", ".json", "pug"]

        },
        watch: true
    };

}