let fs = require('fs')
let chokidar = require('chokidar')

let events = require('events');
let eventEmitter = new events.EventEmitter();

function fileWatch(filePath) {
    let watcher = chokidar.watch(filePath, {
        ignored: /[\/\\]\./,
        persistent: true
    });

    watcher.on('add', function (path) {
        console.log('FileAdd', path, 'has been added');
    });
    watcher.on('change', function (path) {
        console.log('FileChange', path, 'has been changed');
        eventEmitter.emit('fileChanged');
    });
    watcher.on('unlink', function (path) {
        console.log('FileUnlink', path, 'has been unlinked');
    });
}

let defualtDir = "dist/bundle.js"
fs.exists(defualtDir, function (exists) {
    if (exists) {
        fileWatch(defualtDir);
    } else {
        console.log(`cannot find ${defualtDir}`);
    }
});

exports.eventEmitter = eventEmitter