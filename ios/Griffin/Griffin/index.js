// swift call js with parameters and callback
function functionForSwift(param1, param2, cb) {
    cb(param1+param2*2);
}

// js call swift with parameters and callback
function functionForSwiftWithoutParam () {
    JSCoreBridge.funcForJSWithoutParam("string in jsfile")
}



var DemoView = {

backgroundColor:"#FFFFFF",
width:900,
height:900,
children:[
    {
    backgroundColor:"#000000",
          width:100,
          height:100
    }
]
}


runWithModule(DemoView)

