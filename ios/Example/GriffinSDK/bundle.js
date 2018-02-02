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
/******/ 	return __webpack_require__(__webpack_require__.s = 7);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
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
/* 1 */
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
    EViewTask["SET_ROOT"] = "set_root";
    EViewTask["ADD_CHILD"] = "add_child";
    EViewTask["ADD_SUBVIEW"] = "add_subview";
})(EViewTask = exports.EViewTask || (exports.EViewTask = {}));


/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var Application_1 = __webpack_require__(4);
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
    ComponentManager.prototype.register = function (name, ctr) {
        this._registeredClass[name] = ctr;
    };
    ComponentManager.prototype.createViewByTag = function (tag, attrs, styles) {
        console.log("createViewByTag", tag);
        var T = this._registeredClass[tag];
        if (!T) {
            console.warn("unsupported tag", tag);
            return null;
        }
        var view = new T(tag, attrs, styles);
        Application_1.Application.instance.registerView(view);
        return view;
    };
    ComponentManager.prototype.registerNativeView = function (tagName) {
    };
    return ComponentManager;
}());
exports.ComponentManager = ComponentManager;


/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {
Object.defineProperty(exports, "__esModule", { value: true });
var Task_1 = __webpack_require__(1);
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
        if (!global.Environment || global.Environment == 'web') {
            return;
        }
        switch (type) {
            case Task_1.ETaskType.VIEW:
                this.$sendView(e);
                break;
            case Task_1.ETaskType.ROOT:
                this.$createRoot(e.createRootData.nodeId);
                break;
        }
    };
    TaskManager.prototype.$sendView = function (e) {
        switch (e.action) {
            case Task_1.EViewTask.CREATE_VIEW:
                this.$createView(e.createData);
                break;
            case Task_1.EViewTask.ADD_SUBVIEW:
                this.$addSubview(e.addSubviewData);
                break;
            default:
                break;
        }
    };
    TaskManager.prototype.$createView = function (data) {
        console.log("createView call:", JSON.stringify(data));
        return global.createElement(data.nodeId, data);
    };
    TaskManager.prototype.$addSubview = function (_a) {
        var parentId = _a.parentId, nodeId = _a.nodeId;
        console.log("addSubview call:", parentId, nodeId);
        return global.addSubview(parentId, nodeId);
    };
    TaskManager.prototype.$createRoot = function (nodeId) {
        console.log("createRoot call:", nodeId);
        return global.createRootView(nodeId);
    };
    TaskManager.$inst = null;
    return TaskManager;
}());
exports.TaskManager = TaskManager;

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {
Object.defineProperty(exports, "__esModule", { value: true });
var setup_1 = __webpack_require__(10);
var TaskManager_1 = __webpack_require__(3);
var RootView_1 = __webpack_require__(14);
var Task_1 = __webpack_require__(1);
var Html5 = __webpack_require__(15);
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
        Html5.setup();
        this.$root = RootView_1.RootView.create();
    };
    Application.prototype.runWithModule = function (view) {
        this.$root.component = view;
        TaskManager_1.TaskManager.instance.send(Task_1.ETaskType.VIEW, {
            action: Task_1.EViewTask.ADD_SUBVIEW,
            addSubviewData: { parentId: this.$root.id, nodeId: view.id }
        });
    };
    Application.prototype.registerView = function (view) {
        this.$root.registerView(view);
    };
    Application.prototype.handleEventFromNative = function (rootviewId, event) {
        if (rootviewId !== this.$root.id) {
            return;
        }
        this.$root.handleEventFromNative(event);
    };
    Application.$inst = null;
    return Application;
}());
exports.Application = Application;

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var RenderComponent_1 = __webpack_require__(17);
exports.RenderComponent = RenderComponent_1.RenderComponent;
var Task_1 = __webpack_require__(1);
exports.ETaskType = Task_1.ETaskType;
exports.EViewTask = Task_1.EViewTask;
var TaskManager_1 = __webpack_require__(3);
exports.TaskManager = TaskManager_1.TaskManager;


/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var current = 0;
function generateID() {
    return (current++).toString();
}
exports.generateID = generateID;


/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(global) {const { BaseComponent, launchWithComponent } = __webpack_require__(8)

let pugJson = __webpack_require__(21)

class TestAComponent extends BaseComponent {

    constructor() {
        super(pugJson)
    }

    clickclick() {
        global.navigator.push({
            url: 'http://dotwe.org/raw/dist/519962541fcf6acd911986357ad9c2ed.js',
            animated: true
        }, event => {
            modal.toast({ message: 'callback: ' + event })
        })
    }
}

launchWithComponent(new TestAComponent())
/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var BaseComponent_1 = __webpack_require__(9);
exports.BaseComponent = BaseComponent_1.BaseComponent;
var Application_1 = __webpack_require__(4);
var launchWithComponent = function (view) {
    Application_1.Application.instance.runWithModule(view);
};
exports.launchWithComponent = launchWithComponent;
Application_1.Application.instance.init();


/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
// import {IPugNode, IPugBlock, IStyle} from "../Interface/INode"
var ComponentManager_1 = __webpack_require__(2);
var DOMAstManager_1 = __webpack_require__(20);
var BaseComponent = /** @class */ (function () {
    function BaseComponent(pugJson) {
        this.$ast = pugJson.AstFunc;
        this.$styles = pugJson.style;
        this.init();
        this.$render();
    }
    BaseComponent.prototype.$render = function () {
        this.$rebuildAst();
    };
    BaseComponent.prototype.$rebuildAst = function () {
        var compileJson = this.$ast({ test: true, list: [1, 2, 3, 4, 5] });
        console.log('compileJson', JSON.stringify(compileJson));
        var children = new DOMAstManager_1.DOMAstManager(compileJson, this.$styles).compile();
        console.log('children', JSON.stringify(children));
        if (children.length == 1) {
            this.$view = children[0];
        }
        else {
            this.$view = ComponentManager_1.ComponentManager.instance.createViewByTag("div", [], {});
            for (var _i = 0, children_1 = children; _i < children_1.length; _i++) {
                var child = children_1[_i];
                this.$view.addChild(child);
            }
        }
        // console.log('this.view', JSON.stringify(this.$view))
    };
    Object.defineProperty(BaseComponent.prototype, "id", {
        get: function () {
            return this.$view.id;
        },
        enumerable: true,
        configurable: true
    });
    BaseComponent.prototype.init = function () {
    };
    BaseComponent.prototype.viewDidLoad = function () {
        // this.$renders.map(item=>item.$render())
    };
    return BaseComponent;
}());
exports.BaseComponent = BaseComponent;


/***/ }),
/* 10 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var Console_1 = __webpack_require__(11);
var NativeToJs_1 = __webpack_require__(12);
var JSLibrary = __webpack_require__(13);
function setup() {
    Console_1.setConsole();
    NativeToJs_1.NativeToJs.init();
    JSLibrary.init();
}
exports.setup = setup;


/***/ }),
/* 11 */
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

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {
Object.defineProperty(exports, "__esModule", { value: true });
var Application_1 = __webpack_require__(4);
var ComponentManager_1 = __webpack_require__(2);
var NativeToJs = /** @class */ (function () {
    function NativeToJs() {
    }
    NativeToJs.init = function () {
        global.dispatchEventToJs = function (rootViewId, event) {
            console.log(JSON.stringify(event));
            Application_1.Application.instance.handleEventFromNative(rootViewId, event);
        };
        global.registerNativeComponent = function (tagName) {
            ComponentManager_1.ComponentManager.instance.registerNativeView(tagName);
        };
    };
    return NativeToJs;
}());
exports.NativeToJs = NativeToJs;

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 13 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {
Object.defineProperty(exports, "__esModule", { value: true });
var initNetwork = function () {
    global.fetch = function (url, params, callback) {
        global.Nativefetch(url, params, callback);
    };
};
global.navigator = {
    push: function (options, callback) {
        if (!options.url) {
            return;
        }
        if (options.animated === null) {
            options.animated = true;
        }
        global.NavigatorPush(options.url, options.animated, callback);
    },
    pop: function (options, callback) {
        if (options.animated === null) {
            options.animated = true;
        }
        global.NavigatorPop(options.animated, callback);
    }
};
function init() {
    initNetwork();
}
exports.init = init;

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(0)))

/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var TaskManager_1 = __webpack_require__(3);
var Task_1 = __webpack_require__(1);
var NodeID_1 = __webpack_require__(6);
var RootView = /** @class */ (function () {
    function RootView() {
        this.$instanceId = null;
        this.$component = null;
        this.$views = {};
        this.$instanceId = NodeID_1.generateID();
        TaskManager_1.TaskManager.instance.send(Task_1.ETaskType.ROOT, { createRootData: { nodeId: this.$instanceId } });
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
    Object.defineProperty(RootView.prototype, "component", {
        set: function (_component) {
            this.$component = _component;
        },
        enumerable: true,
        configurable: true
    });
    RootView.prototype.registerView = function (view) {
        this.$views[view.id] = view;
    };
    RootView.prototype.handleEventFromNative = function (event) {
        var view = this.$views[event.nodeId];
        if (!view) {
            return;
        }
        var handlerString = view.eventHandler(event.event);
        this.$component[handlerString] && this.$component[handlerString]();
    };
    return RootView;
}());
exports.RootView = RootView;


/***/ }),
/* 15 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var ComponentManager_1 = __webpack_require__(2);
var div_1 = __webpack_require__(16);
var label_1 = __webpack_require__(18);
var imageView_1 = __webpack_require__(19);
exports.setup = function () {
    ComponentManager_1.ComponentManager.instance.register("div", div_1.Div);
    ComponentManager_1.ComponentManager.instance.register("label", label_1.Label);
    ComponentManager_1.ComponentManager.instance.register("text", label_1.Label);
    ComponentManager_1.ComponentManager.instance.register("img", imageView_1.ImageView);
};


/***/ }),
/* 16 */
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
var export_1 = __webpack_require__(5);
var Div = /** @class */ (function (_super) {
    __extends(Div, _super);
    function Div(tag, attrs, styles) {
        return _super.call(this, tag, attrs, styles) || this;
    }
    return Div;
}(export_1.RenderComponent));
exports.Div = Div;


/***/ }),
/* 17 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
// import {IPugNode, IPugAttr} from "../../Interface/INode"
var TaskManager_1 = __webpack_require__(3);
var Task_1 = __webpack_require__(1);
var NodeID_1 = __webpack_require__(6);
var RenderComponent = /** @class */ (function () {
    function RenderComponent(tag, attrs, styles) {
        this.$children = [];
        this.$styles = {};
        this.$instanceId = null;
        this.$click = null;
        this.$created = false;
        this.$name = tag;
        this.$attrs = attrs || [];
        this.$instanceId = NodeID_1.generateID();
        for (var k in styles) {
            var v = styles[k];
            this.$styles[k] = isNaN(v) ? v : +v;
        }
        this.$parseAttrs();
        this.$createView();
    }
    Object.defineProperty(RenderComponent.prototype, "id", {
        get: function () {
            return this.$instanceId;
        },
        enumerable: true,
        configurable: true
    });
    RenderComponent.prototype.$parseAttrs = function () {
        for (var _i = 0, _a = this.$attrs; _i < _a.length; _i++) {
            var attr = _a[_i];
            switch (attr.name) {
                case "width":
                case "height":
                case "left":
                case "top":
                    var n = parseInt(attr.val);
                    this.$styles[attr.name] = n;
                    break;
                case "@click":
                    this.$click = attr.val;
                    break;
            }
        }
    };
    RenderComponent.prototype.$createView = function (props) {
        if (props === void 0) { props = {}; }
        if (this.$created) {
            return;
        }
        if (this.$click) {
            props["clickable"] = true;
        }
        TaskManager_1.TaskManager.instance.send(Task_1.ETaskType.VIEW, {
            action: Task_1.EViewTask.CREATE_VIEW,
            createData: { nodeId: this.id, styles: this.$styles, props: props, type: this.$name }
        });
        this.$created = true;
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
            addSubviewData: { nodeId: child.id, parentId: this.id }
        });
    };
    RenderComponent.prototype.eventHandler = function (type) {
        if (type === "click") {
            return this.$click;
        }
        return null;
    };
    return RenderComponent;
}());
exports.RenderComponent = RenderComponent;


/***/ }),
/* 18 */
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
var export_1 = __webpack_require__(5);
var Label = /** @class */ (function (_super) {
    __extends(Label, _super);
    function Label(tag, attrs, styles) {
        var _this = _super.call(this, tag, attrs, styles) || this;
        _this.$text = "";
        return _this;
    }
    Label.prototype.$parseAttrs = function () {
        _super.prototype.$parseAttrs.call(this);
        for (var _i = 0, _a = this.$attrs; _i < _a.length; _i++) {
            var attr = _a[_i];
            switch (attr.name) {
                case "text":
                    this.$text = attr.val;
                    break;
            }
        }
    };
    Label.prototype.$createView = function () {
        _super.prototype.$createView.call(this, { text: this.$text });
    };
    return Label;
}(export_1.RenderComponent));
exports.Label = Label;


/***/ }),
/* 19 */
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
var export_1 = __webpack_require__(5);
var ImageView = /** @class */ (function (_super) {
    __extends(ImageView, _super);
    function ImageView(tag, attrs, styles) {
        var _this = _super.call(this, tag, attrs, styles) || this;
        _this.$url = "";
        return _this;
    }
    ImageView.prototype.$parseAttrs = function () {
        _super.prototype.$parseAttrs.call(this);
        for (var _i = 0, _a = this.$attrs; _i < _a.length; _i++) {
            var attr = _a[_i];
            switch (attr.name) {
                case "src":
                    this.$url = attr.val;
                    break;
            }
        }
    };
    ImageView.prototype.$createView = function () {
        var props = {};
        props.url = this.$url;
        _super.prototype.$createView.call(this, props);
    };
    return ImageView;
}(export_1.RenderComponent));
exports.ImageView = ImageView;


/***/ }),
/* 20 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var ComponentManager_1 = __webpack_require__(2);
var DOMAstManager = /** @class */ (function () {
    function DOMAstManager(nodes, styles) {
        this.$locals = {};
        this.$nodes = nodes;
        this.$styles = styles;
    }
    DOMAstManager.prototype.compile = function () {
        var children = [];
        for (var _i = 0, _a = this.$nodes; _i < _a.length; _i++) {
            var node = _a[_i];
            children.push(this.$visitNode(node));
        }
        return children;
    };
    DOMAstManager.prototype.$visitNode = function (node) {
        var view = null;
        switch (node.name) {
            // case "block":
            //     view = this.$visitBlock(node as IPugBlock)
            // break
            case "text":
                view = this.$visitText(node);
                break;
            default:
                view = this.$visitTag(node);
                if (node.children) {
                    var children = new DOMAstManager(node.children, this.$styles).compile();
                    for (var _i = 0, children_1 = children; _i < children_1.length; _i++) {
                        var child = children_1[_i];
                        view.addChild(child);
                    }
                }
                break;
        }
        return view;
    };
    DOMAstManager.prototype.$visitText = function (node) {
        var styles = {};
        this.$configStyle(node, styles);
        node.attributes.push({ name: "text", val: node.val });
        return ComponentManager_1.ComponentManager.instance.createViewByTag("text", node.attributes, styles);
    };
    DOMAstManager.prototype.$visitTag = function (node) {
        var view = null;
        var styles = {};
        this.$configStyle(node, styles);
        switch (node.name) {
            default:
                view = ComponentManager_1.ComponentManager.instance.createViewByTag(node.name, node.attributes, styles);
                break;
        }
        return view;
    };
    DOMAstManager.prototype.$configStyle = function (node, styles) {
        node.attributes = node.attributes.map(function (attr) {
            return {
                name: attr.name,
                val: attr.val
            };
        });
        var list = node.attributes.filter(function (o) { return o.name == "class"; });
        var _loop_1 = function (l) {
            var ss = this_1.$styles.filter(function (s) { return s.selector == "." + l.val; });
            for (var _i = 0, ss_1 = ss; _i < ss_1.length; _i++) {
                var s = ss_1[_i];
                styles = Object.assign(styles, s.attrs);
            }
        };
        var this_1 = this;
        for (var _i = 0, list_1 = list; _i < list_1.length; _i++) {
            var l = list_1[_i];
            _loop_1(l);
        }
    };
    return DOMAstManager;
}());
exports.DOMAstManager = DOMAstManager;


/***/ }),
/* 21 */
/***/ (function(module, exports, __webpack_require__) {

let styleJson = [{"selector":".test","attrs":{"background-color":"#FFFF00","flex-grow":"1"}},{"selector":".slider","attrs":{"background-color":"#FF00FF","height":"300"}},{"selector":".title","attrs":{"color":"#ff0000","font-size":"18","background-color":"#00ff00","top":"20"}}];let AstFuncStr = function template({attrs,list}) {var n = "",attrs=[], idMap = {};n = {"name":"div","id":"57b75b63-ce56-4702-bc2e-68c488fb7105","attributes":[]};
attrs=[];
attrs.push({name: "class",val: 'test'});
attrs.push({name: "@click",val: "clcik"});
attrs.push({name: "id",val: 1 + 2});
n.attributes = attrs;
idMap["57b75b63-ce56-4702-bc2e-68c488fb7105"] = n ;
if(false){;
idMap["null"].children = idMap["null"].children || [];
idMap["null"].children.push(n);
n.parentId = "null";
};
n = {"name":"div","id":"abe46f00-0347-4afe-b37b-827673ec455d","attributes":[]};
attrs=[];
attrs.push({name: "class",val: 'title'});
attrs.push({name: "@click",val: "clickclick"});
n.attributes = attrs;
idMap["abe46f00-0347-4afe-b37b-827673ec455d"] = n ;
if(true && idMap["57b75b63-ce56-4702-bc2e-68c488fb7105"]){;
idMap["57b75b63-ce56-4702-bc2e-68c488fb7105"].children = idMap["57b75b63-ce56-4702-bc2e-68c488fb7105"].children || [];
idMap["57b75b63-ce56-4702-bc2e-68c488fb7105"].children.push(n);
n.parentId = "57b75b63-ce56-4702-bc2e-68c488fb7105";
};
n = {"name":"text","val":"首页21sjjjj","id":"c1f3132a-c007-4290-abfd-a31035df31e5"};
n.attributes = idMap["abe46f00-0347-4afe-b37b-827673ec455d"].attributes;
if(true && idMap["abe46f00-0347-4afe-b37b-827673ec455d"]){;
idMap["abe46f00-0347-4afe-b37b-827673ec455d"].children = idMap["abe46f00-0347-4afe-b37b-827673ec455d"].children || [];
idMap["abe46f00-0347-4afe-b37b-827673ec455d"].children.push(n);
n.parentId = "abe46f00-0347-4afe-b37b-827673ec455d";
};
var parent_node = idMap["abe46f00-0347-4afe-b37b-827673ec455d"];
if(parent_node.parentId && idMap[parent_node.parentId]){;
idMap[parent_node.parentId].children = idMap[parent_node.parentId].children.filter((child)=>{
            child.id !== "abe46f00-0347-4afe-b37b-827673ec455d"
        });
idMap[parent_node.parentId].children.push(n);
} else {;
idMap["c1f3132a-c007-4290-abfd-a31035df31e5"] = n;
};
n.parentId = parent_node.parentId;
delete idMap["abe46f00-0347-4afe-b37b-827673ec455d"];
n = {"name":"div","id":"1625f6c0-f80a-4482-97be-1161662fb45a","attributes":[]};
attrs=[];
attrs.push({name: "class",val: 'slider'});
attrs.push({name: "class",val: 'slider'});
attrs.push({name: "interval",val: "3000"});
attrs.push({name: "auto-play",val: true});
n.attributes = attrs;
idMap["1625f6c0-f80a-4482-97be-1161662fb45a"] = n ;
if(true && idMap["57b75b63-ce56-4702-bc2e-68c488fb7105"]){;
idMap["57b75b63-ce56-4702-bc2e-68c488fb7105"].children = idMap["57b75b63-ce56-4702-bc2e-68c488fb7105"].children || [];
idMap["57b75b63-ce56-4702-bc2e-68c488fb7105"].children.push(n);
n.parentId = "57b75b63-ce56-4702-bc2e-68c488fb7105";
};
// iterate list || []
;(function(){
  var $$obj = list || [];
  if ('number' == typeof $$obj.length) {;
      for (var index = 0, $$l = $$obj.length; index < $$l; index++) {
        var li = $$obj[index];;
n = {"name":"img","id":"95b6bf67-6bd0-4623-9abb-1cab75b17318","attributes":[]};
attrs=[];
attrs.push({name: "src",val: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1516534694894&di=c6f029523e5d7bb35264a27034e39aa2&imgtype=0&src=http%3A%2F%2Fwww.hdwallpaperspulse.com%2Fwp-content%2Fuploads%2F2012%2F10%2Fkulawend_sanctuary-wallpaper-1080p-hd.jpg"});
n.attributes = attrs;
idMap["95b6bf67-6bd0-4623-9abb-1cab75b17318"] = n ;
if(true && idMap["1625f6c0-f80a-4482-97be-1161662fb45a"]){;
idMap["1625f6c0-f80a-4482-97be-1161662fb45a"].children = idMap["1625f6c0-f80a-4482-97be-1161662fb45a"].children || [];
idMap["1625f6c0-f80a-4482-97be-1161662fb45a"].children.push(n);
n.parentId = "1625f6c0-f80a-4482-97be-1161662fb45a";
};
      };
  } else {
    var $$l = 0;
    for (var index in $$obj) {
      $$l++;
      var li = $$obj[index];;
n = {"name":"img","id":"319847a4-0190-48d7-be5b-6e7e6aa8c75f","attributes":[]};
attrs=[];
attrs.push({name: "src",val: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1516534694894&di=c6f029523e5d7bb35264a27034e39aa2&imgtype=0&src=http%3A%2F%2Fwww.hdwallpaperspulse.com%2Fwp-content%2Fuploads%2F2012%2F10%2Fkulawend_sanctuary-wallpaper-1080p-hd.jpg"});
n.attributes = attrs;
idMap["319847a4-0190-48d7-be5b-6e7e6aa8c75f"] = n ;
if(true && idMap["1625f6c0-f80a-4482-97be-1161662fb45a"]){;
idMap["1625f6c0-f80a-4482-97be-1161662fb45a"].children = idMap["1625f6c0-f80a-4482-97be-1161662fb45a"].children || [];
idMap["1625f6c0-f80a-4482-97be-1161662fb45a"].children.push(n);
n.parentId = "1625f6c0-f80a-4482-97be-1161662fb45a";
};
    };
  }
}).call(this);
;
let res = Object.keys(idMap).map(key=>idMap[key]).filter(obj=>!obj.parentId);
return res;
        ;};let res = {style:styleJson,AstFunc:AstFuncStr};module.exports = res;

/***/ })
/******/ ]);