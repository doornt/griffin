let express = require('express');
let app = express();
let fs = require('fs');
let watchFile = require('./watch-file.js')
const http = require('http');

const WebSocket = require('ws');

let eventEmitter = watchFile.eventEmitter

function getFileContent(string) {
    return fs.readFileSync(string, 'utf-8');
}

app.use(function (req, res, next) {
    if (req.query.isFirst === "1") {
        let bundleContent = getFileContent("./bundle.js");
        res.json({ data: bundleContent })
    } else {
        eventEmitter.on('fileChanged', function () {
            next()
        });
    }
});

app.get('/', function (req, res, next) {
    let bundleContent = getFileContent("./bundle.js");
    res.json({ data: bundleContent })
})

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

    };
});


server.listen(8081, function () {

    let host = server.address().address
    let port = server.address().port

    console.log("应用实例，访问地址为 http://%s:%s", host, port)

})