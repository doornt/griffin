const path = require('path');
let output = path.resolve(__dirname, '.') + '/dist'

let testRenderPath = path.resolve(path.join(__dirname, '../../..', 'GriffinWeb/packages/griffin-render/'))

module.exports = env => {
    return {
        entry: {
            index: './Source/index.ts',
            detail: './Source/detail.ts'
        },
        output: {
            path: output,
            filename: '[name].js'
        },
        module: {
            rules: [
                { test: /\.pug$/, use: 'griffin-loader' },
                { test: /\.ts$/, use: 'ts-loader' }

            ]
        },
        resolve: {
            alias: {
                "griffin-render": testRenderPath
            }
        },
        watch: true
    };

}