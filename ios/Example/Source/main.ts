
import { BaseComponent, launchWithComponent} from 'griffin-render'

let pugJson = require(__dirname + '/template/main.pug')

declare var modal:any;

class TestAComponent extends BaseComponent {

    constructor() {
        super(pugJson)
    }

    clickclick() {
        (<any>global).navigator.push({
            url: 'http://dotwe.org/raw/dist/519962541fcf6acd911986357ad9c2ed.js',
            animated: true
        }, event => {
            modal.toast({ message: 'callback: ' + event })
        })
    }
}

let ws = new WebSocket('ws://127.0.0.1:8081')
ws.send('from native')
console.log(ws.onmessage)
;(<any>ws).onmessage = str => console.log(str)

launchWithComponent(new TestAComponent())