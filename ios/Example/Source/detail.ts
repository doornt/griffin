
import { BaseComponent } from 'griffin-render'
import { router } from './app'

let pugJson = require(__dirname + '/template/detail.pug')

declare var modal: any;

export class TestBComponent extends BaseComponent {

    constructor() {
        super();
        (<any>this).template = pugJson
    }

    clickclick() {
        router.pop()
    }
}

// launchWithComponent(new TestBComponent())