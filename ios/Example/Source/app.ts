
import  GN from "griffin-render"

import router from './router';

const app = new GN()

app.use(router)

app.run()