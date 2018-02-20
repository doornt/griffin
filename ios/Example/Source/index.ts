
import { BaseComponent } from 'griffin-render'

import { router } from './app'

let pugJson = require(__dirname + '/template/index.pug')

declare var modal: any;

export class TestAComponent extends BaseComponent {

    constructor() {
        super();
        this.template = pugJson
    }

    clickclick() {
        console.log('jump to detail')
        router.push({ name: "testb" })
    }

    onAdded(){
        console.log("TestAComponent onAdded")
        super.onAdded()
        this.setState({})
    }
}

// launchWithComponent(new TestAComponent())