
import { Router } from 'griffin-render';
import { TestAComponent } from './testa';

let router = new Router()

router.use('/',ctx=>{
    ctx.render(TestAComponent)
})

export default router