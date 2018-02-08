
import { BaseComponent, launchWithComponent } from 'griffin-render'

let pugJson = require(__dirname + '/template/detail.pug')

declare var modal: any;

export class TestBComponent extends BaseComponent {

    constructor() {
        super(pugJson)
    }

    clickclick() {

        (<any>global).navigator.pop({
            animated: true
        }, event => {
            modal.toast({ message: 'callback: ' + event })
        })
    }
}

// launchWithComponent(new TestBComponent())