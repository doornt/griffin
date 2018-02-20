
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
        // this.setState({})
        fetch('http://api.yatessss.com:8888/news-at/api/4/news/latest').then(data=>{
            console.log(JSON.stringify(data))
        })
    }
}

// launchWithComponent(new TestAComponent())