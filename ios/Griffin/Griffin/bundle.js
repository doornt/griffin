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
/******/ 	return __webpack_require__(__webpack_require__.s = 1);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var NativeManager = /** @class */ (function () {
    function NativeManager() {
    }
    NativeManager.createView = function (attr) {
        consoleLog("\ncreateView call:" + JSON.stringify(attr));
        return createView(attr);
    };
    NativeManager.setRootView = function (view) {
        consoleLog("\nsetRootView call:");
        consoleLog(view);
        return setRootView(view);
    };
    NativeManager.addSubview = function (view1, view2) {
        consoleLog("\naddSubview call:" + JSON.stringify(view1));
        return addSubview(view1, view2);
    };
    NativeManager.Log = function (arg) {
        return consoleLog(arg);
    };
    return NativeManager;
}());
exports.NativeManager = NativeManager;


/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

const {BaseComponent,launchWithComponent} = __webpack_require__(2)

let list = __webpack_require__(7)

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
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var BaseComponent_1 = __webpack_require__(3);
exports.BaseComponent = BaseComponent_1.BaseComponent;
var index_1 = __webpack_require__(0);
var launchWithComponent = function (view) {
    index_1.NativeManager.setRootView(view.nativeView);
};
exports.launchWithComponent = launchWithComponent;


/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var ComponentManager_1 = __webpack_require__(4);
var AstManager_1 = __webpack_require__(5);
var BaseComponent = /** @class */ (function () {
    function BaseComponent(ast) {
        this.$nativeView = null;
        ComponentManager_1.ComponentManager.instance.autoRegister(this.constructor.name, this.constructor);
        this.$ast = new AstManager_1.AstManager(ast);
        this.$rebuildAst();
        this.init();
        this.viewDidLoad();
    }
    BaseComponent.prototype.$rebuildAst = function () {
        this.$view = this.$ast.compile({});
        this.$nativeView = this.$view.nativeView;
    };
    Object.defineProperty(BaseComponent.prototype, "nativeView", {
        get: function () {
            return this.$nativeView;
        },
        enumerable: true,
        configurable: true
    });
    BaseComponent.prototype.init = function () {
        // this.$renders = this.$nodes.map(node=>{
        //     return new RenderComponent(node)
        // })
    };
    BaseComponent.prototype.viewDidLoad = function () {
        // this.$renders.map(item=>item.$render())
    };
    return BaseComponent;
}());
exports.BaseComponent = BaseComponent;


/***/ }),
/* 4 */
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
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var RenderComponent_1 = __webpack_require__(6);
var AstManager = /** @class */ (function () {
    function AstManager(ast) {
        this.$inputData = {};
        this.$ast = ast;
    }
    AstManager.prototype.compile = function (data) {
        this.$inputData = data || {};
        var root = null;
        var children = [];
        for (var _i = 0, _a = this.$ast.nodes; _i < _a.length; _i++) {
            var node = _a[_i];
            children.push(this.$visitNode(node));
        }
        if (children.length > 1) {
            root = new RenderComponent_1.RenderComponent(null);
            for (var _b = 0, children_1 = children; _b < children_1.length; _b++) {
                var child = children_1[_b];
                root.addChild(child);
            }
        }
        else {
            root = children[0];
        }
        return root;
    };
    AstManager.prototype.$visitNode = function (node) {
        var view = null;
        switch (node.type) {
            case "block":
                view = this.$visitBlock(node);
                break;
            default:
                view = this.$visitTag(node);
                var block = node.block;
                block && view.addChild(new AstManager(block).compile(this.$inputData));
                break;
        }
        return view;
    };
    AstManager.prototype.$visitBlock = function (node) {
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
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var index_1 = __webpack_require__(0);
var RenderComponent = /** @class */ (function () {
    function RenderComponent(attrs) {
        this.$children = [];
        this.$attr = {};
        this.$nativeView = null;
        this.$attrs = attrs || [];
        for (var _i = 0, _a = this.$attrs; _i < _a.length; _i++) {
            var attr = _a[_i];
            this.$buildAttr(attr);
        }
        this.$nativeView = index_1.NativeManager.createView(this.$attr);
    }
    Object.defineProperty(RenderComponent.prototype, "nativeView", {
        get: function () {
            return this.$nativeView;
        },
        enumerable: true,
        configurable: true
    });
    RenderComponent.prototype.$render = function () {
        this.$children.map(function (item) { return item.$render(); });
    };
    RenderComponent.prototype.addChild = function (child) {
        this.$children.push(child);
    };
    RenderComponent.prototype.$buildAttr = function (attr) {
        var val = attr.val.replace(/\"/g, "");
        switch (attr.name) {
            case "width":
            case "height":
            case "left":
            case "top":
                var n = parseInt(val);
                this.$attr[attr.name] = n;
                break;
            default:
                this.$attr[attr.name] = val;
        }
    };
    return RenderComponent;
}());
exports.RenderComponent = RenderComponent;


/***/ }),
/* 7 */
/***/ (function(module, exports) {

module.exports = {"type":"Block","nodes":[{"type":"Tag","name":"div","selfClosing":false,"block":{"type":"Block","nodes":[],"line":1},"attrs":[{"name":"class","val":"'test'","line":1,"column":1,"mustEscape":false},{"name":"@click","val":"\"clcik\"","line":1,"column":7,"mustEscape":true},{"name":"backgroundColor","val":"\"#0000FF\"","line":1,"column":22,"mustEscape":true},{"name":"width","val":"100","line":1,"column":48,"mustEscape":true},{"name":"height","val":"100","line":1,"column":58,"mustEscape":true},{"name":"top","val":"10","line":1,"column":69,"mustEscape":true},{"name":"left","val":"10","line":1,"column":76,"mustEscape":true}],"attributeBlocks":[],"isInline":false,"line":1,"column":1}],"line":0,"declaredBlocks":{}}

/***/ })
/******/ ]);