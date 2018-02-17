
import { BaseComponent, launchWithComponent } from 'griffin-render'
import { router } from './app'

let pugJson = require(__dirname + '/template/index.pug')

declare var modal: any;

export class TestAComponent extends BaseComponent {

    constructor() {
        super();
        (<any>this).template = pugJson
    }

    clickclick() {
        console.log('jump to detail')
        router.push({ name: "testb" })
    }
}

// launchWithComponent(new TestAComponent())