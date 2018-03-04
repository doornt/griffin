
import { BaseComponent } from 'griffin-render'

let pugJson = require(__dirname + '/template/detail.pug')

declare var modal: any;

export class TestBComponent extends BaseComponent {

    constructor() {
        super();
        (<any>this).template = pugJson
    }

    clickclick() {
        this.goback()
        console.log('click go back')
    }
}
