/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 5);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var ETaskType;
(function (ETaskType) {
    ETaskType["VIEW"] = "view";
    ETaskType["ROOT"] = "create_root";
})(ETaskType = exports.ETaskType || (exports.ETaskType = {}));
var EViewTask;
(function (EViewTask) {
    EViewTask["CREATE_VIEW"] = "create_view";
    EViewTask["CREATE_LABEL"] = "create_label";
    EViewTask["SET_ROOT"] = "set_root";
    EViewTask["ADD_CHILD"] = "add_child";
    EViewTask["ADD_SUBVIEW"] = "add_subview";
})(EViewTask = exports.EViewTask || (exports.EViewTask = {}));


/***/ }),
/* 1 */
/***/ (function(module, exports) {

var g;

// This works in non-strict mode
g = (function() {
	return this;
})();

try {
	// This works if eval is allowed (see CSP)
	g = g || Function("return this")() || (1,eval)("this");
} catch(e) {
	// This works if the window reference is available
	if(typeof window === "object")
		g = window;
}

// g can still be undefined, but nothing to do about it...
// We return undefined, instead of nothing here, so it's
// easier to handle this case. if(!global) { ...}

module.exports = g;


/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {
Object.defineProperty(exports, "__esModule", { value: true });
var Task_1 = __webpack_require__(0);
var TaskManager = /** @class */ (function () {
    function TaskManager() {
    }
    Object.defineProperty(TaskManager, "instance", {
        get: function () {
            this.$inst = this.$inst || new TaskManager;
            return this.$inst;
        },
        enumerable: true,
        configurable: true
    });
    TaskManager.prototype.init = function () {
    };
    TaskManager.prototype.send = function (type, e) {
        switch (type) {
            case Task_1.ETaskType.VIEW:
                this.$sendView(e);
                break;
            case Task_1.ETaskType.ROOT:
                this.$createRoot(e.nodeId);
                break;
        }
    };
    TaskManager.prototype.$sendView = function (e) {
        switch (e.action) {
            case Task_1.EViewTask.CREATE_VIEW:
                this.$createView(e.nodeId, e.data);
                break;
            case Task_1.EViewTask.CREATE_LABEL:
                this.$createText(e.nodeId, e.data);
                break;
            case Task_1.EViewTask.ADD_SUBVIEW:
                this.$addSubview(e.parentId, e.nodeId);
                break;
            case Task_1.EViewTask.ADD_CHILD:
                this.$addChild(e.parentId || e.nodeId, e.data);
                break;
            default:
                break;
        }
    };
    TaskManager.prototype.$createView = function (selfId, attr) {
        console.log("createView call:", selfId, JSON.stringify(attr));
        return global.createView(selfId, attr);
    };
    TaskManager.prototype.$createText = function (selfId, attr) {
        console.log("createText call:", selfId, JSON.stringify(attr));
        return global.createLabel(selfId, attr);
    };
    TaskManager.prototype.$addChild = function (parentId, childAttr) {
        return global.$addChild && global.$addChild(parentId, childAttr);
    };
    TaskManager.prototype.$addSubview = function (parentId, childId) {
        console.log("addSubview call:", parentId, childId);
        return global.addSubview(parentId, childId);
    };
    TaskManager.prototype.$createRoot = function (nodeId) {
        console.log("createRoot call:", nodeId);
        return global.createRootView(nodeId);
    };
    TaskManager.$inst = null;
    return TaskManager;
}());
exports.TaskManager = TaskManager;

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var TaskManager_1 = __webpack_require__(2);
var Task_1 = __webpack_require__(0);
var NodeID_1 = __webpack_require__(4);
var RenderComponent = /** @class */ (function () {
    function RenderComponent(attrs) {
        this.$children = [];
        this.$attr = {};
        this.$instanceId = null;
        this.$attrs = attrs || [];
        for (var _i = 0, _a = this.$attrs; _i < _a.length; _i++) {
            var attr = _a[_i];
            attr.val = attr.val.replace(/\"/g, "");
            this.$buildAttr(attr);
        }
        this.$instanceId = NodeID_1.generateID();
        this.createView();
    }
    Object.defineProperty(RenderComponent.prototype, "id", {
        get: function () {
            return this.$instanceId;
        },
        enumerable: true,
        configurable: true
    });
    RenderComponent.prototype.createView = function () {
        TaskManager_1.TaskManager.instance.send(Task_1.ETaskType.VIEW, {
            action: Task_1.EViewTask.CREATE_VIEW,
            nodeId: this.id,
            data: this.$attr
        });
    };
    RenderComponent.prototype.$render = function () {
        this.$children.map(function (item) { return item.$render(); });
    };
    RenderComponent.prototype.addChild = function (child) {
        if (!child) {
            return;
        }
        this.$children.push(child);
        TaskManager_1.TaskManager.instance.send(Task_1.ETaskType.VIEW, {
            action: Task_1.EViewTask.ADD_SUBVIEW,
            parentId: this.id,
            nodeId: child.id,
            data: null
        });
    };
    RenderComponent.prototype.$buildAttr = function (attr) {
        switch (attr.name) {
            case "width":
            case "height":
            case "left":
            case "top":
                var n = parseInt(attr.val);
                this.$attr[attr.name] = n;
                break;
            default:
                this.$attr[attr.name] = attr.val;
        }
    };
    return RenderComponent;
}());
exports.RenderComponent = RenderComponent;


/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var current = 0;
function generateID() {
    return (current++).toString();
}
exports.generateID = generateID;


/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

const {BaseComponent,launchWithComponent} = __webpack_require__(6)

let list = __webpack_require__(15)

class TestAComponent extends BaseComponent{
    
    constructor(){
        super(list)
    }

    render(){
        console.error(this.ast)
    }
}

launchWithComponent(new TestAComponent())

/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var BaseComponent_1 = __webpack_require__(7);
exports.BaseComponent = BaseComponent_1.BaseComponent;
var Application_1 = __webpack_require__(11);
var launchWithComponent = function (view) {
    Application_1.Application.instance.runWithModule(view);
};
exports.launchWithComponent = launchWithComponent;
Application_1.Application.instance.init();


/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {
Object.defineProperty(exports, "__esModule", { value: true });
var ComponentManager_1 = __webpack_require__(8);
var AstManager_1 = __webpack_require__(9);
var RenderComponent_1 = __webpack_require__(3);
var BaseComponent = /** @class */ (function () {
    function BaseComponent(ast) {
        ComponentManager_1.ComponentManager.instance.autoRegister(this.constructor.name, this.constructor);
        this.$ast = new AstManager_1.AstManager(ast);
        this.$rebuildAst();
        this.init();
        this.viewDidLoad();
    }
    BaseComponent.prototype.$rebuildAst = function () {
        var children = this.$ast.compile({});
        if (children.length == 1) {
            this.$view = children[0];
        }
        else {
            this.$view = new RenderComponent_1.RenderComponent(null);
            for (var _i = 0, children_1 = children; _i < children_1.length; _i++) {
                var child = children_1[_i];
                this.$view.addChild(child);
            }
        }
    };
    Object.defineProperty(BaseComponent.prototype, "id", {
        get: function () {
            return this.$view.id;
        },
        enumerable: true,
        configurable: true
    });
    BaseComponent.prototype.init = function () {
        // this.$renders = this.$nodes.map(node=>{
        //     return new RenderComponent(node)
        // })
        console.log(global);
        setTimeout(function () {
            console.log("timeout");
        }, 1000);
    };
    BaseComponent.prototype.viewDidLoad = function () {
        // this.$renders.map(item=>item.$render())
    };
    return BaseComponent;
}());
exports.BaseComponent = BaseComponent;

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var ComponentManager = /** @class */ (function () {
    function ComponentManager() {
        this._registeredClass = {};
    }
    Object.defineProperty(ComponentManager, "instance", {
        get: function () {
            if (!this.$inst) {
                this.$inst = new ComponentManager();
            }
            return this.$inst;
        },
        enumerable: true,
        configurable: true
    });
    ComponentManager.prototype.autoRegister = function (name, ctr) {
        this._registeredClass[name] = ctr;
    };
    return ComponentManager;
}());
exports.ComponentManager = ComponentManager;


/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var RenderComponent_1 = __webpack_require__(3);
var TextComponent_1 = __webpack_require__(10);
var AstManager = /** @class */ (function () {
    function AstManager(ast) {
        this.$inputData = {};
        this.$ast = ast;
    }
    AstManager.prototype.compile = function (data) {
        this.$inputData = data || {};
        // let root:RenderComponent = null
        var children = [];
        for (var _i = 0, _a = this.$ast.nodes; _i < _a.length; _i++) {
            var node = _a[_i];
            children.push(this.$visitNode(node));
        }
        return children;
    };
    AstManager.prototype.$visitNode = function (node) {
        var view = null;
        switch (node.type) {
            case "block":
                view = this.$visitBlock(node);
                break;
            case "Text":
                view = this.$visitText(node);
                break;
            default:
                view = this.$visitTag(node);
                var block = node.block;
                if (block) {
                    var children = new AstManager(block).compile(this.$inputData);
                    for (var _i = 0, children_1 = children; _i < children_1.length; _i++) {
                        var child = children_1[_i];
                        view.addChild(child);
                    }
                }
                break;
        }
        return view;
    };
    AstManager.prototype.$visitBlock = function (node) {
    };
    AstManager.prototype.$visitText = function (node) {
        node.attrs = node.attrs || [];
        node.attrs.push({ name: "text", val: node.val });
        return new TextComponent_1.TextComponent(node.attrs);
    };
    AstManager.prototype.$visitTag = function (node) {
        var view = null;
        switch (node.name) {
            default:
                view = new RenderComponent_1.RenderComponent(node.attrs);
                break;
        }
        return view;
    };
    return AstManager;
}());
exports.AstManager = AstManager;


/***/ }),
/* 10 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
var RenderComponent_1 = __webpack_require__(3);
var TaskManager_1 = __webpack_require__(2);
var Task_1 = __webpack_require__(0);
var TextComponent = /** @class */ (function (_super) {
    __extends(TextComponent, _super);
    function TextComponent(attrs) {
        return _super.call(this, attrs) || this;
    }
    TextComponent.prototype.createView = function () {
        TaskManager_1.TaskManager.instance.send(Task_1.ETaskType.VIEW, {
            action: Task_1.EViewTask.CREATE_LABEL,
            nodeId: this.id,
            data: this.$attr
        });
    };
    return TextComponent;
}(RenderComponent_1.RenderComponent));
exports.TextComponent = TextComponent;


/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {
Object.defineProperty(exports, "__esModule", { value: true });
var setup_1 = __webpack_require__(12);
var TaskManager_1 = __webpack_require__(2);
var RootView_1 = __webpack_require__(14);
var Task_1 = __webpack_require__(0);
var Application = /** @class */ (function () {
    function Application() {
        this.$root = null;
    }
    Object.defineProperty(Application, "instance", {
        get: function () {
            if (!this.$inst) {
                this.$inst = new Application;
            }
            return this.$inst;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Application, "env", {
        get: function () {
            return global.Environment;
        },
        enumerable: true,
        configurable: true
    });
    Application.prototype.init = function () {
        setup_1.setup();
        TaskManager_1.TaskManager.instance.init();
        this.$root = RootView_1.RootView.create();
    };
    Application.prototype.runWithModule = function (view) {
        TaskManager_1.TaskManager.instance.send(Task_1.ETaskType.VIEW, {
            parentId: this.$root.id,
            nodeId: view.id,
            action: Task_1.EViewTask.ADD_SUBVIEW
        });
    };
    Application.$inst = null;
    return Application;
}());
exports.Application = Application;

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ }),
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var Console_1 = __webpack_require__(13);
function setup() {
    Console_1.setConsole();
}
exports.setup = setup;


/***/ }),
/* 13 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {
Object.defineProperty(exports, "__esModule", { value: true });
function setConsole() {
    if (global.Environment && global.Environment != 'web') {
        global.console = {
            log: function () {
                var args = [];
                for (var _i = 0; _i < arguments.length; _i++) {
                    args[_i] = arguments[_i];
                }
                global.NativeLog.apply(global, args.concat(["__LOG"]));
            },
            info: function () {
                var args = [];
                for (var _i = 0; _i < arguments.length; _i++) {
                    args[_i] = arguments[_i];
                }
                global.NativeLog.apply(global, args.concat(["__INFO"]));
            },
            warn: function () {
                var args = [];
                for (var _i = 0; _i < arguments.length; _i++) {
                    args[_i] = arguments[_i];
                }
                global.NativeLog.apply(global, args.concat(["__WARN"]));
            },
            error: function () {
                var args = [];
                for (var _i = 0; _i < arguments.length; _i++) {
                    args[_i] = arguments[_i];
                }
                global.NativeLog.apply(global, args.concat(["__ERROR"]));
            }
        };
    }
}
exports.setConsole = setConsole;

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(1)))

/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var TaskManager_1 = __webpack_require__(2);
var Task_1 = __webpack_require__(0);
var NodeID_1 = __webpack_require__(4);
var RootView = /** @class */ (function () {
    function RootView() {
        this.$instanceId = null;
        this.$instanceId = NodeID_1.generateID();
        TaskManager_1.TaskManager.instance.send(Task_1.ETaskType.ROOT, { nodeId: this.$instanceId });
    }
    Object.defineProperty(RootView.prototype, "id", {
        get: function () {
            return this.$instanceId;
        },
        enumerable: true,
        configurable: true
    });
    RootView.create = function () {
        return new RootView();
    };
    return RootView;
}());
exports.RootView = RootView;


/***/ }),
/* 15 */
/***/ (function(module, exports) {

module.exports = {"type":"Block","nodes":[{"type":"Tag","name":"div","selfClosing":false,"block":{"type":"Block","nodes":[{"type":"Tag","name":"div","selfClosing":false,"block":{"type":"Block","nodes":[],"line":2},"attrs":[{"name":"class","val":"'tst2'","line":2,"column":5,"mustEscape":false},{"name":"backgroundColor","val":"\"#0000FF\"","line":2,"column":11,"mustEscape":true},{"name":"width","val":"50","line":2,"column":37,"mustEscape":true},{"name":"height","val":"50","line":2,"column":46,"mustEscape":true},{"name":"top","val":"200","line":2,"column":56,"mustEscape":true},{"name":"left","val":"200","line":2,"column":64,"mustEscape":true}],"attributeBlocks":[],"isInline":false,"line":2,"column":5},{"type":"Tag","name":"div","selfClosing":false,"block":{"type":"Block","nodes":[{"type":"Text","val":"Hellow World","line":3,"column":12}],"line":3},"attrs":[{"name":"class","val":"'test3'","line":3,"column":5,"mustEscape":false}],"attributeBlocks":[],"isInline":false,"line":3,"column":5}],"line":1},"attrs":[{"name":"class","val":"'test'","line":1,"column":1,"mustEscape":false},{"name":"@click","val":"\"clcik\"","line":1,"column":7,"mustEscape":true},{"name":"backgroundColor","val":"\"#00FF00\"","line":1,"column":22,"mustEscape":true},{"name":"width","val":"400","line":1,"column":48,"mustEscape":true},{"name":"height","val":"400","line":1,"column":58,"mustEscape":true},{"name":"top","val":"60","line":1,"column":69,"mustEscape":true},{"name":"left","val":"10","line":1,"column":76,"mustEscape":true}],"attributeBlocks":[],"isInline":false,"line":1,"column":1}],"line":0,"declaredBlocks":{}}

/***/ })
/******/ ]);