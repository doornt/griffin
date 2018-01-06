// swift call js with parameters and callback
function functionForSwift(param1, param2, cb) {
    cb(param1+param2*2);
}

// js call swift with parameters and callback
function functionForSwiftWithoutParam () {
    JSCoreBridge.funcForJSWithoutParam("string in jsfile")
}


NativeLog("begin",Date(Date.now()));

var DemoView = {

"background-color":"#FF0000",
    "type":"div",
width:150,
height:150,
top:64,
left:20,
overflow: 1,
opacity:1,
borderWidth:4,
borderColor:"#000000",
children:[
    {
          "background-color":"#000000",
              "type":"div",
          width:200,
          height:100,
          top:0,
          left:0,
          children:[
                    {
                    "background-color":"#00ff00",
                        "type":"div",
                    width:20,
                    height:20,
                    top:30
                    },
                    {
                    "background-color":"#0000ff",
                        "type":"div",
                    width:20,
                    height:20,
                    left:50
                    }
                    ]
    },
          {
          "background-color":"#00ff00",
              "type":"div",
          width:20,
          height:20,
          top:100
          },
          {
          "background-color":"#0000ff",
              "type":"div",
          width:20,
          height:20,
          left:100
          }
]
}

var DemoVC = {
    "background-color": "#ff0000",
        "type":"div",
    title:"DemoVC-title"
}


var DemoLabel = {
    "type":"label",
    "styles":{
text:"hello world",
    
top:100,
left:10
}
}

var DemoImageView = {
imageUrl:"https://op.meituan.net/oppkit_pic/2ndfloor_portal_headpic/157e291c008894a2db841f0dda0d64c.png",
        "type":"img",
top:100,
left:100,
width:200,
height:300,
cornerRadius:20
}

var rootView = {
    "type":"div",
        "styles":{
    "background-color":"#FF0000",
        
    height:300,
    width:300,
    top:70,
    left:0
    }
}
var DemoLabel1 = {
    "type":"label",
    "styles":{
        text:"hello w11orld",
        top:200
    }
}

createRootView("0")

//for (i = 0; i < 100000;i++)
//{
//    createLabel("22",DemoLabel)
//}
var label = createElement("2",DemoLabel)
//var view = createElement("1",rootView)
//var imageView = createElement("3",DemoImageView)

function func1() {
    var a = 100,b=200;
    
    NativeLog(a+b);
    updateView("2", DemoLabel1);
}

function func2() {
    var a = 100,b=200;
    
    NativeLog(a+b);
    updateView("2", DemoLabel1);
}

function func3() {
    
    
    NativeLog("view will appear in js");
    
}
function dispatchEventToJs(id, event) {
    
    
    NativeLog(id, event["type"]);
    
}

setTimeout(func2, 57000000)

registerEvent("2","click", func1)
//unRegisterEvent("2","click", func1)

addSubview("0","2")

//createImageView(DemoImageView)

//runWithModule(DemoView)
NativeLog("end",Date(Date.now()));
