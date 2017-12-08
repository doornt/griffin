// swift call js with parameters and callback
function functionForSwift(param1, param2, cb) {
    cb(param1+param2*2);
}

// js call swift with parameters and callback
function functionForSwiftWithoutParam () {
    JSCoreBridge.funcForJSWithoutParam("string in jsfile")
}
