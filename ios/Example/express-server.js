let express = require('express');
let app = express();
let fs = require('fs');
// let watchFile = require('./watch-file.js')
const http = require('http');

const webpack = require('webpack')

const WebSocket = require('ws');

var compiler = webpack(require('./webpack.config')(null))

var currentSocket = null

compiler.watch({}, (err, status) => {
    if (err) {
        console.error(err)
    } else {
        console.log("build success")
        if (currentSocket) {
            currentSocket.send('onchange')
        }
    }
})

app.use(express.static('.'))

const server = http.createServer(app);

const wsServer = new WebSocket.Server({
    server
});

wsServer.on('connection', (socket) => {

    socket.send('hello websocket')
    socket.onmessage = (msg) => {
        console.log(msg.data)
    };

    socket.onclose = () => {
        console.log("onclose")
        currentSocket = null
    };

    currentSocket = socket

});



server.listen(8081, function () {

    let host = server.address().address
    let port = server.address().port

    console.log("应用实例，访问地址为 http://%s:%s", host, port)

})