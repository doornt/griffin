// swift call js with parameters and callback
function functionForSwift(param1, param2, cb) {
    cb(param1+param2*2);
}

// js call swift with parameters and callback
function functionForSwiftWithoutParam () {
    JSCoreBridge.funcForJSWithoutParam("string in jsfile")
}



var DemoView = {

backgroundColor:"#FF0000",
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
          backgroundColor:"#000000",
          width:200,
          height:100,
          top:0,
          left:0,
          children:[
                    {
                    backgroundColor:"#00ff00",
                    width:20,
                    height:20,
                    top:30
                    },
                    {
                    backgroundColor:"#0000ff",
                    width:20,
                    height:20,
                    left:50
                    }
                    ]
    },
          {
          backgroundColor:"#00ff00",
          width:20,
          height:20,
          top:100
          },
          {
          backgroundColor:"#0000ff",
          width:20,
          height:20,
          left:100
          }
]
}

var DemoVC = {
    backgroundColor: "#ff0000",
    title:"DemoVC-title"
}

var DemoLabel = {
backgroundColor: "#ffffff",
text:"hello world",
top:0,
left:0,
width:200,
height:30,
textColor:"#000000",
    cornerRadius:20
}

var DemoImageView = {
imageUrl:"https://op.meituan.net/oppkit_pic/2ndfloor_portal_headpic/157e291c008894a2db841f0dda0d64c.png",
top:100,
left:100,
width:200,
height:300,
cornerRadius:20
}

var rootView = {
    
backgroundColor:"#FF0000",
height:300,
top:70,
left:0,
cornerRadius:30
}

var label = createLabel(DemoLabel)
var view = createView(rootView)
var imageView = createView(DemoImageView)

setRootView(view)
addSubview(view,label)
//createImageView(DemoImageView)

//runWithModule(DemoView)

