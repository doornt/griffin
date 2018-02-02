const path = require('path');
let output = path.resolve(__dirname, '.')

module.exports = env =>{
    return {
        entry: './Source/main.ts',
        output: {
            path: output,
            filename: 'bundle.js'
        },
        module: {
            rules: [
                { test: /\.pug$/, use: 'griffin-loader' },
                { test: /\.ts$/, use: 'ts-loader' }
                
            ]
        }
    };
    
}