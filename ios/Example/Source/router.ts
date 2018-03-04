
import { Router } from 'griffin-render';
import { TestAComponent } from './testa';
import {TestBComponent } from './detail';

let router = new Router()

router.use('/',ctx=>{
    ctx.render(TestAComponent)
})

router.use('/detail',ctx=>{
    console.log('on detail')
    ctx.render(TestBComponent)
})

export default router