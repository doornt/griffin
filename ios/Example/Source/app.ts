
import { TestAComponent } from './index';
import { TestBComponent } from './detail';


import {Router} from "griffin-render"

let router = new Router({
    routes:[{
        name:"testa",
        component:TestAComponent
    },{
        name:"testb",
        component:TestBComponent
    }],
    default:"testa"
})

router.run()