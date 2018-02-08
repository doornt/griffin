
import { BaseComponent, launchWithComponent } from 'griffin-render'

let pugJson = require(__dirname + '/template/index.pug')

declare var modal: any;

export class TestAComponent extends BaseComponent {

    constructor() {
        super(pugJson)
    }

    clickclick() {

        (<any>global).navigator.push({
            url: 'http://127.0.0.1:8081/dist/detail.js',
            animated: true
        }, event => {
            modal.toast({ message: 'callback: ' + event })
        })

        console.log("vcl")
    }
}

// launchWithComponent(new TestAComponent())