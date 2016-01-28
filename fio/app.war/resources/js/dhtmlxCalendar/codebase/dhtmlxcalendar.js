/*
Product Name: dhtmlxCalendar
Version: 4.0.1
Edition: Standard
License: content of this file is covered by GPL. Usage outside GPL terms is prohibited. To obtain Commercial or Enterprise license contact sales@dhtmlx.com
Copyright UAB Dinamenta http://www.dhtmlx.com
 */

if (typeof(window.dhx4) == "undefined") {
	window.dhx4 = {
		version : "4.0.1",
		skin : null,
		skinDetect : function (b) {
			var c = document.createElement("DIV");
			c.className = b + "_skin_detect";
			if (document.body.firstChild) {
				document.body.insertBefore(c, document.body.firstChild)
			} else {
				document.body.appendChild(c)
			}
			var a = c.offsetWidth;
			c.parentNode.removeChild(c);
			c = null;
			return {
				10 : "dhx_skyblue",
				20 : "dhx_web",
				30 : "dhx_terrace"
			}
			[a] || null
		},
		lastId : 1,
		newId : function () {
			return this.lastId++
		},
		zim : {
			data : {},
			step : 5,
			first : function () {
				return 100
			},
			last : function () {
				var c = this.first();
				for (var b in this.data) {
					c = Math.max(c, this.data[b])
				}
				return c
			},
			reserve : function (a) {
				this.data[a] = this.last() + this.step;
				return this.data[a]
			},
			clear : function (a) {
				if (this.data[a] != null) {
					this.data[a] = null;
					delete this.data[a]
				}
			}
		},
		s2b : function (a) {
			return (a == true || a == 1 || a == "true" || a == "1" || a == "yes" || a == "y")
		},
		trim : function (a) {
			return String(a).replace(/^\s{1,}/, "").replace(/\s{1,}$/, "")
		},
		template : function (b, c, a) {
			return b.replace(/#([a-zA-Z0-9_-]{1,})#/g, function (e, d) {
				if (d.length > 0 && typeof(c[d]) != "undefined") {
					if (a == true) {
						return window.dhx4.trim(c[d])
					}
					return String(c[d])
				}
				return ""
			})
		},
		absLeft : function (a) {
			if (typeof(a) == "string") {
				a = document.getElementById(a)
			}
			return this._aOfs(a).left
		},
		absTop : function (a) {
			if (typeof(a) == "string") {
				a = document.getElementById(a)
			}
			return this._aOfs(a).top
		},
		_aOfsSum : function (a) {
			var c = 0,
			b = 0;
			while (a) {
				c = c + parseInt(a.offsetTop);
				b = b + parseInt(a.offsetLeft);
				a = a.offsetParent
			}
			return {
				top : c,
				left : b
			}
		},
		_aOfsRect : function (d) {
			var g = d.getBoundingClientRect();
			var h = document.body;
			var b = document.documentElement;
			var a = window.pageYOffset || b.scrollTop || h.scrollTop;
			var e = window.pageXOffset || b.scrollLeft || h.scrollLeft;
			var f = b.clientTop || h.clientTop || 0;
			var i = b.clientLeft || h.clientLeft || 0;
			var j = g.top + a - f;
			var c = g.left + e - i;
			return {
				top : Math.round(j),
				left : Math.round(c)
			}
		},
		_aOfs : function (a) {
			if (a.getBoundingClientRect) {
				return this._aOfsRect(a)
			} else {
				return this._aOfsSum(a)
			}
		},
		_isObj : function (a) {
			return (a != null && typeof(a) == "object" && typeof(a.length) == "undefined")
		},
		_copyObj : function (d) {
			if (this._isObj(d)) {
				var c = {};
				for (var b in d) {
					if (typeof(d[b]) == "object" && d[b] != null) {
						c[b] = this._copyObj(d[b])
					} else {
						c[b] = d[b]
					}
				}
			} else {
				var c = [];
				for (var b = 0; b < d.length; b++) {
					if (typeof(d[b]) == "object" && d[b] != null) {
						c[b] = this._copyObj(d[b])
					} else {
						c[b] = d[b]
					}
				}
			}
			return c
		},
		screenDim : function () {
			var a = (navigator.userAgent.indexOf("MSIE") >= 0);
			var b = {};
			b.left = document.body.scrollLeft;
			b.right = b.left + (window.innerWidth || document.body.clientWidth);
			b.top = Math.max((a ? document.documentElement : document.getElementsByTagName("html")[0]).scrollTop, document.body.scrollTop);
			b.bottom = b.top + (a ? Math.max(document.documentElement.clientHeight || 0, document.documentElement.offsetHeight || 0) : window.innerHeight);
			return b
		},
		selectTextRange : function (d, g, b) {
			d = (typeof(d) == "string" ? document.getElementById(d) : d);
			var a = d.value.length;
			g = Math.max(Math.min(g, a), 0);
			b = Math.min(b, a);
			if (d.setSelectionRange) {
				d.setSelectionRange(g, b)
			} else {
				if (d.createTextRange) {
					var c = d.createTextRange();
					c.moveStart("character", g);
					c.moveEnd("character", b - a);
					try {
						c.select()
					} catch (f) {}

				}
			}
		},
		transData : null,
		transDetect : function () {
			if (this.transData == null) {
				this.transData = {
					transProp : false,
					transEv : null
				};
				var c = {
					MozTransition : "transitionend",
					WebkitTransition : "webkitTransitionEnd",
					OTransition : "oTransitionEnd",
					msTransition : "transitionend",
					transition : "transitionend"
				};
				for (var b in c) {
					if (this.transData.transProp == false && document.documentElement.style[b] != null) {
						this.transData.transProp = b;
						this.transData.transEv = c[b]
					}
				}
				c = null
			}
			return this.transData
		}
	};
	window.dhx4.isIE = (navigator.userAgent.indexOf("MSIE") >= 0 || navigator.userAgent.indexOf("Trident") >= 0);
	window.dhx4.isIE6 = (window.XMLHttpRequest == null && navigator.userAgent.indexOf("MSIE") >= 0);
	window.dhx4.isOpera = (navigator.userAgent.indexOf("Opera") >= 0);
	window.dhx4.isChrome = (navigator.userAgent.indexOf("Chrome") >= 0);
	window.dhx4.isKHTML = (navigator.userAgent.indexOf("Safari") >= 0 || navigator.userAgent.indexOf("Konqueror") >= 0);
	window.dhx4.isFF = (navigator.userAgent.indexOf("Firefox") >= 0);
	window.dhx4.isIPad = (navigator.userAgent.search(/iPad/gi) >= 0)
}
if (typeof(window.dhx4.ajax) == "undefined") {
	window.dhx4.ajax = {
		cache : false,
		get : function (a, b) {
			this._call("GET", a, null, true, b)
		},
		getSync : function (a) {
			return this._call("GET", a, null, false)
		},
		post : function (b, a, c) {
			if (arguments.length == 1) {
				a = ""
			} else {
				if (arguments.length == 2 && (typeof(a) == "function" || typeof(window[a]) == "function")) {
					c = a;
					a = ""
				} else {
					a = String(a)
				}
			}
			this._call("POST", b, a, true, c)
		},
		postSync : function (b, a) {
			a = (a == null ? "" : String(a));
			return this._call("POST", b, a, false)
		},
		getLong : function (a, b) {
			this._call("GET", a, null, true, b, {
				url : a
			})
		},
		postLong : function (b, a, c) {
			if (arguments.length == 2 && (typeof(a) == "function" || typeof(window[a]))) {
				c = a;
				a = ""
			}
			this._call("POST", b, a, true, c, {
				url : b,
				postData : a
			})
		},
		_call : function (g, b, a, f, e, d) {
			var c = (window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP"));
			if (f == true) {
				c.onreadystatechange = function () {
					if (c.readyState == 4 && c.status == 200) {
						if (typeof(e) == "function") {
							e.apply(window, [{
										xmlDoc : c
									}
								])
						}
						if (d != null) {
							if (typeof(d.postData) != "undefined") {
								dhx4.ajax.postLong(d.url, d.postData, e)
							} else {
								dhx4.ajax.getLong(d.url, e)
							}
						}
						e = null;
						c = null
					}
				}
			}
			if (g == "GET" && this.cache != true) {
				b += (b.indexOf("?") >= 0 ? "&" : "?") + "dhxr" + new Date().getTime()
			}
			c.open(g, b, f);
			if (g == "POST") {
				c.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				if (this.cache != true) {
					a += (a.length > 0 ? "&" : "") + "dhxr" + new Date().getTime()
				}
			} else {
				a = null
			}
			c.setRequestHeader("X-Requested-With", "XMLHttpRequest");
			c.send(a);
			if (!f) {
				return {
					xmlDoc : c
				}
			}
		}
	}
}
if (typeof(window.dhx4._enableDataLoading) == "undefined") {
	window.dhx4._enableDataLoading = function (obj, initObj, xmlToJson, xmlRootTag, mode) {
		if (mode == "clear") {
			for (var a in obj._dhxdataload) {
				obj._dhxdataload[a] = null;
				delete obj._dhxdataload[a]
			}
			obj._loadData = null;
			obj._dhxdataload = null;
			obj.load = null;
			obj.loadStruct = null;
			obj = null;
			return
		}
		obj._dhxdataload = {
			initObj : initObj,
			xmlToJson : xmlToJson,
			xmlRootTag : xmlRootTag,
			onBeforeXLS : null
		};
		obj._loadData = function (data, loadParams, onLoad) {
			if (arguments.length == 2) {
				onLoad = loadParams;
				loadParams = null
			}
			var obj = null;
			if (arguments.length == 3) {
				onLoad = arguments[2]
			}
			if (typeof(data) == "string") {
				var k = data.replace(/^\s{1,}/, "").replace(/\s{1,}$/, "");
				var tag = new RegExp("^<" + this._dhxdataload.xmlRootTag);
				if (tag.test(k.replace(/^<\?xml[^\?]*\?>\s*/, ""))) {
					if (window.DOMParser) {
						obj = (new window.DOMParser()).parseFromString(data, "text/xml")
					} else {
						if (typeof(window.ActiveXObject) != "undefined") {
							obj = new window.ActiveXObject("Microsoft.XMLDOM");
							obj.async = "false";
							obj.loadXML(data)
						}
					}
					if (obj != null) {
						obj = this[this._dhxdataload.xmlToJson].apply(this, [obj])
					}
				}
				if (obj == null && (k.match(/^\{.*\}$/) != null || k.match(/^\[.*\]$/) != null)) {
					try {
						eval("dhx4.temp=" + k)
					} catch (e) {
						dhx4.temp = null
					}
					obj = dhx4.temp;
					dhx4.temp = null
				}
				if (obj == null) {
					this.callEvent("onXLS", []);
					var params = [];
					if (typeof(this._dhxdataload.onBeforeXLS) == "function") {
						var k = this._dhxdataload.onBeforeXLS.apply(this, [data]);
						if (k != null && typeof(k) == "object") {
							if (k.url != null) {
								data = k.url
							}
							if (k.params != null) {
								for (var a in k.params) {
									params.push(a + "=" + encodeURIComponent(k.params[a]))
								}
							}
						}
					}
					var t = this;
					dhx4.ajax.post(data, params.join("&") + (typeof(loadParams) == "string" ? "&" + loadParams : ""), function (r) {
						var obj = null;
						if (r.xmlDoc.getResponseHeader("Content-Type").search(/xml/gi) >= 0 || (r.xmlDoc.responseText.replace(/^\s{1,}/, "")).match(/^</) != null) {
							obj = t[t._dhxdataload.xmlToJson].apply(t, [r.xmlDoc.responseXML])
						} else {
							try {
								eval("dhx4.temp=" + r.xmlDoc.responseText)
							} catch (e) {
								dhx4.temp = null
							}
							obj = dhx4.temp;
							dhx4.temp = null
						}
						if (obj != null) {
							t[t._dhxdataload.initObj].apply(t, [obj, data])
						}
						t.callEvent("onXLE", []);
						if (onLoad != null) {
							if (typeof(onLoad) == "function") {
								onLoad.apply(t, [])
							} else {
								if (typeof(window[onLoad]) == "function") {
									window[onLoad].apply(t, [])
								}
							}
						}
						onLoad = null;
						t = null
					});
					return
				}
			} else {
				if (typeof(data.documentElement) == "object" || (typeof(data.tagName) != "undefined" && typeof(data.getElementsByTagName) != "undefined" && data.getElementsByTagName(this._dhxdataload.xmlRootTag).length > 0)) {
					obj = this[this._dhxdataload.xmlToJson].apply(this, [data])
				} else {
					obj = window.dhx4._copyObj(data)
				}
			}
			if (obj != null) {
				this[this._dhxdataload.initObj].apply(this, [obj])
			}
			if (onLoad != null) {
				if (typeof(onLoad) == "function") {
					onLoad.apply(this, [])
				} else {
					if (typeof(window[onLoad]) == "function") {
						window[onLoad].apply(this, [])
					}
				}
				onLoad = null
			}
		};
		if (mode != null) {
			var k = {
				struct : "loadStruct",
				data : "load"
			};
			for (var a in mode) {
				if (mode[a] == true) {
					obj[k[a]] = function () {
						return this._loadData.apply(this, arguments)
					}
				}
			}
		}
		obj = null
	}
}
if (typeof(window.dhx4._eventable) == "undefined") {
	window.dhx4._eventable = function (a, b) {
		if (b == "clear") {
			a.detachAllEvents();
			a.dhxevs = null;
			a.attachEvent = null;
			a.detachEvent = null;
			a.checkEvent = null;
			a.callEvent = null;
			a.detachAllEvents = null;
			a = null;
			return
		}
		a.dhxevs = {
			data : {}

		};
		a.attachEvent = function (c, e) {
			c = String(c).toLowerCase();
			if (!this.dhxevs.data[c]) {
				this.dhxevs.data[c] = {}

			}
			var d = window.dhx4.newId();
			this.dhxevs.data[c][d] = e;
			return d
		};
		a.detachEvent = function (f) {
			for (var d in this.dhxevs.data) {
				var e = 0;
				for (var c in this.dhxevs.data[d]) {
					if (c == f) {
						this.dhxevs.data[d][c] = null;
						delete this.dhxevs.data[d][c]
					} else {
						e++
					}
				}
				if (e == 0) {
					this.dhxevs.data[d] = null;
					delete this.dhxevs.data[d]
				}
			}
		};
		a.checkEvent = function (c) {
			c = String(c).toLowerCase();
			return (this.dhxevs.data[c] != null)
		};
		a.callEvent = function (d, f) {
			d = String(d).toLowerCase();
			if (this.dhxevs.data[d] == null) {
				return true
			}
			var e = true;
			for (var c in this.dhxevs.data[d]) {
				e = this.dhxevs.data[d][c].apply(this, f) && e
			}
			return e
		};
		a.detachAllEvents = function () {
			for (var d in this.dhxevs.data) {
				for (var c in this.dhxevs.data[d]) {
					this.dhxevs.data[d][c] = null;
					delete this.dhxevs.data[d][c]
				}
				this.dhxevs.data[d] = null;
				delete this.dhxevs.data[d]
			}
		};
		a = null
	}
}
dhtmlx = function (c) {
	for (var b in c) {
		dhtmlx[b] = c[b]
	}
	return dhtmlx
};
dhtmlx.extend_api = function (a, d, c) {
	var b = window[a];
	if (!b) {
		return
	}
	window[a] = function (g) {
		if (g && typeof g == "object" && !g.tagName) {
			var f = b.apply(this, (d._init ? d._init(g) : arguments));
			for (var e in dhtmlx) {
				if (d[e]) {
					this[d[e]](dhtmlx[e])
				}
			}
			for (var e in g) {
				if (d[e]) {
					this[d[e]](g[e])
				} else {
					if (e.indexOf("on") == 0) {
						this.attachEvent(e, g[e])
					}
				}
			}
		} else {
			var f = b.apply(this, arguments)
		}
		if (d._patch) {
			d._patch(this)
		}
		return f || this
	};
	window[a].prototype = b.prototype;
	if (c) {
		dhtmlXHeir(window[a].prototype, c)
	}
};
dhtmlxAjax = {
	get : function (a, c) {
		var b = new dtmlXMLLoaderObject(true);
		b.async = (arguments.length < 3);
		b.waitCall = c;
		b.loadXML(a);
		return b
	},
	post : function (a, c, d) {
		var b = new dtmlXMLLoaderObject(true);
		b.async = (arguments.length < 4);
		b.waitCall = d;
		b.loadXML(a, true, c);
		return b
	},
	getSync : function (a) {
		return this.get(a, null, true)
	},
	postSync : function (a, b) {
		return this.post(a, b, null, true)
	}
};
function dtmlXMLLoaderObject(b, d, c, a) {
	this.xmlDoc = "";
	if (typeof(c) != "undefined") {
		this.async = c
	} else {
		this.async = true
	}
	this.onloadAction = b || null;
	this.mainObject = d || null;
	this.waitCall = null;
	this.rSeed = a || false;
	return this
}
dtmlXMLLoaderObject.count = 0;
dtmlXMLLoaderObject.prototype.waitLoadFunction = function (b) {
	var a = true;
	this.check = function () {
		if ((b) && (b.onloadAction != null)) {
			if ((!b.xmlDoc.readyState) || (b.xmlDoc.readyState == 4)) {
				if (!a) {
					return
				}
				a = false;
				dtmlXMLLoaderObject.count++;
				if (typeof b.onloadAction == "function") {
					b.onloadAction(b.mainObject, null, null, null, b)
				}
				if (b.waitCall) {
					b.waitCall.call(this, b);
					b.waitCall = null
				}
			}
		}
	};
	return this.check
};
dtmlXMLLoaderObject.prototype.getXMLTopNode = function (c, a) {
	if (typeof this.xmlDoc.status == "undefined" || this.xmlDoc.status < 400) {
		if (this.xmlDoc.responseXML) {
			var b = this.xmlDoc.responseXML.getElementsByTagName(c);
			if (b.length == 0 && c.indexOf(":") != -1) {
				var b = this.xmlDoc.responseXML.getElementsByTagName((c.split(":"))[1])
			}
			var d = b[0]
		} else {
			var d = this.xmlDoc.documentElement
		}
		if (d) {
			this._retry = false;
			return d
		}
		if (!this._retry && _isIE) {
			this._retry = true;
			var a = this.xmlDoc;
			this.loadXMLString(this.xmlDoc.responseText.replace(/^[\s]+/, ""), true);
			return this.getXMLTopNode(c, a)
		}
	}
	dhtmlxError.throwError("LoadXML", "Incorrect XML", [(a || this.xmlDoc), this.mainObject]);
	return document.createElement("DIV")
};
dtmlXMLLoaderObject.prototype.loadXMLString = function (b, a) {
	if (!_isIE) {
		var c = new DOMParser();
		this.xmlDoc = c.parseFromString(b, "text/xml")
	} else {
		this.xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		this.xmlDoc.async = this.async;
		this.xmlDoc.onreadystatechange = function () {};
		this.xmlDoc.loadXML(b)
	}
	if (a) {
		return
	}
	if (this.onloadAction) {
		this.onloadAction(this.mainObject, null, null, null, this)
	}
	if (this.waitCall) {
		this.waitCall();
		this.waitCall = null
	}
};
dtmlXMLLoaderObject.prototype.loadXML = function (c, b, a, d) {
	if (this.rSeed) {
		c += ((c.indexOf("?") != -1) ? "&" : "?") + "a_dhx_rSeed=" + (new Date()).valueOf()
	}
	this.filePath = c;
	if ((!_isIE) && (window.XMLHttpRequest)) {
		this.xmlDoc = new XMLHttpRequest()
	} else {
		this.xmlDoc = new ActiveXObject("Microsoft.XMLHTTP")
	}
	if (this.async) {
		this.xmlDoc.onreadystatechange = new this.waitLoadFunction(this)
	}
	this.xmlDoc.open(b ? "POST" : "GET", c, this.async);
	if (d) {
		this.xmlDoc.setRequestHeader("User-Agent", "dhtmlxRPC v0.1 (" + navigator.userAgent + ")");
		this.xmlDoc.setRequestHeader("Content-type", "text/xml")
	} else {
		if (b) {
			this.xmlDoc.setRequestHeader("Content-type", (this.contenttype || "application/x-www-form-urlencoded"))
		}
	}
	this.xmlDoc.setRequestHeader("X-Requested-With", "XMLHttpRequest");
	this.xmlDoc.send(null || a);
	if (!this.async) {
		(new this.waitLoadFunction(this))()
	}
};
dtmlXMLLoaderObject.prototype.destructor = function () {
	this._filterXPath = null;
	this._getAllNamedChilds = null;
	this._retry = null;
	this.async = null;
	this.rSeed = null;
	this.filePath = null;
	this.onloadAction = null;
	this.mainObject = null;
	this.xmlDoc = null;
	this.doXPath = null;
	this.doXPathOpera = null;
	this.doXSLTransToObject = null;
	this.doXSLTransToString = null;
	this.loadXML = null;
	this.loadXMLString = null;
	this.doSerialization = null;
	this.xmlNodeToJSON = null;
	this.getXMLTopNode = null;
	this.setXSLParamValue = null;
	return null
};
dtmlXMLLoaderObject.prototype.xmlNodeToJSON = function (d) {
	var c = {};
	for (var b = 0; b < d.attributes.length; b++) {
		c[d.attributes[b].name] = d.attributes[b].value
	}
	c._tagvalue = d.firstChild ? d.firstChild.nodeValue : "";
	for (var b = 0; b < d.childNodes.length; b++) {
		var a = d.childNodes[b].tagName;
		if (a) {
			if (!c[a]) {
				c[a] = []
			}
			c[a].push(this.xmlNodeToJSON(d.childNodes[b]))
		}
	}
	return c
};
function callerFunction(a, b) {
	this.handler = function (c) {
		if (!c) {
			c = window.event
		}
		a(c, b);
		return true
	};
	return this.handler
}
function getAbsoluteLeft(a) {
	return getOffset(a).left
}
function getAbsoluteTop(a) {
	return getOffset(a).top
}
function getOffsetSum(a) {
	var c = 0,
	b = 0;
	while (a) {
		c = c + parseInt(a.offsetTop);
		b = b + parseInt(a.offsetLeft);
		a = a.offsetParent
	}
	return {
		top : c,
		left : b
	}
}
function getOffsetRect(d) {
	var g = d.getBoundingClientRect();
	var h = document.body;
	var b = document.documentElement;
	var a = window.pageYOffset || b.scrollTop || h.scrollTop;
	var e = window.pageXOffset || b.scrollLeft || h.scrollLeft;
	var f = b.clientTop || h.clientTop || 0;
	var i = b.clientLeft || h.clientLeft || 0;
	var j = g.top + a - f;
	var c = g.left + e - i;
	return {
		top : Math.round(j),
		left : Math.round(c)
	}
}
function getOffset(a) {
	if (a.getBoundingClientRect) {
		return getOffsetRect(a)
	} else {
		return getOffsetSum(a)
	}
}
function convertStringToBoolean(a) {
	if (typeof(a) == "string") {
		a = a.toLowerCase()
	}
	switch (a) {
	case "1":
	case "true":
	case "yes":
	case "y":
	case 1:
	case true:
		return true;
		break;
	default:
		return false
	}
}
function getUrlSymbol(a) {
	if (a.indexOf("?") != -1) {
		return "&"
	} else {
		return "?"
	}
}
function dhtmlDragAndDropObject() {
	if (window.dhtmlDragAndDrop) {
		return window.dhtmlDragAndDrop
	}
	this.lastLanding = 0;
	this.dragNode = 0;
	this.dragStartNode = 0;
	this.dragStartObject = 0;
	this.tempDOMU = null;
	this.tempDOMM = null;
	this.waitDrag = 0;
	window.dhtmlDragAndDrop = this;
	return this
}
dhtmlDragAndDropObject.prototype.removeDraggableItem = function (a) {
	a.onmousedown = null;
	a.dragStarter = null;
	a.dragLanding = null
};
dhtmlDragAndDropObject.prototype.addDraggableItem = function (a, b) {
	a.onmousedown = this.preCreateDragCopy;
	a.dragStarter = b;
	this.addDragLanding(a, b)
};
dhtmlDragAndDropObject.prototype.addDragLanding = function (a, b) {
	a.dragLanding = b
};
dhtmlDragAndDropObject.prototype.preCreateDragCopy = function (a) {
	if ((a || window.event) && (a || event).button == 2) {
		return
	}
	if (window.dhtmlDragAndDrop.waitDrag) {
		window.dhtmlDragAndDrop.waitDrag = 0;
		document.body.onmouseup = window.dhtmlDragAndDrop.tempDOMU;
		document.body.onmousemove = window.dhtmlDragAndDrop.tempDOMM;
		return false
	}
	if (window.dhtmlDragAndDrop.dragNode) {
		window.dhtmlDragAndDrop.stopDrag(a)
	}
	window.dhtmlDragAndDrop.waitDrag = 1;
	window.dhtmlDragAndDrop.tempDOMU = document.body.onmouseup;
	window.dhtmlDragAndDrop.tempDOMM = document.body.onmousemove;
	window.dhtmlDragAndDrop.dragStartNode = this;
	window.dhtmlDragAndDrop.dragStartObject = this.dragStarter;
	document.body.onmouseup = window.dhtmlDragAndDrop.preCreateDragCopy;
	document.body.onmousemove = window.dhtmlDragAndDrop.callDrag;
	window.dhtmlDragAndDrop.downtime = new Date().valueOf();
	if ((a) && (a.preventDefault)) {
		a.preventDefault();
		return false
	}
	return false
};
dhtmlDragAndDropObject.prototype.callDrag = function (c) {
	if (!c) {
		c = window.event
	}
	dragger = window.dhtmlDragAndDrop;
	if ((new Date()).valueOf() - dragger.downtime < 100) {
		return
	}
	if (!dragger.dragNode) {
		if (dragger.waitDrag) {
			dragger.dragNode = dragger.dragStartObject._createDragNode(dragger.dragStartNode, c);
			if (!dragger.dragNode) {
				return dragger.stopDrag()
			}
			dragger.dragNode.onselectstart = function () {
				return false
			};
			dragger.gldragNode = dragger.dragNode;
			document.body.appendChild(dragger.dragNode);
			document.body.onmouseup = dragger.stopDrag;
			dragger.waitDrag = 0;
			dragger.dragNode.pWindow = window;
			dragger.initFrameRoute()
		} else {
			return dragger.stopDrag(c, true)
		}
	}
	if (dragger.dragNode.parentNode != window.document.body && dragger.gldragNode) {
		var a = dragger.gldragNode;
		if (dragger.gldragNode.old) {
			a = dragger.gldragNode.old
		}
		a.parentNode.removeChild(a);
		var b = dragger.dragNode.pWindow;
		if (a.pWindow && a.pWindow.dhtmlDragAndDrop.lastLanding) {
			a.pWindow.dhtmlDragAndDrop.lastLanding.dragLanding._dragOut(a.pWindow.dhtmlDragAndDrop.lastLanding)
		}
		if (_isIE) {
			var f = document.createElement("Div");
			f.innerHTML = dragger.dragNode.outerHTML;
			dragger.dragNode = f.childNodes[0]
		} else {
			dragger.dragNode = dragger.dragNode.cloneNode(true)
		}
		dragger.dragNode.pWindow = window;
		dragger.gldragNode.old = dragger.dragNode;
		document.body.appendChild(dragger.dragNode);
		b.dhtmlDragAndDrop.dragNode = dragger.dragNode
	}
	dragger.dragNode.style.left = c.clientX + 15 + (dragger.fx ? dragger.fx * (-1) : 0) + (document.body.scrollLeft || document.documentElement.scrollLeft) + "px";
	dragger.dragNode.style.top = c.clientY + 3 + (dragger.fy ? dragger.fy * (-1) : 0) + (document.body.scrollTop || document.documentElement.scrollTop) + "px";
	if (!c.srcElement) {
		var d = c.target
	} else {
		d = c.srcElement
	}
	dragger.checkLanding(d, c)
};
dhtmlDragAndDropObject.prototype.calculateFramePosition = function (e) {
	if (window.name) {
		var c = parent.frames[window.name].frameElement.offsetParent;
		var d = 0;
		var b = 0;
		while (c) {
			d += c.offsetLeft;
			b += c.offsetTop;
			c = c.offsetParent
		}
		if ((parent.dhtmlDragAndDrop)) {
			var a = parent.dhtmlDragAndDrop.calculateFramePosition(1);
			d += a.split("_")[0] * 1;
			b += a.split("_")[1] * 1
		}
		if (e) {
			return d + "_" + b
		} else {
			this.fx = d
		}
		this.fy = b
	}
	return "0_0"
};
dhtmlDragAndDropObject.prototype.checkLanding = function (b, a) {
	if ((b) && (b.dragLanding)) {
		if (this.lastLanding) {
			this.lastLanding.dragLanding._dragOut(this.lastLanding)
		}
		this.lastLanding = b;
		this.lastLanding = this.lastLanding.dragLanding._dragIn(this.lastLanding, this.dragStartNode, a.clientX, a.clientY, a);
		this.lastLanding_scr = (_isIE ? a.srcElement : a.target)
	} else {
		if ((b) && (b.tagName != "BODY")) {
			this.checkLanding(b.parentNode, a)
		} else {
			if (this.lastLanding) {
				this.lastLanding.dragLanding._dragOut(this.lastLanding, a.clientX, a.clientY, a)
			}
			this.lastLanding = 0;
			if (this._onNotFound) {
				this._onNotFound()
			}
		}
	}
};
dhtmlDragAndDropObject.prototype.stopDrag = function (b, c) {
	dragger = window.dhtmlDragAndDrop;
	if (!c) {
		dragger.stopFrameRoute();
		var a = dragger.lastLanding;
		dragger.lastLanding = null;
		if (a) {
			a.dragLanding._drag(dragger.dragStartNode, dragger.dragStartObject, a, (_isIE ? event.srcElement : b.target))
		}
	}
	dragger.lastLanding = null;
	if ((dragger.dragNode) && (dragger.dragNode.parentNode == document.body)) {
		dragger.dragNode.parentNode.removeChild(dragger.dragNode)
	}
	dragger.dragNode = 0;
	dragger.gldragNode = 0;
	dragger.fx = 0;
	dragger.fy = 0;
	dragger.dragStartNode = 0;
	dragger.dragStartObject = 0;
	document.body.onmouseup = dragger.tempDOMU;
	document.body.onmousemove = dragger.tempDOMM;
	dragger.tempDOMU = null;
	dragger.tempDOMM = null;
	dragger.waitDrag = 0
};
dhtmlDragAndDropObject.prototype.stopFrameRoute = function (c) {
	if (c) {
		window.dhtmlDragAndDrop.stopDrag(1, 1)
	}
	for (var a = 0; a < window.frames.length; a++) {
		try {
			if ((window.frames[a] != c) && (window.frames[a].dhtmlDragAndDrop)) {
				window.frames[a].dhtmlDragAndDrop.stopFrameRoute(window)
			}
		} catch (b) {}

	}
	try {
		if ((parent.dhtmlDragAndDrop) && (parent != window) && (parent != c)) {
			parent.dhtmlDragAndDrop.stopFrameRoute(window)
		}
	} catch (b) {}

};
dhtmlDragAndDropObject.prototype.initFrameRoute = function (c, d) {
	if (c) {
		window.dhtmlDragAndDrop.preCreateDragCopy();
		window.dhtmlDragAndDrop.dragStartNode = c.dhtmlDragAndDrop.dragStartNode;
		window.dhtmlDragAndDrop.dragStartObject = c.dhtmlDragAndDrop.dragStartObject;
		window.dhtmlDragAndDrop.dragNode = c.dhtmlDragAndDrop.dragNode;
		window.dhtmlDragAndDrop.gldragNode = c.dhtmlDragAndDrop.dragNode;
		window.document.body.onmouseup = window.dhtmlDragAndDrop.stopDrag;
		window.waitDrag = 0;
		if (((!_isIE) && (d)) && ((!_isFF) || (_FFrv < 1.8))) {
			window.dhtmlDragAndDrop.calculateFramePosition()
		}
	}
	try {
		if ((parent.dhtmlDragAndDrop) && (parent != window) && (parent != c)) {
			parent.dhtmlDragAndDrop.initFrameRoute(window)
		}
	} catch (b) {}

	for (var a = 0; a < window.frames.length; a++) {
		try {
			if ((window.frames[a] != c) && (window.frames[a].dhtmlDragAndDrop)) {
				window.frames[a].dhtmlDragAndDrop.initFrameRoute(window, ((!c || d) ? 1 : 0))
			}
		} catch (b) {}

	}
};
_isFF = false;
_isIE = false;
_isOpera = false;
_isKHTML = false;
_isMacOS = false;
_isChrome = false;
_FFrv = false;
_KHTMLrv = false;
_OperaRv = false;
if (navigator.userAgent.indexOf("Macintosh") != -1) {
	_isMacOS = true
}
if (navigator.userAgent.toLowerCase().indexOf("chrome") > -1) {
	_isChrome = true
}
if ((navigator.userAgent.indexOf("Safari") != -1) || (navigator.userAgent.indexOf("Konqueror") != -1)) {
	_KHTMLrv = parseFloat(navigator.userAgent.substr(navigator.userAgent.indexOf("Safari") + 7, 5));
	if (_KHTMLrv > 525) {
		_isFF = true;
		_FFrv = 1.9
	} else {
		_isKHTML = true
	}
} else {
	if (navigator.userAgent.indexOf("Opera") != -1) {
		_isOpera = true;
		_OperaRv = parseFloat(navigator.userAgent.substr(navigator.userAgent.indexOf("Opera") + 6, 3))
	} else {
		if (navigator.appName.indexOf("Microsoft") != -1) {
			_isIE = true;
			if ((navigator.appVersion.indexOf("MSIE 8.0") != -1 || navigator.appVersion.indexOf("MSIE 9.0") != -1 || navigator.appVersion.indexOf("MSIE 10.0") != -1 || document.documentMode > 7) && document.compatMode != "BackCompat") {
				_isIE = 8
			}
		} else {
			if (navigator.appName == "Netscape" && navigator.userAgent.indexOf("Trident") != -1) {
				_isIE = 8
			} else {
				_isFF = true;
				_FFrv = parseFloat(navigator.userAgent.split("rv:")[1])
			}
		}
	}
}
dtmlXMLLoaderObject.prototype.doXPath = function (c, e, d, i) {
	if (_isKHTML || (!_isIE && !window.XPathResult)) {
		return this.doXPathOpera(c, e)
	}
	if (_isIE) {
		if (!e) {
			if (!this.xmlDoc.nodeName) {
				e = this.xmlDoc.responseXML
			} else {
				e = this.xmlDoc
			}
		}
		if (!e) {
			dhtmlxError.throwError("LoadXML", "Incorrect XML", [(e || this.xmlDoc), this.mainObject])
		}
		if (d != null) {
			e.setProperty("SelectionNamespaces", "xmlns:xsl='" + d + "'")
		}
		if (i == "single") {
			return e.selectSingleNode(c)
		} else {
			return e.selectNodes(c) || new Array(0)
		}
	} else {
		var a = e;
		if (!e) {
			if (!this.xmlDoc.nodeName) {
				e = this.xmlDoc.responseXML
			} else {
				e = this.xmlDoc
			}
		}
		if (!e) {
			dhtmlxError.throwError("LoadXML", "Incorrect XML", [(e || this.xmlDoc), this.mainObject])
		}
		if (e.nodeName.indexOf("document") != -1) {
			a = e
		} else {
			a = e;
			e = e.ownerDocument
		}
		var g = XPathResult.ANY_TYPE;
		if (i == "single") {
			g = XPathResult.FIRST_ORDERED_NODE_TYPE
		}
		var f = new Array();
		var b = e.evaluate(c, a, function (j) {
				return d
			}, g, null);
		if (g == XPathResult.FIRST_ORDERED_NODE_TYPE) {
			return b.singleNodeValue
		}
		var h = b.iterateNext();
		while (h) {
			f[f.length] = h;
			h = b.iterateNext()
		}
		return f
	}
};
function _dhtmlxError(b, a, c) {
	if (!this.catches) {
		this.catches = new Array()
	}
	return this
}
_dhtmlxError.prototype.catchError = function (b, a) {
	this.catches[b] = a
};
_dhtmlxError.prototype.throwError = function (b, a, c) {
	if (this.catches[b]) {
		return this.catches[b](b, a, c)
	}
	if (this.catches.ALL) {
		return this.catches.ALL(b, a, c)
	}
	alert("Error type: " + arguments[0] + "\nDescription: " + arguments[1]);
	return null
};
window.dhtmlxError = new _dhtmlxError();
dtmlXMLLoaderObject.prototype.doXPathOpera = function (c, a) {
	var e = c.replace(/[\/]+/gi, "/").split("/");
	var d = null;
	var b = 1;
	if (!e.length) {
		return []
	}
	if (e[0] == ".") {
		d = [a]
	} else {
		if (e[0] == "") {
			d = (this.xmlDoc.responseXML || this.xmlDoc).getElementsByTagName(e[b].replace(/\[[^\]]*\]/g, ""));
			b++
		} else {
			return []
		}
	}
	for (b; b < e.length; b++) {
		d = this._getAllNamedChilds(d, e[b])
	}
	if (e[b - 1].indexOf("[") != -1) {
		d = this._filterXPath(d, e[b - 1])
	}
	return d
};
dtmlXMLLoaderObject.prototype._filterXPath = function (e, d) {
	var g = new Array();
	var d = d.replace(/[^\[]*\[\@/g, "").replace(/[\[\]\@]*/g, "");
	for (var f = 0; f < e.length; f++) {
		if (e[f].getAttribute(d)) {
			g[g.length] = e[f]
		}
	}
	return g
};
dtmlXMLLoaderObject.prototype._getAllNamedChilds = function (e, d) {
	var h = new Array();
	if (_isKHTML) {
		d = d.toUpperCase()
	}
	for (var g = 0; g < e.length; g++) {
		for (var f = 0; f < e[g].childNodes.length; f++) {
			if (_isKHTML) {
				if (e[g].childNodes[f].tagName && e[g].childNodes[f].tagName.toUpperCase() == d) {
					h[h.length] = e[g].childNodes[f]
				}
			} else {
				if (e[g].childNodes[f].tagName == d) {
					h[h.length] = e[g].childNodes[f]
				}
			}
		}
	}
	return h
};
function dhtmlXHeir(e, d) {
	for (var f in d) {
		if (typeof(d[f]) == "function") {
			e[f] = d[f]
		}
	}
	return e
}
function dhtmlxEvent(b, c, a) {
	if (b.addEventListener) {
		b.addEventListener(c, a, false)
	} else {
		if (b.attachEvent) {
			b.attachEvent("on" + c, a)
		}
	}
}
dtmlXMLLoaderObject.prototype.xslDoc = null;
dtmlXMLLoaderObject.prototype.setXSLParamValue = function (b, c, d) {
	if (!d) {
		d = this.xslDoc
	}
	if (d.responseXML) {
		d = d.responseXML
	}
	var a = this.doXPath("/xsl:stylesheet/xsl:variable[@name='" + b + "']", d, "http://www.w3.org/1999/XSL/Transform", "single");
	if (a != null) {
		a.firstChild.nodeValue = c
	}
};
dtmlXMLLoaderObject.prototype.doXSLTransToObject = function (d, b) {
	if (!d) {
		d = this.xslDoc
	}
	if (d.responseXML) {
		d = d.responseXML
	}
	if (!b) {
		b = this.xmlDoc
	}
	if (b.responseXML) {
		b = b.responseXML
	}
	if (!_isIE) {
		if (!this.XSLProcessor) {
			this.XSLProcessor = new XSLTProcessor();
			this.XSLProcessor.importStylesheet(d)
		}
		var a = this.XSLProcessor.transformToDocument(b)
	} else {
		var a = new ActiveXObject("Msxml2.DOMDocument.3.0");
		try {
			b.transformNodeToObject(d, a)
		} catch (c) {
			a = b.transformNode(d)
		}
	}
	return a
};
dtmlXMLLoaderObject.prototype.doXSLTransToString = function (c, b) {
	var a = this.doXSLTransToObject(c, b);
	if (typeof(a) == "string") {
		return a
	}
	return this.doSerialization(a)
};
dtmlXMLLoaderObject.prototype.doSerialization = function (b) {
	if (!b) {
		b = this.xmlDoc
	}
	if (b.responseXML) {
		b = b.responseXML
	}
	if (!_isIE) {
		var a = new XMLSerializer();
		return a.serializeToString(b)
	} else {
		return b.xml
	}
};
dhtmlxEventable = function (obj) {
	obj.attachEvent = function (name, catcher, callObj) {
		name = "ev_" + name.toLowerCase();
		if (!this[name]) {
			this[name] = new this.eventCatcher(callObj || this)
		}
		return (name + ":" + this[name].addEvent(catcher))
	};
	obj.callEvent = function (name, arg0) {
		name = "ev_" + name.toLowerCase();
		if (this[name]) {
			return this[name].apply(this, arg0)
		}
		return true
	};
	obj.checkEvent = function (name) {
		return (!!this["ev_" + name.toLowerCase()])
	};
	obj.eventCatcher = function (obj) {
		var dhx_catch = [];
		var z = function () {
			var res = true;
			for (var i = 0; i < dhx_catch.length; i++) {
				if (dhx_catch[i] != null) {
					var zr = dhx_catch[i].apply(obj, arguments);
					res = res && zr
				}
			}
			return res
		};
		z.addEvent = function (ev) {
			if (typeof(ev) != "function") {
				ev = eval(ev)
			}
			if (ev) {
				return dhx_catch.push(ev) - 1
			}
			return false
		};
		z.removeEvent = function (id) {
			dhx_catch[id] = null
		};
		return z
	};
	obj.detachEvent = function (id) {
		if (id != false) {
			var list = id.split(":");
			this[list[0]].removeEvent(list[1])
		}
	};
	obj.detachAllEvents = function () {
		for (var name in this) {
			if (name.indexOf("ev_") == 0) {
				this.detachEvent(name);
				this[name] = null
			}
		}
	};
	obj = null
};
function dhtmlXCalendarObject(f, k) {
	this.i = {};
	var c = null;
	if (typeof(f) == "string") {
		var d = document.getElementById(f)
	} else {
		var d = f
	}
	if (d && typeof(d) == "object" && d.tagName && String(d.tagName).toLowerCase() != "input") {
		c = d
	}
	d = null;
	if (typeof(f) != "object" || !f.length) {
		f = [f]
	}
	for (var b = 0; b < f.length; b++) {
		if (typeof(f[b]) == "string") {
			f[b] = (document.getElementById(f[b]) || null)
		}
		if (f[b] != null && f[b].tagName && String(f[b].tagName).toLowerCase() == "input") {
			this.i[window.dhx4.newId()] = {
				input : f[b]
			}
		} else {
			if (!(f[b]instanceof Array) && f[b]instanceof Object && (f[b].input != null || f[b].button != null)) {
				if (f[b].input != null && typeof(f[b].input) == "string") {
					f[b].input = document.getElementById(f[b].input)
				}
				if (f[b].button != null && typeof(f[b].button) == "string") {
					f[b].button = document.getElementById(f[b].button)
				}
				this.i[window.dhx4.newId()] = f[b]
			}
		}
		f[b] = null
	}
	this.conf = {
		skin : (k || window.dhx4.skin || (typeof(dhtmlx) != "undefined" ? dhtmlx.skin : null) || window.dhx4.skinDetect("dhtmlxcalendar") || "dhx_skyblue"),
		zi : window.dhx4.newId(),
		touch : (typeof(window.ontouchstart) != "undefined")
	};
	this.setSkin = function (l, a) {
		if (this.conf.skin == l && !a) {
			return
		}
		this.conf.skin = l;
		this.base.className = "dhtmlxcalendar_" + this.conf.skin;
		this._ifrSize()
	};
	this.base = document.createElement("DIV");
	this.base.style.display = "none";
	this.base.appendChild(document.createElement("DIV"));
	if (c != null) {
		this._hasParent = true;
		c.appendChild(this.base);
		c = null
	} else {
		document.body.appendChild(this.base)
	}
	this.setParent = function (a) {
		if (this._hasParent) {
			if (typeof(a) == "object") {
				a.appendChild(this.base)
			} else {
				if (typeof(a) == "string") {
					document.getElementById(a).appendChild(this.base)
				}
			}
		}
	};
	this.setSkin(this.conf.skin, true);
	if (this.conf.touch) {
		this.base.ontouchstart = function (a) {
			a = a || event;
			if (a.preventDefault) {
				a.preventDefault()
			}
			a.cancelBubble = true
		}
	} else {
		this.base.onclick = function (a) {
			a = a || event;
			a.cancelBubble = true
		};
		this.base.onmousedown = function () {
			return false
		}
	}
	this.loadUserLanguage = function (n) {
		if (!this.langData[n]) {
			return
		}
		this.lang = n;
		this.setWeekStartDay(this.langData[this.lang].weekstart);
		this.setDateFormat(this.langData[this.lang].dateformat || "%Y-%m-%d");
		if (this.msCont) {
			var m = 0;
			for (var l = 0; l < this.msCont.childNodes.length; l++) {
				for (var a = 0; a < this.msCont.childNodes[l].childNodes.length; a++) {
					this.msCont.childNodes[l].childNodes[a].innerHTML = this.langData[this.lang].monthesSNames[m++]
				}
			}
		}
	};
	this.contMonth = document.createElement("DIV");
	this.contMonth.className = "dhtmlxcalendar_month_cont";
	this.contMonth.onselectstart = function (a) {
		a = a || event;
		a.cancelBubble = true;
		if (a.preventDefault) {
			a.preventDefault()
		} else {
			a.returnValue = false
		}
		return false
	};
	this.base.firstChild.appendChild(this.contMonth);
	var g = document.createElement("UL");
	g.className = "dhtmlxcalendar_line";
	this.contMonth.appendChild(g);
	var j = document.createElement("LI");
	j.className = "dhtmlxcalendar_cell dhtmlxcalendar_month_hdr";
	j.innerHTML = "<div class='dhtmlxcalendar_month_arrow dhtmlxcalendar_month_arrow_left' onmouseover='this.className=\"dhtmlxcalendar_month_arrow dhtmlxcalendar_month_arrow_left_hover\";' onmouseout='this.className=\"dhtmlxcalendar_month_arrow dhtmlxcalendar_month_arrow_left\";'></div><span></span><div class='dhtmlxcalendar_month_arrow dhtmlxcalendar_month_arrow_right' onmouseover='this.className=\"dhtmlxcalendar_month_arrow dhtmlxcalendar_month_arrow_right_hover\";' onmouseout='this.className=\"dhtmlxcalendar_month_arrow dhtmlxcalendar_month_arrow_right\";'></div>";
	g.appendChild(j);
	var e = this;
	j[this.conf.touch ? "ontouchstart" : "onclick"] = function (n) {
		n = n || event;
		var l = (n.target || n.srcElement);
		if (l.className && l.className.indexOf("dhtmlxcalendar_month_arrow") === 0) {
			e._hideSelector();
			var m = (l.parentNode.firstChild == l ? -1 : 1);
			var a = new Date(e._activeMonth);
			e._drawMonth(new Date(e._activeMonth.getFullYear(), e._activeMonth.getMonth() + m, 1, 0, 0, 0, 0));
			e._evOnArrowClick([a, new Date(e._activeMonth)]);
			return
		}
		if (l.className && l.className == "dhtmlxcalendar_month_label_month") {
			n.cancelBubble = true;
			e._showSelector("month", Math.round(l.offsetLeft + l.offsetWidth / 2), l.offsetTop + l.offsetHeight + 2, "selector_month", true);
			return
		}
		if (l.className && l.className == "dhtmlxcalendar_month_label_year") {
			n.cancelBubble = true;
			e._showSelector("year", Math.round(l.offsetLeft + l.offsetWidth / 2), l.offsetTop + l.offsetHeight + 2, "selector_year", true);
			return
		}
		e._hideSelector()
	};
	this.contDays = document.createElement("DIV");
	this.contDays.className = "dhtmlxcalendar_days_cont";
	this.base.firstChild.appendChild(this.contDays);
	this.setWeekStartDay = function (a) {
		if (a == 0) {
			a = 7
		}
		this._wStart = Math.min(Math.max((isNaN(a) ? 1 : a), 1), 7);
		this._drawDaysOfWeek()
	};
	this._drawDaysOfWeek = function () {
		if (this.contDays.childNodes.length == 0) {
			var n = document.createElement("UL");
			n.className = "dhtmlxcalendar_line";
			this.contDays.appendChild(n)
		} else {
			var n = this.contDays.firstChild
		}
		var l = this._wStart;
		var m = this.langData[this.lang].daysSNames;
		m.push(String(this.langData[this.lang].daysSNames[0]).valueOf());
		for (var o = 0; o < 8; o++) {
			if (n.childNodes[o] == null) {
				var a = document.createElement("LI");
				n.appendChild(a)
			} else {
				var a = n.childNodes[o]
			}
			if (o == 0) {
				a.className = "dhtmlxcalendar_cell_wn";
				a.innerHTML = "<div class='dhtmlxcalendar_label'>" + (this.langData[this.lang].weekname || "w") + "</div>"
			} else {
				a.className = "dhtmlxcalendar_cell" + (l >= 6 ? " dhtmlxcalendar_day_weekday_cell" : "") + (o == 1 ? "_first" : "");
				a.innerHTML = m[l];
				if (++l > 7) {
					l = 1
				}
			}
		}
		if (this._activeMonth != null) {
			this._drawMonth(this._activeMonth)
		}
	};
	this._wStart = this.langData[this.lang].weekstart;
	this.setWeekStartDay(this._wStart);
	this.contDates = document.createElement("DIV");
	this.contDates.className = "dhtmlxcalendar_dates_cont";
	this.base.firstChild.appendChild(this.contDates);
	this.contDates[this.conf.touch ? "ontouchend" : "onclick"] = function (p) {
		p = p || event;
		var l = (p.target || p.srcElement);
		if (l.parentNode != null && l.parentNode._date != null) {
			l = l.parentNode
		}
		if (l._date != null && !l._css_dis) {
			var n = e._activeDate.getHours();
			var m = e._activeDate.getMinutes();
			var o = l._date;
			if (e.checkEvent("onBeforeChange")) {
				if (!e.callEvent("onBeforeChange", [new Date(l._date.getFullYear(), l._date.getMonth(), l._date.getDate(), n, m)])) {
					return
				}
			}
			if (e._activeDateCell != null) {
				e._activeDateCell._css_date = false;
				e._updateCellStyle(e._activeDateCell._q, e._activeDateCell._w)
			}
			var a = (e._activeDate.getFullYear() + "_" + e._activeDate.getMonth() != o.getFullYear() + "_" + o.getMonth());
			e._nullDate = false;
			e._activeDate = new Date(o.getFullYear(), o.getMonth(), o.getDate(), n, m);
			e._activeDateCell = l;
			e._activeDateCell._css_date = true;
			e._activeDateCell._css_hover = false;
			e._updateCellStyle(e._activeDateCell._q, e._activeDateCell._w);
			if (a) {
				e._drawMonth(e._activeDate)
			}
			if (e._activeInp && e.i[e._activeInp] && e.i[e._activeInp].input != null) {
				e.i[e._activeInp].input.value = e._dateToStr(new Date(e._activeDate.getTime()))
			}
			if (!e._hasParent) {
				e._hide()
			}
			e._evOnClick([new Date(e._activeDate.getTime())])
		}
	};
	if (!this.conf.touch) {
		this.contDates.onmouseover = function (l) {
			l = l || event;
			var a = (l.target || l.srcElement);
			if (a.parentNode != null && a.parentNode._date != null) {
				a = a.parentNode
			}
			if (a._date != null) {
				if (e._lastHover == a || a._css_hover) {
					return
				}
				a._css_hover = true;
				e._updateCellStyle(a._q, a._w);
				e._lastHover = a;
				e._evOnMouseOver([new Date(a._date.getFullYear(), a._date.getMonth(), a._date.getDate(), 0, 0, 0, 0), l]);
				a = null
			}
		};
		this.contDates.onmouseout = function (a) {
			e._clearDayHover(a || event)
		}
	}
	this._lastHover = null;
	this._clearDayHover = function (a) {
		if (!this._lastHover) {
			return
		}
		this._lastHover._css_hover = false;
		this._updateCellStyle(this._lastHover._q, this._lastHover._w);
		e._evOnMouseOut([new Date(this._lastHover._date.getFullYear(), this._lastHover._date.getMonth(), this._lastHover._date.getDate(), 0, 0, 0, 0), a]);
		this._lastHover = null
	};
	for (var b = 0; b < 6; b++) {
		var g = document.createElement("UL");
		g.className = "dhtmlxcalendar_line";
		this.contDates.appendChild(g);
		for (var i = 0; i <= 7; i++) {
			var j = document.createElement("LI");
			if (i == 0) {
				j.className = "dhtmlxcalendar_cell_wn"
			} else {
				j.className = "dhtmlxcalendar_cell"
			}
			g.appendChild(j)
		}
	}
	this.contTime = document.createElement("DIV");
	this.contTime.className = "dhtmlxcalendar_time_cont";
	this.base.firstChild.appendChild(this.contTime);
	this.showTime = function () {
		this.contTime.style.display = "";
		this._ifrSize()
	};
	this.hideTime = function () {
		this.contTime.style.display = "none";
		this._ifrSize()
	};
	var g = document.createElement("UL");
	g.className = "dhtmlxcalendar_line";
	this.contTime.appendChild(g);
	var j = document.createElement("LI");
	j.className = "dhtmlxcalendar_cell dhtmlxcalendar_time_hdr";
	j.innerHTML = "<div class='dhtmlxcalendar_time_img'></div><span class='dhtmlxcalendar_label_hours'></span><span class='dhtmlxcalendar_label_colon'> : </span><span class='dhtmlxcalendar_label_minutes'></span>";
	g.appendChild(j);
	j[this.conf.touch ? "ontouchstart" : "onclick"] = function (m) {
		m = m || event;
		var a = (m.target || m.srcElement);
		if (a.tagName != null && a.tagName.toLowerCase() == "span" && a._par == true && a.parentNode != null) {
			a = a.parentNode
		}
		if (a.className && a.className == "dhtmlxcalendar_label_hours") {
			m.cancelBubble = true;
			var l = e.contMonth.offsetHeight + e.contDays.offsetHeight + e.contDates.offsetHeight + a.offsetTop;
			e._showSelector("hours", Math.round(a.offsetLeft + a.offsetWidth / 2), l - 2, "selector_hours", true);
			return
		}
		if (a.className && a.className == "dhtmlxcalendar_label_minutes") {
			m.cancelBubble = true;
			if (e._minutesInterval == 1) {
				var n = e.getFormatedDate("%i");
				a.innerHTML = "<span class='dhtmlxcalendar_selected_date'>" + n.charAt(0) + "</span>" + n.charAt(1);
				a.firstChild._par = true;
				e._selectorMode = 1
			}
			var l = e.contMonth.offsetHeight + e.contDays.offsetHeight + e.contDates.offsetHeight + a.offsetTop;
			e._showSelector("minutes", Math.round(a.offsetLeft + a.offsetWidth / 2), l - 2, "selector_minutes", true);
			return
		}
		e._hideSelector()
	};
	this._activeMonth = null;
	this._activeDate = new Date();
	this._activeDateCell = null;
	this.setDate = function (l) {
		this._nullDate = (typeof(l) == "undefined" || l === "" || !l);
		if (!(l instanceof Date)) {
			l = this._strToDate(String(l || ""));
			if (l == "Invalid Date") {
				l = new Date()
			}
		}
		var a = l.getTime();
		if (this._isOutOfRange(a)) {
			return
		}
		this._activeDate = new Date(a);
		this._drawMonth(this._nullDate ? new Date() : this._activeDate);
		this._updateVisibleHours();
		this._updateVisibleMinutes()
	};
	this.getDate = function (l) {
		if (this._nullDate) {
			return null
		}
		var a = new Date(this._activeDate.getTime());
		if (l) {
			return this._dateToStr(a)
		}
		return a
	};
	this._drawMonth = function (s) {
		if (!(s instanceof Date)) {
			return
		}
		if (isNaN(s.getFullYear())) {
			s = new Date(this._activeMonth.getFullYear(), this._activeMonth.getMonth(), 1, 0, 0, 0, 0)
		}
		this._activeMonth = new Date(s.getFullYear(), s.getMonth(), 1, 0, 0, 0, 0);
		this._activeDateCell = null;
		var p = new Date(this._activeMonth.getTime());
		var m = p.getDay();
		var v = m - this._wStart;
		if (v < 0) {
			v = v + 7
		}
		p.setDate(p.getDate() - v);
		var z = s.getMonth();
		var A = new Date(this._activeDate.getFullYear(), this._activeDate.getMonth(), this._activeDate.getDate(), 0, 0, 0, 0).getTime();
		var o = 0;
		for (var l = 0; l < 6; l++) {
			var r = this._wStart;
			for (var y = 0; y <= 7; y++) {
				if (y == 0) {
					var x = this.getWeekNumber(new Date(p.getFullYear(), p.getMonth(), p.getDate() + o, 0, 0, 0, 0));
					this.contDates.childNodes[l].childNodes[y].innerHTML = "<div class='dhtmlxcalendar_label'>" + x + "</div>"
				} else {
					var a = new Date(p.getFullYear(), p.getMonth(), p.getDate() + o, 0, 0, 0, 0);
					var u = a.getDay();
					var n = a.getTime();
					var t = "dhtmlxcalendar_label";
					if (this._tipData[n] != null) {
						if (this._tipData[n].usePopup && typeof(window.dhtmlXPopup) == "function") {
							this.contDates.childNodes[l].childNodes[y].removeAttribute("title");
							this._initTooltipPopup()
						} else {
							this.contDates.childNodes[l].childNodes[y].setAttribute("title", this._tipData[n].text)
						}
						if (this._tipData[n].showIcon) {
							t += " dhtmlxcalendar_label_title"
						}
					} else {
						this.contDates.childNodes[l].childNodes[y].removeAttribute("title")
					}
					this.contDates.childNodes[l].childNodes[y].innerHTML = "<div class='" + t + "'>" + a.getDate() + "</div>";
					this.contDates.childNodes[l].childNodes[y]._date = new Date(n);
					this.contDates.childNodes[l].childNodes[y]._q = l;
					this.contDates.childNodes[l].childNodes[y]._w = y;
					this.contDates.childNodes[l].childNodes[y]._css_month = (a.getMonth() == z);
					this.contDates.childNodes[l].childNodes[y]._css_date = (!this._nullDate && n == A);
					this.contDates.childNodes[l].childNodes[y]._css_weekend = (r >= 6);
					this.contDates.childNodes[l].childNodes[y]._css_dis = this._isOutOfRange(n);
					this.contDates.childNodes[l].childNodes[y]._css_holiday = (this._holidays[n] == true);
					this._updateCellStyle(l, y);
					if (n == A) {
						this._activeDateCell = this.contDates.childNodes[l].childNodes[y]
					}
					if (++r > 7) {
						r = 1
					}
					o++
				}
			}
		}
		this.contMonth.firstChild.firstChild.childNodes[1].innerHTML = this._buildMonthHdr(s)
	};
	this._updateCellStyle = function (n, a) {
		var m = this.contDates.childNodes[n].childNodes[a];
		var l = "dhtmlxcalendar_cell dhtmlxcalendar_cell";
		l += (m._css_month ? "_month" : "");
		l += (m._css_date ? "_date" : "");
		l += (m._css_weekend ? "_weekend" : "");
		l += (m._css_holiday ? "_holiday" : "");
		l += (m._css_dis ? "_dis" : "");
		l += (m._css_hover && !m._css_dis ? "_hover" : "");
		m.className = l;
		m = null
	};
	this._minutesInterval = 5;
	this._initSelector = function (s, n) {
		if (!this._selCover) {
			this._selCover = document.createElement("DIV");
			this._selCover.className = "dhtmlxcalendar_selector_cover";
			this.base.firstChild.appendChild(this._selCover)
		}
		if (!this._sel) {
			this._sel = document.createElement("DIV");
			this._sel.className = "dhtmlxcalendar_selector_obj";
			this.base.firstChild.appendChild(this._sel);
			this._sel.appendChild(document.createElement("TABLE"));
			this._sel.firstChild.className = "dhtmlxcalendar_selector_table";
			this._sel.firstChild.cellSpacing = 0;
			this._sel.firstChild.cellPadding = 0;
			this._sel.firstChild.border = 0;
			this._sel.firstChild.appendChild(document.createElement("TBODY"));
			this._sel.firstChild.firstChild.appendChild(document.createElement("TR"));
			this._sel.firstChild.firstChild.firstChild.appendChild(document.createElement("TD"));
			this._sel.firstChild.firstChild.firstChild.appendChild(document.createElement("TD"));
			this._sel.firstChild.firstChild.firstChild.appendChild(document.createElement("TD"));
			this._sel.firstChild.firstChild.firstChild.childNodes[0].className = "dhtmlxcalendar_selector_cell_left";
			this._sel.firstChild.firstChild.firstChild.childNodes[1].className = "dhtmlxcalendar_selector_cell_middle";
			this._sel.firstChild.firstChild.firstChild.childNodes[2].className = "dhtmlxcalendar_selector_cell_right";
			this._sel.firstChild.firstChild.firstChild.childNodes[0].innerHTML = "&nbsp;";
			this._sel.firstChild.firstChild.firstChild.childNodes[2].innerHTML = "&nbsp;";
			if (!this.conf.touch) {
				this._sel.firstChild.firstChild.firstChild.childNodes[0].onmouseover = function () {
					this.className = "dhtmlxcalendar_selector_cell_left dhtmlxcalendar_selector_cell_left_hover"
				};
				this._sel.firstChild.firstChild.firstChild.childNodes[0].onmouseout = function () {
					this.className = "dhtmlxcalendar_selector_cell_left"
				};
				this._sel.firstChild.firstChild.firstChild.childNodes[2].onmouseover = function () {
					this.className = "dhtmlxcalendar_selector_cell_right dhtmlxcalendar_selector_cell_right_hover"
				};
				this._sel.firstChild.firstChild.firstChild.childNodes[2].onmouseout = function () {
					this.className = "dhtmlxcalendar_selector_cell_right"
				};
				this._sel.onmouseover = function (v) {
					v = v || event;
					var q = (v.target || v.srcElement);
					if (q._cell === true) {
						if (e._selHover != q) {
							e._clearSelHover()
						}
						if (String(q.className).match(/^\s{0,}dhtmlxcalendar_selector_cell\s{0,}$/gi) != null) {
							q.className += " dhtmlxcalendar_selector_cell_hover";
							e._selHover = q
						}
					}
				};
				this._sel.onmouseout = function () {
					e._clearSelHover()
				}
			}
			this._sel.firstChild.firstChild.firstChild.childNodes[0][this.conf.touch ? "ontouchstart" : "onclick"] = function (q) {
				q = q || event;
				q.cancelBubble = true;
				e._scrollYears(-1)
			};
			this._sel.firstChild.firstChild.firstChild.childNodes[2][this.conf.touch ? "ontouchstart" : "onclick"] = function (q) {
				q = q || event;
				q.cancelBubble = true;
				e._scrollYears(1)
			};
			this._sel._ta = {};
			this._selHover = null;
			this._sel.appendChild(document.createElement("DIV"));
			this._sel.lastChild.className = "dhtmlxcalendar_selector_obj_arrow"
		}
		if (this._sel._ta[s] == true) {
			return
		}
		if (s == "month") {
			this._msCells = {};
			this.msCont = document.createElement("DIV");
			this.msCont.className = "dhtmlxcalendar_area_" + n;
			this._sel.firstChild.firstChild.firstChild.childNodes[1].appendChild(this.msCont);
			var l = 0;
			for (var a = 0; a < 4; a++) {
				var r = document.createElement("UL");
				r.className = "dhtmlxcalendar_selector_line";
				this.msCont.appendChild(r);
				for (var t = 0; t < 3; t++) {
					var u = document.createElement("LI");
					u.innerHTML = this.langData[this.lang].monthesSNames[l];
					u.className = "dhtmlxcalendar_selector_cell";
					r.appendChild(u);
					u._month = l;
					u._cell = true;
					this._msCells[l++] = u
				}
			}
			this.msCont[this.conf.touch ? "ontouchstart" : "onclick"] = function (v) {
				v = v || event;
				v.cancelBubble = true;
				var q = (v.target || v.srcElement);
				if (q._month != null) {
					e._hideSelector();
					e._updateActiveMonth();
					e._drawMonth(new Date(e._activeMonth.getFullYear(), q._month, 1, 0, 0, 0, 0));
					e._doOnSelectorChange()
				}
			}
		}
		if (s == "year") {
			this._ysCells = {};
			this.ysCont = document.createElement("DIV");
			this.ysCont.className = "dhtmlxcalendar_area_" + n;
			this._sel.firstChild.firstChild.firstChild.childNodes[1].appendChild(this.ysCont);
			for (var a = 0; a < 4; a++) {
				var r = document.createElement("UL");
				r.className = "dhtmlxcalendar_selector_line";
				this.ysCont.appendChild(r);
				for (var t = 0; t < 3; t++) {
					var u = document.createElement("LI");
					u.className = "dhtmlxcalendar_selector_cell";
					u._cell = true;
					r.appendChild(u)
				}
			}
			this.ysCont[this.conf.touch ? "ontouchstart" : "onclick"] = function (v) {
				v = v || event;
				v.cancelBubble = true;
				var q = (v.target || v.srcElement);
				if (q._year != null) {
					e._hideSelector();
					e._drawMonth(new Date(q._year, e._activeMonth.getMonth(), 1, 0, 0, 0, 0));
					e._doOnSelectorChange()
				}
			}
		}
		if (s == "hours") {
			this._hsCells = {};
			this.hsCont = document.createElement("DIV");
			this.hsCont.className = "dhtmlxcalendar_area_" + n;
			this._sel.firstChild.firstChild.firstChild.childNodes[1].appendChild(this.hsCont);
			var l = 0;
			for (var a = 0; a < 4; a++) {
				var r = document.createElement("UL");
				r.className = "dhtmlxcalendar_selector_line";
				this.hsCont.appendChild(r);
				for (var t = 0; t < 6; t++) {
					var u = document.createElement("LI");
					u.innerHTML = this._fixLength(l, 2);
					u.className = "dhtmlxcalendar_selector_cell";
					r.appendChild(u);
					u._hours = l;
					u._cell = true;
					this._hsCells[l++] = u
				}
			}
			this.hsCont[this.conf.touch ? "ontouchstart" : "onclick"] = function (v) {
				v = v || event;
				v.cancelBubble = true;
				var q = (v.target || v.srcElement);
				if (q._hours != null) {
					e._hideSelector();
					e._activeDate.setHours(q._hours);
					e._updateActiveHours();
					e._updateVisibleHours();
					e._doOnSelectorChange()
				}
			}
		}
		if (s == "minutes") {
			var p = 4;
			var m = 3;
			var o = 2;
			if (this._minutesInterval == 1) {
				if (this._selectorMode == 1) {
					p = 2;
					m = 3;
					o = 1
				} else {
					p = 2;
					m = 5;
					o = 1;
					n += "5"
				}
			}
			if (this._minutesInterval == 10) {
				p = 2
			}
			if (this._minutesInterval == 15) {
				p = 1;
				m = 4;
				n += "4"
			}
			this._rsCells = {};
			this.rsCont = document.createElement("DIV");
			this.rsCont.className = "dhtmlxcalendar_area_" + n;
			this._sel.firstChild.firstChild.firstChild.childNodes[1].appendChild(this.rsCont);
			var l = 0;
			for (var a = 0; a < p; a++) {
				var r = document.createElement("UL");
				r.className = "dhtmlxcalendar_selector_line";
				this.rsCont.appendChild(r);
				for (var t = 0; t < m; t++) {
					var u = document.createElement("LI");
					u.innerHTML = (o > 1 ? this._fixLength(l, o) : l);
					u.className = "dhtmlxcalendar_selector_cell";
					r.appendChild(u);
					u._minutes = l;
					u._cell = true;
					this._rsCells[l] = u;
					l += this._minutesInterval
				}
			}
			this.rsCont[this.conf.touch ? "ontouchstart" : "onclick"] = function (w) {
				w = w || event;
				w.cancelBubble = true;
				var v = (w.target || w.srcElement);
				if (v._minutes != null) {
					if (e._minutesInterval == 1) {
						var q = e.getFormatedDate("%i");
						if (e._selectorMode == 1) {
							q = v._minutes.toString() + q.charAt(1)
						} else {
							q = q.charAt(0) + v._minutes.toString()
						}
						e._activeDate.setMinutes(Number(q));
						e._hideSelector();
						if (e._selectorMode == 1) {
							e._updateVisibleMinutes(true);
							e._selectorMode = 2;
							e._showSelector("minutes", e._sel._x, e._sel._y, "selector_minutes", true);
							e._updateActiveMinutes();
							return
						} else {
							e._selectorMode = 1
						}
					} else {
						e._hideSelector();
						e._activeDate.setMinutes(v._minutes);
						e._updateActiveMinutes()
					}
					e._updateVisibleMinutes();
					e._doOnSelectorChange()
				}
			}
		}
		this._sel._ta[s] = true
	};
	this._showSelector = function (o, l, p, n, a) {
		if (a === true && this._sel != null && this._isSelectorVisible() && o == this._sel._t) {
			this._hideSelector();
			return
		}
		if (this.conf.skin == "dhx_terrace") {
			l += 12
		}
		if (!this._sel || !this._sel._ta[o]) {
			this._initSelector(o, n)
		}
		if (o != this._sel._t && this._sel._t == "minutes" && this._minutesInterval == 1) {
			this.contTime.firstChild.firstChild.childNodes[3].innerHTML = this.getFormatedDate("%i")
		}
		this._sel._x = l;
		this._sel._y = p;
		this._sel.style.visibility = "hidden";
		this._sel.style.display = "";
		this._selCover.style.width = this.base.offsetWidth - 2 + "px";
		this._selCover.style.top = this.contMonth.offsetHeight + "px";
		this._selCover.style.height = this.contDates.offsetHeight + this.contDays.offsetHeight - 1 + "px";
		this._selCover.style.display = "";
		this._sel._t = o;
		this._sel.className = "dhtmlxcalendar_selector_obj dhtmlxcalendar_" + n;
		this._sel.childNodes[0].firstChild.firstChild.childNodes[0].style.display = this._sel.childNodes[0].firstChild.firstChild.childNodes[2].style.display = (o == "year" ? "" : "none");
		var m = Math.max(0, l - Math.round(this._sel.offsetWidth / 2));
		if (m + this._sel.offsetWidth > this._sel.parentNode.offsetWidth) {
			m = this._sel.parentNode.offsetWidth - this._sel.offsetWidth
		}
		this._sel.style.left = m + "px";
		if (o == "hours" || o == "minutes") {
			this._sel.style.top = p - this._sel.offsetHeight + "px"
		} else {
			this._sel.style.top = p + "px"
		}
		this._sel.childNodes[1].style.width = this._sel.childNodes[0].offsetWidth + "px";
		this._sel.style.visibility = "visible";
		this._doOnSelectorShow(o)
	};
	this._doOnSelectorShow = function (a) {
		if (a == "month") {
			this._updateActiveMonth()
		}
		if (a == "year") {
			this._updateYearsList(this._activeMonth)
		}
		if (a == "hours") {
			this._updateActiveHours()
		}
		if (a == "minutes") {
			this._updateActiveMinutes()
		}
	};
	this._hideSelector = function (a) {
		if (!this._sel) {
			return
		}
		this._sel.style.display = "none";
		this._sel.style.visible = "hidden";
		this._selCover.style.display = "none";
		if (this._sel._t == "minutes" && this._minutesInterval == 1) {
			this.contTime.firstChild.firstChild.childNodes[3].innerHTML = this.getFormatedDate("%i");
			this._unloadSelector("minutes")
		}
	};
	this._isSelectorVisible = function () {
		if (!this._sel) {
			return false
		}
		return (this._sel.style.display != "none")
	};
	this._doOnSelectorChange = function (a) {
		this.callEvent("onChange", [new Date(this._activeMonth.getFullYear(), this._activeMonth.getMonth(), this._activeDate.getDate(), this._activeDate.getHours(), this._activeDate.getMinutes(), this._activeDate.getSeconds()), a === true])
	};
	this._clearSelHover = function () {
		if (!this._selHover) {
			return
		}
		this._selHover.className = String(this._selHover.className.replace(/dhtmlxcalendar_selector_cell_hover/gi, ""));
		this._selHover = null
	};
	this._unloadSelector = function (m) {
		if (!this._sel) {
			return
		}
		if (!this._sel._ta[m]) {
			return
		}
		if (m == "month") {
			this.msCont.onclick = this.msCont.ontouchstart = null;
			this._msActive = null;
			for (var l in this._msCells) {
				this._msCells[l]._cell = null;
				this._msCells[l]._month = null;
				this._msCells[l].parentNode.removeChild(this._msCells[l]);
				this._msCells[l] = null
			}
			this._msCells = null;
			while (this.msCont.childNodes.length > 0) {
				this.msCont.removeChild(this.msCont.lastChild)
			}
			this.msCont.parentNode.removeChild(this.msCont);
			this.msCont = null
		}
		if (m == "year") {
			this.ysCont.onclick = this.ysCont.ontouchstart = null;
			for (var l in this._ysCells) {
				this._ysCells[l]._cell = null;
				this._ysCells[l]._year = null;
				this._ysCells[l].parentNode.removeChild(this._ysCells[l]);
				this._ysCells[l] = null
			}
			this._ysCells = null;
			while (this.ysCont.childNodes.length > 0) {
				this.ysCont.removeChild(this.ysCont.lastChild)
			}
			this.ysCont.parentNode.removeChild(this.ysCont);
			this.ysCont = null
		}
		if (m == "hours") {
			this.hsCont.onclick = this.hsCont.ontouchstart = null;
			this._hsActive = null;
			for (var l in this._hsCells) {
				this._hsCells[l]._cell = null;
				this._hsCells[l]._hours = null;
				this._hsCells[l].parentNode.removeChild(this._hsCells[l]);
				this._hsCells[l] = null
			}
			this._hsCells = null;
			while (this.hsCont.childNodes.length > 0) {
				this.hsCont.removeChild(this.hsCont.lastChild)
			}
			this.hsCont.parentNode.removeChild(this.hsCont);
			this.hsCont = null
		}
		if (m == "minutes") {
			this.rsCont.onclick = this.rsCont.ontouchstart = null;
			this._rsActive = null;
			for (var l in this._rsCells) {
				this._rsCells[l]._cell = null;
				this._rsCells[l]._minutes = null;
				this._rsCells[l].parentNode.removeChild(this._rsCells[l]);
				this._rsCells[l] = null
			}
			this._rsCells = null;
			while (this.rsCont.childNodes.length > 0) {
				this.rsCont.removeChild(this.rsCont.lastChild)
			}
			this.rsCont.parentNode.removeChild(this.rsCont);
			this.rsCont = null
		}
		this._sel._ta[m] = null
	};
	this.setMinutesInterval = function (a) {
		if (!(a == 1 || a == 5 || a == 10 || a == 15)) {
			return
		}
		this._minutesInterval = a;
		this._unloadSelector("minutes")
	};
	this._updateActiveMonth = function () {
		if (typeof(this._msActive) != "undefined" && typeof(this._msCells[this._msActive]) != "undefined") {
			this._msCells[this._msActive].className = "dhtmlxcalendar_selector_cell"
		}
		this._msActive = this._activeMonth.getMonth();
		this._msCells[this._msActive].className = "dhtmlxcalendar_selector_cell dhtmlxcalendar_selector_cell_active"
	};
	this._updateActiveYear = function () {
		var a = this._activeMonth.getFullYear();
		if (this._ysCells[a]) {
			this._ysCells[a].className = "dhtmlxcalendar_selector_cell dhtmlxcalendar_selector_cell_active"
		}
	};
	this._updateYearsList = function (p) {
		for (var m in this._ysCells) {
			this._ysCells[m] = null;
			delete this._ysCells[m]
		}
		var n = 12 * Math.floor(p.getFullYear() / 12);
		for (var o = 0; o < 4; o++) {
			for (var l = 0; l < 3; l++) {
				this.ysCont.childNodes[o].childNodes[l].innerHTML = n;
				this.ysCont.childNodes[o].childNodes[l]._year = n;
				this.ysCont.childNodes[o].childNodes[l].className = "dhtmlxcalendar_selector_cell";
				this._ysCells[n++] = this.ysCont.childNodes[o].childNodes[l]
			}
		}
		this._updateActiveYear()
	};
	this._scrollYears = function (a) {
		var m = (a < 0 ? this.ysCont.firstChild.firstChild._year : this.ysCont.lastChild.lastChild._year) + a;
		var l = new Date(m, this._activeMonth.getMonth(), 1, 0, 0, 0, 0);
		this._updateYearsList(l)
	};
	this._updateActiveHours = function () {
		if (typeof(this._hsActive) != "undefined" && typeof(this._hsCells[this._hsActive]) != "undefined") {
			this._hsCells[this._hsActive].className = "dhtmlxcalendar_selector_cell"
		}
		this._hsActive = this._activeDate.getHours();
		this._hsCells[this._hsActive].className = "dhtmlxcalendar_selector_cell dhtmlxcalendar_selector_cell_active"
	};
	this._updateVisibleHours = function () {
		this.contTime.firstChild.firstChild.childNodes[1].innerHTML = this._fixLength(this._activeDate.getHours(), 2)
	};
	this._updateActiveMinutes = function () {
		if (this._rsActive != null && typeof(this._rsActive) != "undefined" && typeof(this._rsCells[this._rsActive]) != "undefined") {
			this._rsCells[this._rsActive].className = "dhtmlxcalendar_selector_cell"
		}
		if (this._minutesInterval == 1) {
			this._rsActive = (this.getFormatedDate("%i").toString()).charAt(this._selectorMode == 1 ? 0 : 1)
		} else {
			this._rsActive = this._activeDate.getMinutes()
		}
		if (typeof(this._rsCells[this._rsActive]) != "undefined") {
			this._rsCells[this._rsActive].className = "dhtmlxcalendar_selector_cell dhtmlxcalendar_selector_cell_active"
		}
	};
	this._updateVisibleMinutes = function (l) {
		var a = this._fixLength(this._activeDate.getMinutes(), 2).toString();
		if (l == true) {
			a = a.charAt(0) + "<span class='dhtmlxcalendar_selected_date'>" + a.charAt(1) + "</span>"
		}
		this.contTime.firstChild.firstChild.childNodes[3].innerHTML = a;
		if (l == true) {
			this.contTime.firstChild.firstChild.childNodes[3].lastChild._par = true
		}
	};
	this._fixLength = function (a, l) {
		while (String(a).length < l) {
			a = "0" + String(a)
		}
		return a
	};
	this._dateFormat = "";
	this._dateFormatRE = null;
	this.setDateFormat = function (o) {
		var n = {};
		if (this._strToDate != null) {
			for (var l in this.i) {
				if (this.i[l].input != null && this.i[l].input.value.length > 0) {
					var p = this._strToDate(this.i[l].input.value);
					if (p instanceof Date) {
						n[l] = p
					}
				}
			}
		}
		this._dateFormat = o;
		var m = String(this._dateFormat).replace(/%[a-zA-Z]+/g, function (a) {
				var q = a.replace(/%/, "");
				switch (q) {
				case "n":
				case "h":
				case "j":
				case "g":
				case "G":
					return "\\d{1,2}";
				case "m":
				case "d":
				case "H":
				case "i":
				case "s":
				case "y":
					return "\\d{2}";
				case "Y":
					return "\\d{4}";
				case "M":
					return "(" + e.langData[e.lang].monthesSNames.join("|").toLowerCase() + "){1,}";
				case "F":
					return "(" + e.langData[e.lang].monthesFNames.join("|").toLowerCase() + "){1,}";
				case "D":
					return "[a-z]{2}";
				case "a":
				case "A":
					return "AM|PM"
				}
				return a
			});
		this._dateFormatRE = new RegExp(m, "i");
		for (var l in n) {
			this.i[l].input.value = this._dateToStr(n[l])
		}
		n = null
	};
	this.setDateFormat(this.langData[this.lang].dateformat || "%Y-%m-%d");
	this._getInd = function (m, a) {
		for (var l = 0; l < a.length; l++) {
			if (a[l].toLowerCase() == m) {
				return l
			}
		}
		return -1
	};
	this._updateDateStr = function (l) {
		if (!this._dateFormatRE || !l.match(this._dateFormatRE)) {
			return
		}
		if (l == this.getFormatedDate()) {
			return
		}
		var a = this._strToDate(l);
		if (!(a instanceof Date)) {
			return
		}
		if (this.checkEvent("onBeforeChange")) {
			if (!this.callEvent("onBeforeChange", [new Date(a.getFullYear(), a.getMonth(), a.getDate(), a.getHours(), a.getMinutes(), a.getSeconds())])) {
				if (this.i != null && this._activeInp != null && this.i[this._activeInp] != null && this.i[this._activeInp].input != null) {
					this.i[this._activeInp].input.value = this.getFormatedDate()
				}
				return
			}
		}
		this._nullDate = false;
		this._activeDate = a;
		this._drawMonth(this._nullDate ? new Date() : this._activeDate);
		this._updateVisibleMinutes();
		this._updateVisibleHours();
		if (this._sel && this._isSelectorVisible()) {
			this._doOnSelectorShow(this._sel._t)
		}
		this._doOnSelectorChange(true)
	};
	this.showMonth = function (a) {
		if (typeof(a) == "string") {
			a = this._strToDate(a)
		}
		if (!(a instanceof Date)) {
			return
		}
		this._drawMonth(a)
	};
	this.setFormatedDate = function (o, p, l, n) {
		var m = this._strToDate(p, o);
		if (n) {
			return m
		}
		this.setDate(m)
	};
	this.getFormatedDate = function (l, a) {
		if (!(a && a instanceof Date)) {
			if (this._nullDate) {
				return ""
			}
			a = new Date(this._activeDate)
		}
		return this._dateToStr(a, l)
	};
	this.getWeekNumber = function (o) {
		if (typeof(o) == "string") {
			o = this._strToDate(o)
		}
		if (!(o instanceof Date)) {
			return "Invalid Date"
		}
		if (typeof(this._ftDay) == "undefined") {
			this._ftDay = 4
		}
		var t = this._wStart;
		var n = t + 7;
		var s = 4;
		var l = new Date(o.getFullYear(), 0, 1, 0, 0, 0, 0);
		var m = l.getDay();
		if (m == 0) {
			m = 7
		}
		if (s < t) {
			s += 7;
			m += 7
		}
		var q = 0;
		if (m >= t && m <= s) {}
		else {
			q = 1
		}
		var p = m - t;
		var r = new Date(o.getFullYear(), 0, 1 - p + q * 7, 0, 0, 0, 0);
		var v = 604800000;
		var a = new Date(o.getFullYear(), o.getMonth(), o.getDate() + 1, 0, 0, 0, 0);
		var u = Math.ceil((a.getTime() - r.getTime()) / v);
		return u
	};
	this.showWeekNumbers = function () {
		this.base.firstChild.className = "dhtmlxcalendar_wn"
	};
	this.hideWeekNumbers = function () {
		this.base.firstChild.className = ""
	};
	this.show = function (m) {
		if (!m && this._hasParent) {
			this._show();
			return
		}
		if (typeof(m) == "object" && typeof(m._dhtmlxcalendar_uid) != "undefined" && this.i[m._dhtmlxcalendar_uid] == m) {
			this._show(m._dhtmlxcalendar_uid);
			return
		}
		if (typeof(m) == "undefined") {
			for (var l in this.i) {
				if (!m) {
					m = l
				}
			}
		}
		if (!m) {
			return
		}
		this._show(m)
	};
	this.hide = function () {
		if (this._isVisible()) {
			this._hide()
		}
	};
	this.isVisible = function () {
		return this._isVisible()
	};
	this._activeInp = null;
	this.pos = "bottom";
	this.setPosition = function (a, l) {
		this._px = null;
		this._py = null;
		if (a == "right" || a == "bottom") {
			this.pos = a
		} else {
			this.pos = "int";
			if (typeof(a) != "undefined" && !isNaN(a)) {
				this.base.style.left = a + "px";
				this._px = a
			}
			if (typeof(l) != "undefined" && !isNaN(l)) {
				this.base.style.top = l + "px";
				this._py = l
			}
			this._ifrSize()
		}
	};
	this._show = function (q, a) {
		if (a === true && this._activeInp == q && this._isVisible()) {
			this._hide();
			return
		}
		this.base.style.visibility = "hidden";
		this.base.style.display = "";
		if (!q) {
			if (this._px && this._py) {
				this.base.style.left = this._px + "px";
				this.base.style.top = this._py + "px"
			} else {
				this.base.style.left = "0px";
				this.base.style.top = "0px"
			}
		} else {
			if (this.base.className.indexOf("dhtmlxcalendar_in_input") == -1) {
				this.base.className += " dhtmlxcalendar_in_input"
			}
			var n = (this.i[q].input || this.i[q].button);
			var l = (navigator.appVersion.indexOf("MSIE") != -1);
			var o = Math.max((l ? document.documentElement : document.getElementsByTagName("html")[0]).scrollTop, document.body.scrollTop);
			var m = o + (l ? Math.max(document.documentElement.clientHeight || 0, document.documentElement.offsetHeight || 0, document.body.clientHeight || 0) : window.innerHeight);
			if (this.pos == "right") {
				this.base.style.left = this._getLeft(n) + n.offsetWidth + "px";
				this.base.style.top = Math.min(this._getTop(n), m - this.base.offsetHeight) + "px"
			} else {
				if (this.pos == "bottom") {
					var p = this._getTop(n) + n.offsetHeight + 1;
					if (p + this.base.offsetHeight > m) {
						p = this._getTop(n) - this.base.offsetHeight
					}
					this.base.style.left = this._getLeft(n) + "px";
					this.base.style.top = p + "px"
				} else {
					this.base.style.left = (this._px || 0) + "px";
					this.base.style.top = (this._py || 0) + "px"
				}
			}
			this._activeInp = q;
			n = null
		}
		this._hideSelector();
		this.base.style.visibility = "visible";
		this.base.style.zIndex = window.dhx4.zim.reserve(this.conf.zi);
		this._ifrSize();
		if (this._ifr) {
			this._ifr.style.display = ""
		}
		this.callEvent("onShow", [])
	};
	this._hide = function () {
		this._hideSelector();
		this.base.style.display = "none";
		window.dhx4.zim.clear(this.conf.zi);
		if (this.base.className.indexOf("dhtmlxcalendar_in_input") >= 0) {
			this.base.className = this.base.className.replace(/\s{0,}dhtmlxcalendar_in_input/gi, "")
		}
		this._activeInp = null;
		if (this._ifr) {
			this._ifr.style.display = "none"
		}
		this.callEvent("onHide", [])
	};
	this._isVisible = function () {
		return (this.base.style.display != "none")
	};
	this._getLeft = function (a) {
		return this._posGetOffset(a).left
	};
	this._getTop = function (a) {
		return this._posGetOffset(a).top
	};
	this._posGetOffsetSum = function (a) {
		var m = 0,
		l = 0;
		while (a) {
			m = m + parseInt(a.offsetTop);
			l = l + parseInt(a.offsetLeft);
			a = a.offsetParent
		}
		return {
			top : m,
			left : l
		}
	};
	this._posGetOffsetRect = function (n) {
		var q = n.getBoundingClientRect();
		var r = document.body;
		var l = document.documentElement;
		var a = window.pageYOffset || l.scrollTop || r.scrollTop;
		var o = window.pageXOffset || l.scrollLeft || r.scrollLeft;
		var p = l.clientTop || r.clientTop || 0;
		var s = l.clientLeft || r.clientLeft || 0;
		var t = q.top + a - p;
		var m = q.left + o - s;
		return {
			top : Math.round(t),
			left : Math.round(m)
		}
	};
	this._posGetOffset = function (a) {
		return this[a.getBoundingClientRect ? "_posGetOffsetRect" : "_posGetOffsetSum"](a)
	};
	this._rangeActive = false;
	this._rangeFrom = null;
	this._rangeTo = null;
	this._rangeSet = {};
	this.setInsensitiveDays = function (m) {
		var a = this._extractDates(m);
		for (var l = 0; l < a.length; l++) {
			this._rangeSet[new Date(a[l].getFullYear(), a[l].getMonth(), a[l].getDate(), 0, 0, 0, 0).getTime()] = true
		}
		this._drawMonth(this._activeMonth)
	};
	this.clearInsensitiveDays = function () {
		this._clearRangeSet();
		this._drawMonth(this._activeMonth)
	};
	this._holidays = {};
	this.setHolidays = function (l) {
		if (l == null) {
			this._clearHolidays()
		} else {
			if (l != null) {
				var a = this._extractDates(l);
				for (var m = 0; m < a.length; m++) {
					this._holidays[new Date(a[m].getFullYear(), a[m].getMonth(), a[m].getDate(), 0, 0, 0, 0).getTime()] = true
				}
			}
		}
		this._drawMonth(this._activeMonth)
	};
	this._extractDates = function (m) {
		if (typeof(m) == "string" || m instanceof Date) {
			m = [m]
		}
		var l = [];
		for (var n = 0; n < m.length; n++) {
			if (typeof(m[n]) == "string") {
				var o = m[n].split(",");
				for (var a = 0; a < o.length; a++) {
					l.push(this._strToDate(o[a]))
				}
			} else {
				if (m[n]instanceof Date) {
					l.push(m[n])
				}
			}
		}
		return l
	};
	this._clearRange = function () {
		this._rangeActive = false;
		this._rangeType = null;
		this._rangeFrom = null;
		this._rangeTo = null
	};
	this._clearRangeSet = function () {
		for (var l in this._rangeSet) {
			this._rangeSet[l] = null;
			delete this._rangeSet[l]
		}
	};
	this._clearHolidays = function () {
		for (var l in this._holidays) {
			this._holidays[l] = null;
			delete this._holidays[l]
		}
	};
	this._isOutOfRange = function (l) {
		if (this._rangeSet[l] == true) {
			return true
		}
		if (this._rangeActive) {
			if (this._rangeType == "in" && (l < this._rangeFrom || l > this._rangeTo)) {
				return true
			}
			if (this._rangeType == "out" && (l >= this._rangeFrom && l <= this._rangeTo)) {
				return true
			}
			if (this._rangeType == "from" && l < this._rangeFrom) {
				return true
			}
			if (this._rangeType == "to" && l > this._rangeTo) {
				return true
			}
		}
		var a = new Date(l);
		if (this._rangeWeek) {
			if (this._rangeWeekData[a.getDay()] === true) {
				return true
			}
		}
		if (this._rangeMonth) {
			if (this._rangeMonthData[a.getDate()] === true) {
				return true
			}
		}
		if (this._rangeYear) {
			if (this._rangeYearData[a.getMonth() + "_" + a.getDate()] === true) {
				return true
			}
		}
		return false
	};
	this.clearSensitiveRange = function () {
		this._clearRange();
		this._drawMonth(this._activeMonth)
	};
	this.setSensitiveRange = function (n, m, a) {
		var l = false;
		if (n != null && m != null) {
			if (!(n instanceof Date)) {
				n = this._strToDate(n)
			}
			if (!(m instanceof Date)) {
				m = this._strToDate(m)
			}
			if (n.getTime() > m.getTime()) {
				return
			}
			this._rangeFrom = new Date(n.getFullYear(), n.getMonth(), n.getDate(), 0, 0, 0, 0).getTime();
			this._rangeTo = new Date(m.getFullYear(), m.getMonth(), m.getDate(), 0, 0, 0, 0).getTime();
			this._rangeActive = true;
			this._rangeType = "in";
			l = true
		}
		if (!l && n != null && m == null) {
			if (!(n instanceof Date)) {
				n = this._strToDate(n)
			}
			this._rangeFrom = new Date(n.getFullYear(), n.getMonth(), n.getDate(), 0, 0, 0, 0).getTime();
			this._rangeTo = null;
			if (a === true) {
				this._rangeFrom++
			}
			this._rangeActive = true;
			this._rangeType = "from";
			l = true
		}
		if (!l && n == null && m != null) {
			if (!(m instanceof Date)) {
				m = this._strToDate(m)
			}
			this._rangeFrom = null;
			this._rangeTo = new Date(m.getFullYear(), m.getMonth(), m.getDate(), 0, 0, 0, 0).getTime();
			if (a === true) {
				this._rangeTo--
			}
			this._rangeActive = true;
			this._rangeType = "to";
			l = true
		}
		if (l) {
			this._drawMonth(this._activeMonth)
		}
	};
	this.setInsensitiveRange = function (l, a) {
		if (l != null && a != null) {
			if (!(l instanceof Date)) {
				l = this._strToDate(l)
			}
			if (!(a instanceof Date)) {
				a = this._strToDate(a)
			}
			if (l.getTime() > a.getTime()) {
				return
			}
			this._rangeFrom = new Date(l.getFullYear(), l.getMonth(), l.getDate(), 0, 0, 0, 0).getTime();
			this._rangeTo = new Date(a.getFullYear(), a.getMonth(), a.getDate(), 0, 0, 0, 0).getTime();
			this._rangeActive = true;
			this._rangeType = "out";
			this._drawMonth(this._activeMonth);
			return
		}
		if (l != null && a == null) {
			this.setSensitiveRange(null, l, true);
			return
		}
		if (l == null && a != null) {
			this.setSensitiveRange(a, null, true);
			return
		}
	};
	this.disableDays = function (p, o) {
		if (p == "week") {
			if (typeof(o) != "object" && typeof(o.length) == "undefined") {
				o = [o]
			}
			if (!this._rangeWeekData) {
				this._rangeWeekData = {}

			}
			for (var l in this._rangeWeekData) {
				this._rangeWeekData[l] = false;
				delete this._rangeWeekData[l]
			}
			for (var n = 0; n < o.length; n++) {
				this._rangeWeekData[o[n]] = true;
				if (o[n] == 7) {
					this._rangeWeekData[0] = true
				}
			}
			this._rangeWeek = true
		}
		if (p == "month") {
			if (typeof(o) != "object" && typeof(o.length) == "undefined") {
				o = [o]
			}
			if (!this._rangeMonthData) {
				this._rangeMonthData = {}

			}
			for (var l in this._rangeMonthData) {
				this._rangeMonthData[l] = false;
				delete this._rangeMonthData[l]
			}
			for (var n = 0; n < o.length; n++) {
				this._rangeMonthData[o[n]] = true
			}
			this._rangeMonth = true
		}
		if (p == "year") {
			var m = this._extractDates(o);
			if (!this._rangeYearData) {
				this._rangeYearData = {}

			}
			for (var l in this._rangeYearData) {
				this._rangeYearData[l] = false;
				delete this._rangeYearData[l]
			}
			for (var n = 0; n < m.length; n++) {
				this._rangeYearData[m[n].getMonth() + "_" + m[n].getDate()] = true
			}
			this._rangeYear = true
		}
		this._drawMonth(this._activeMonth)
	};
	this.enableDays = function (a) {
		if (a == "week") {
			this._rangeWeek = false
		}
		if (a == "month") {
			this._rangeMonth = false
		}
		if (a == "year") {
			this._rangeYear = false
		}
		this._drawMonth(this._activeMonth)
	};
	this._tipData = {};
	this._tipTM = null;
	this._tipTMTime = 400;
	this._tipEvs = false;
	this._tipPopup = null;
	this._tipCellDate = null;
	this._tipCellDim = null;
	this.setTooltip = function (m, p, r, a) {
		var n = this._extractDates(m);
		for (var o = 0; o < n.length; o++) {
			var l = new Date(n[o].getFullYear(), n[o].getMonth(), n[o].getDate(), 0, 0, 0, 0).getTime();
			this._tipData[l] = {
				text : p,
				showIcon : r,
				usePopup : a
			}
		}
		this._drawMonth(this._activeMonth)
	};
	this.clearTooltip = function (l) {
		var m = this._extractDates(l);
		for (var n = 0; n < m.length; n++) {
			var a = new Date(m[n].getFullYear(), m[n].getMonth(), m[n].getDate(), 0, 0, 0, 0).getTime();
			this._tipData[a] = null;
			delete this._tipData[a]
		}
		this._drawMonth(this._activeMonth)
	};
	this._initTooltipPopup = function () {
		if (this._tipEvs) {
			return
		}
		this.attachEvent("onMouseOver", function (l) {
			var a = new Date(l.getFullYear(), l.getMonth(), l.getDate(), 0, 0, 0, 0).getTime();
			if (this._tipData[a] != null) {
				if (this._tipTM) {
					window.clearTimeout(this._tipTM)
				}
				this._tipCellDate = l;
				this._tipCellDim = this.getCellDimension(l);
				this._tipText = this._tipData[a].text;
				this._tipTM = window.setTimeout(this._showTooltipPopup, this._tipTMTime)
			}
		});
		this.attachEvent("onMouseOut", this._hideTooltipPopup);
		this._tipEvs = true
	};
	this._showTooltipPopup = function (n, a, o, l, m) {
		if (!e._tipPopup) {
			e._tipPopup = new dhtmlXPopup({
					mode : "top"
				})
		}
		e._tipPopup.attachHTML(e._tipText);
		e._tipPopup.show(e._tipCellDim.x, e._tipCellDim.y, e._tipCellDim.w, e._tipCellDim.h);
		e.callEvent("onPopupShow", [e._tipCellDate])
	};
	this._hideTooltipPopup = function () {
		if (this._tipTM) {
			window.clearTimeout(this._tipTM)
		}
		if (this._tipPopup != null && this._tipPopup.isVisible()) {
			this._tipPopup.hide();
			this.callEvent("onPopupHide", [this._tipCellDate])
		}
	};
	this.getPopup = function () {
		return this._tipPopup
	};
	this.getCellDimension = function (m) {
		if (typeof(m) == "string") {
			m = this._strToDate(m)
		}
		if (!(m instanceof Date)) {
			return null
		}
		var n = new Date(m.getFullYear(), m.getMonth(), m.getDate(), 0, 0, 0, 0).getTime();
		var l = null;
		for (var o = 0; o < this.contDates.childNodes.length; o++) {
			for (var a = 0; a < this.contDates.childNodes[o].childNodes.length; a++) {
				var r = this.contDates.childNodes[o].childNodes[a];
				if (r._date != null && r._date.getTime() == n) {
					l = {
						x : this._getLeft(r),
						y : this._getTop(r),
						w : r.offsetWidth,
						h : r.offsetHeight
					}
				}
				r = null
			}
		}
		return l
	};
	this._updateFromInput = function (a) {
		if (this._nullInInput && ((a.value).replace(/\s/g, "")).length == 0) {
			if (this.checkEvent("onBeforeChange")) {
				if (!this.callEvent("onBeforeChange", [null])) {
					if (this.i != null && this._activeInp != null && this.i[this._activeInp] != null && this.i[this._activeInp].input != null) {
						this.i[this._activeInp].input.value = this.getFormatedDate()
					}
					return
				}
			}
			this.setDate(null)
		} else {
			this._updateDateStr(a.value)
		}
		a = null
	};
	this._doOnClick = function (l) {
		l = l || event;
		var a = (l.target || l.srcElement);
		if (a._dhtmlxcalendar_uid && a._dhtmlxcalendar_uid != e._activeInp && e._isVisible() && e._activeInp) {
			e._hide();
			return
		}
		if (!a._dhtmlxcalendar_uid || !e.i[a._dhtmlxcalendar_uid]) {
			if (e._isSelectorVisible()) {
				e._hideSelector()
			} else {
				if (!e._hasParent && e._isVisible()) {
					e._hide()
				}
			}
		}
	};
	this._doOnKeyDown = function (a) {
		a = a || event;
		if (a.keyCode == 27 || a.keyCode == 13) {
			if (e._isSelectorVisible()) {
				e._hideSelector()
			} else {
				if (e._isVisible() && !e._hasParent) {
					e._hide()
				}
			}
		}
	};
	this._doOnInpClick = function (l) {
		l = l || event;
		var a = (l.target || l.srcElement);
		if (!a._dhtmlxcalendar_uid) {
			return
		}
		if (!e._listenerEnabled) {
			e._updateFromInput(a)
		}
		e._show(a._dhtmlxcalendar_uid, true)
	};
	this._doOnInpKeyUp = function (l) {
		l = l || event;
		var a = (l.target || l.srcElement);
		if (l.keyCode == 13 || !a._dhtmlxcalendar_uid) {
			return
		}
		if (!e._listenerEnabled) {
			e._updateFromInput(a)
		}
	};
	this._doOnBtnClick = function (l) {
		l = l || event;
		var a = (l.target || l.srcElement);
		if (!a._dhtmlxcalendar_uid) {
			return
		}
		if (e.i[a._dhtmlxcalendar_uid].input != null) {
			e._updateFromInput(e.i[a._dhtmlxcalendar_uid].input)
		}
		e._show(a._dhtmlxcalendar_uid, true)
	};
	this._doOnUnload = function () {
		if (e && e.unload) {
			e.unload()
		}
	};
	if (typeof(window.addEventListener) == "function") {
		document.body.addEventListener((this.conf.touch ? "touchstart" : "click"), e._doOnClick, false);
		window.addEventListener("keydown", e._doOnKeyDown, false);
		window.addEventListener("unload", e._doOnUnload, false)
	} else {
		document.body.attachEvent("onclick", e._doOnClick);
		document.body.attachEvent("onkeydown", e._doOnKeyDown);
		window.attachEvent("onunload", e._doOnUnload)
	}
	this.attachObj = function (m) {
		var l = window.dhx4.newId();
		if (typeof(m) == "string") {
			this.i[l] = {
				input : document.getElementById(m)
			}
		} else {
			if (typeof(m.tagName) != "undefined") {
				this.i[l] = {
					input : m
				}
			} else {
				if (typeof(m) == "object" && (m.input != null || m.button != null)) {
					this.i[l] = {};
					if (m.input != null) {
						this.i[l].input = (typeof(m.input) == "string" ? document.getElementById(m.input) : m.input)
					}
					if (m.button != null) {
						this.i[l].button = (typeof(m.button) == "string" ? document.getElementById(m.button) : m.button)
					}
				}
			}
		}
		this._attachEventsToObject(l);
		return l
	};
	this.detachObj = function (n) {
		var m = null;
		if (this.i[n] != null) {
			m = n
		} else {
			if (typeof(n) == "string") {
				n = document.getElementById(n);
				m = n._dhtmlxcalendar_uid
			} else {
				if (typeof(n.tagName) != "undefined") {
					m = n._dhtmlxcalendar_uid
				} else {
					if (typeof(n) == "object" && (n.input != null || n.button != null)) {
						if (m == null && n.input != null) {
							m = (typeof(n.input) == "string" ? document.getElementById(n.input) : n.input)._dhtmlxcalendar_uid
						}
						if (m == null && n.button != null) {
							m = (typeof(n.button) == "string" ? document.getElementById(n.button) : n.button)._dhtmlxcalendar_uid
						}
					}
				}
			}
		}
		if (m != null && this.i[m] != null) {
			this._detachEventsFromObject(m);
			for (var l in this.i[l]) {
				this.i[m][l]._dhtmlxcalendar_uid = null;
				this.i[m][l] = null;
				delete this.i[m][l]
			}
			this.i[m] = null;
			delete this.i[m];
			return true
		}
		return false
	};
	this._attachEventsToObject = function (l) {
		if (this.i[l].button != null) {
			this.i[l].button._dhtmlxcalendar_uid = l;
			if (typeof(window.addEventListener) == "function") {
				this.i[l].button.addEventListener((this.conf.touch ? "touchstart" : "click"), e._doOnBtnClick, false)
			} else {
				this.i[l].button.attachEvent("onclick", e._doOnBtnClick)
			}
		} else {
			if (this.i[l].input != null) {
				this.i[l].input._dhtmlxcalendar_uid = l;
				if (typeof(window.addEventListener) == "function") {
					this.i[l].input.addEventListener((this.conf.touch ? "touchstart" : "click"), e._doOnInpClick, false);
					this.i[l].input.addEventListener("keyup", e._doOnInpKeyUp, false)
				} else {
					this.i[l].input.attachEvent("onclick", e._doOnInpClick);
					this.i[l].input.attachEvent("onkeyup", e._doOnInpKeyUp)
				}
			}
		}
	};
	this._detachEventsFromObject = function (l) {
		if (this.i[l].button != null) {
			if (typeof(window.addEventListener) == "function") {
				this.i[l].button.removeEventListener((this.conf.touch ? "touchstart" : "click"), e._doOnBtnClick, false)
			} else {
				this.i[l].button.detachEvent("onclick", e._doOnBtnClick)
			}
		} else {
			if (this.i[l].input != null) {
				if (typeof(window.addEventListener) == "function") {
					this.i[l].input.removeEventListener((this.conf.touch ? "touchstart" : "click"), e._doOnInpClick, false);
					this.i[l].input.removeEventListener("keyup", e._doOnInpKeyUp, false)
				} else {
					this.i[l].input.detachEvent("onclick", e._doOnInpClick);
					this.i[l].input.detachEvent("onkeyup", e._doOnInpKeyUp)
				}
			}
		}
	};
	this.enableListener = function (a) {
		if (!a) {
			return
		}
		if (typeof(window.addEventListener) == "function") {
			a.addEventListener("focus", e._listenerEvFocus, false);
			a.addEventListener("blur", e._listenerEvBlur, false)
		} else {
			a.attachEvent("onfocus", e._listenerEvFocus);
			a.attachEvent("onblur", e._listenerEvBlur)
		}
		a = null
	};
	this.disableListener = function (a) {
		if (!a) {
			return
		}
		a._f0 = false;
		if (this._tmListener) {
			window.clearTimeout(this._tmListener)
		}
		if (typeof(window.addEventListener) == "function") {
			a.removeEventListener("focus", e._listenerEvFocus, false);
			a.removeEventListener("blur", e._listenerEvBlur, false)
		} else {
			a.detachEvent("onfocus", e._listenerEvFocus);
			a.detachEvent("onblur", e._listenerEvBlur)
		}
		a = null
	};
	this._startListener = function (a) {
		if (this._tmListener) {
			window.clearTimeout(this._tmListener)
		}
		if (typeof(a._v1) == "undefined") {
			a._v1 = a.value
		}
		if (a._v1 != a.value) {
			this._updateFromInput(a);
			a._v1 = a.value
		}
		if (a._f0) {
			this._tmListener = window.setTimeout(function () {
					e._startListener(a)
				}, 100)
		}
	};
	this._listenerEvFocus = function (l) {
		l = l || event;
		var a = l.target || l.srcElement;
		a._f0 = true;
		e._startListener(a);
		a = null
	};
	this._listenerEvBlur = function (l) {
		l = l || event;
		var a = l.target || l.srcElement;
		a._f0 = false;
		a = null
	};
	for (var h in this.i) {
		this._attachEventsToObject(h)
	}
	window.dhx4._eventable(this);
	this._evOnArrowClick = function (a) {
		return this.callEvent("onArrowClick", a)
	};
	this._evOnClick = function (a) {
		return this.callEvent("onClick", a)
	};
	this._evOnMouseOut = function (a) {
		return this.callEvent("onMouseOut", a)
	};
	this._evOnMouseOver = function (a) {
		return this.callEvent("onMouseOver", a)
	};
	this.unload = function () {
		this._activeDate = null;
		this._activeDateCell = null;
		this._activeInp = null;
		this._activeMonth = null;
		this._dateFormat = null;
		this._dateFormatRE = null;
		this._lastHover = null;
		if (this._tmListener) {
			window.clearTimeout(this._tmListener)
		}
		this._tmListener = null;
		if (typeof(window.addEventListener) == "function") {
			document.body.removeEventListener((this.conf.touch ? "touchstart" : "click"), e._doOnClick, false);
			window.removeEventListener("keydown", e._doOnKeyDown, false);
			window.removeEventListener("unload", e._doOnUnload, false)
		} else {
			document.body.detachEvent("onclick", e._doOnClick);
			document.body.detachEvent("onkeydown", e._doOnKeyDown);
			window.detachEvent("onunload", e._doOnKeyDown)
		}
		this._doOnClick = null;
		this._doOnKeyDown = null;
		this._doOnUnload = null;
		for (var l in this.i) {
			this.i[l]._dhtmlxcalendar_uid = null;
			this._detachEventsFromObject(l);
			this.disableListener(this.i[l].input);
			this.i[l] = null;
			delete this.i[l]
		}
		this.i = null;
		this._doOnInpClick = null;
		this._doOnInpKeyUp = null;
		window.dhx4._eventable(this, "clear");
		this.contMonth.onselectstart = null;
		this.contMonth.firstChild.firstChild.onclick = null;
		this.contMonth.firstChild.firstChild.ontouchstart = null;
		this.contMonth.firstChild.firstChild.firstChild.onmouseover = null;
		this.contMonth.firstChild.firstChild.firstChild.onmouseout = null;
		this.contMonth.firstChild.firstChild.lastChild.onmouseover = null;
		this.contMonth.firstChild.firstChild.lastChild.onmouseout = null;
		while (this.contMonth.firstChild.firstChild.childNodes.length > 0) {
			this.contMonth.firstChild.firstChild.removeChild(this.contMonth.firstChild.firstChild.lastChild)
		}
		this.contMonth.firstChild.removeChild(this.contMonth.firstChild.firstChild);
		this.contMonth.removeChild(this.contMonth.firstChild);
		this.contMonth.parentNode.removeChild(this.contMonth);
		this.contMonth = null;
		while (this.contDays.firstChild.childNodes.length > 0) {
			this.contDays.firstChild.removeChild(this.contDays.firstChild.lastChild)
		}
		this.contDays.removeChild(this.contDays.firstChild);
		this.contDays.parentNode.removeChild(this.contDays);
		this.contDays = null;
		this.contDates.onclick = null;
		this.contDates.ontouchstart = null;
		this.contDates.onmouseover = null;
		this.contDates.onmouseout = null;
		while (this.contDates.childNodes.length > 0) {
			while (this.contDates.lastChild.childNodes.length > 0) {
				this.contDates.lastChild.lastChild._css_date = null;
				this.contDates.lastChild.lastChild._css_month = null;
				this.contDates.lastChild.lastChild._css_weekend = null;
				this.contDates.lastChild.lastChild._css_hover = null;
				this.contDates.lastChild.lastChild._date = null;
				this.contDates.lastChild.lastChild._q = null;
				this.contDates.lastChild.lastChild._w = null;
				this.contDates.lastChild.removeChild(this.contDates.lastChild.lastChild)
			}
			this.contDates.removeChild(this.contDates.lastChild)
		}
		this.contDates.parentNode.removeChild(this.contDates);
		this.contDates = null;
		this.contTime.firstChild.firstChild.onclick = null;
		this.contTime.firstChild.firstChild.ontouchstart = null;
		while (this.contTime.firstChild.firstChild.childNodes.length > 0) {
			this.contTime.firstChild.firstChild.removeChild(this.contTime.firstChild.firstChild.lastChild)
		}
		this.contTime.firstChild.removeChild(this.contTime.firstChild.firstChild);
		this.contTime.removeChild(this.contTime.firstChild);
		this.contTime.parentNode.removeChild(this.contTime);
		this.contTime = null;
		this._lastHover = null;
		this._unloadSelector("month");
		this._unloadSelector("year");
		this._unloadSelector("hours");
		this._unloadSelector("minutes");
		if (this._selCover) {
			this._selCover.parentNode.removeChild(this._selCover);
			this._selCover = null
		}
		if (this._sel) {
			for (var l in this._sel._ta) {
				this._sel._ta[l] = null
			}
			this._sel._ta = null;
			this._sel._t = null;
			this._sel.onmouseover = null;
			this._sel.onmouseout = null;
			while (this._sel.firstChild.firstChild.firstChild.childNodes.length > 0) {
				this._sel.firstChild.firstChild.firstChild.lastChild.onclick = null;
				this._sel.firstChild.firstChild.firstChild.lastChild.onmouseover = null;
				this._sel.firstChild.firstChild.firstChild.lastChild.onmouseout = null;
				this._sel.firstChild.firstChild.firstChild.removeChild(this._sel.firstChild.firstChild.firstChild.lastChild)
			}
			this._sel.firstChild.firstChild.removeChild(this._sel.firstChild.firstChild.firstChild);
			this._sel.firstChild.removeChild(this._sel.firstChild.firstChild);
			while (this._sel.childNodes.length > 0) {
				this._sel.removeChild(this._sel.lastChild)
			}
			this._sel.parentNode.removeChild(this._sel);
			this._sel = null
		}
		this.base.onclick = null;
		this.base.onmousedown = null;
		this.base.ontouchstart = null;
		this.base.onmouseout = null;
		this.base.parentNode.removeChild(this.base);
		this.base = null;
		this._clearDayHover = null;
		this._clearSelHover = null;
		this._doOnSelectorChange = null;
		this._doOnSelectorShow = null;
		this._drawMonth = null;
		this._fixLength = null;
		this._getLeft = null;
		this._getTop = null;
		this._ifrSize = null;
		this._hide = null;
		this._hideSelector = null;
		this._initSelector = null;
		this._isSelectorVisible = null;
		this._isVisible = null;
		this._posGetOffset = null;
		this._posGetOffsetRect = null;
		this._posGetOffsetSum = null;
		this._scrollYears = null;
		this._show = null;
		this._showSelector = null;
		this._strToDate = null;
		this._updateActiveHours = null;
		this._updateActiveMinutes = null;
		this._updateActiveMonth = null;
		this._updateActiveYear = null;
		this._updateCellStyle = null;
		this._updateDateStr = null;
		this._updateVisibleHours = null;
		this._updateVisibleMinutes = null;
		this._updateYearsList = null;
		this.enableIframe = null;
		this.hide = null;
		this.hideTime = null;
		this.setDate = null;
		this.setDateFormat = null;
		this.setYearsRange = null;
		this.show = null;
		this.showTime = null;
		this.unload = null;
		if (this._tipPopup != null) {
			this._tipPopup.unload();
			this._tipPopup = null
		}
		for (var l in this) {
			delete this[l]
		}
		l = e = null
	};
	this.setDate(this._activeDate);
	return this
}
dhtmlXCalendarObject.prototype.lang = "en";
dhtmlXCalendarObject.prototype.langData = {
	en : {
		dateformat : "%Y-%m-%d",
		hdrformat : "%F %Y",
		monthesFNames : ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
		monthesSNames : ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
		daysFNames : ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
		daysSNames : ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
		weekstart : 1,
		weekname : "w"
	}
};
dhtmlXCalendarObject.prototype._buildMonthHdr = function (e) {
	var b = this;
	var d = function (f) {
		return (String(f).length == 1 ? "0" + String(f) : f)
	};
	var a = function (f, g) {
		return "<span class='dhtmlxcalendar_month_label_" + f + "'>" + g + "</span>"
	};
	var c = String(this.langData[this.lang].hdrformat || ("%F %Y")).replace(/%[a-z]/gi, function (f) {
			switch (f) {
			case "%m":
				return a("month", d(e.getMonth() + 1));
			case "%n":
				return a("month", e.getMonth() + 1);
			case "%M":
				return a("month", b.langData[b.lang].monthesSNames[e.getMonth()]);
			case "%F":
				return a("month", b.langData[b.lang].monthesFNames[e.getMonth()]);
			case "%y":
				return a("year", d(e.getYear() % 100));
			case "%Y":
				return a("year", e.getFullYear());
			case "%%":
				return "%";
			default:
				return f
			}
		});
	b = d = a = null;
	return c
};
dhtmlXCalendarObject.prototype.enableIframe = function (a) {
	if (a == true) {
		if (!this._ifr) {
			this._ifr = document.createElement("IFRAME");
			this._ifr.frameBorder = 0;
			this._ifr.border = 0;
			this._ifr.setAttribute("src", "javascript:false;");
			this._ifr.className = "dhtmlxcalendar_ifr";
			this._ifr.onload = function () {
				this.onload = null;
				this.contentWindow.document.open("text/html", "replace");
				this.contentWindow.document.write("<html><head><style>html,body{width:100%;height:100%;overflow:hidden;margin:0px;}</style></head><body</body></html>")
			};
			this.base.parentNode.insertBefore(this._ifr, this.base);
			this._ifrSize()
		}
	} else {
		if (this._ifr) {
			this._ifr.parentNode.removeChild(this._ifr);
			this._ifr = null
		}
	}
};
dhtmlXCalendarObject.prototype._ifrSize = function () {
	if (this._ifr) {
		this._ifr.style.left = this.base.style.left;
		this._ifr.style.top = this.base.style.top;
		this._ifr.style.width = this.base.offsetWidth + "px";
		this._ifr.style.height = this.base.offsetHeight + "px"
	}
};
dhtmlxCalendarObject = dhtmlXCalendarObject;
dhtmlXCalendarObject.prototype._strToDate = function (g, s) {
	s = (s || this._dateFormat);
	s = s.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\\:|]/g, "\\$&");
	var u = [];
	var l = [];
	s = s.replace(/%[a-z]/gi, function (e) {
			switch (e) {
			case "%d":
			case "%m":
			case "%y":
			case "%h":
			case "%H":
			case "%i":
			case "%s":
				l.push(e);
				return "(\\d{2})";
			case "%D":
			case "%l":
			case "%M":
			case "%F":
				l.push(e);
				return "([a-zéûä\u0430-\u044F\u0451]{1,})";
			case "%j":
			case "%n":
			case "%g":
			case "%G":
				l.push(e);
				return "(\\d{1,2})";
			case "%Y":
				l.push(e);
				return "(\\d{4})";
			case "%a":
				l.push(e);
				return "(\\[am|pm])";
			case "%A":
				l.push(e);
				return "(\\[AM|PM])"
			}
			return e
		});
	var x = new RegExp(s);
	var m = g.match(x);
	if (m == null || m.length - 1 != l.length) {
		return "Invalid Date"
	}
	for (var b = 1; b < m.length; b++) {
		u.push(m[b])
	}
	var c = {
		"%y" : 1,
		"%Y" : 1,
		"%n" : 2,
		"%m" : 2,
		"%M" : 2,
		"%F" : 2,
		"%d" : 3,
		"%j" : 3,
		"%a" : 4,
		"%A" : 4,
		"%H" : 5,
		"%G" : 5,
		"%h" : 5,
		"%g" : 5,
		"%i" : 6,
		"%s" : 7
	};
	var n = {};
	var i = {};
	for (var b = 0; b < l.length; b++) {
		if (typeof(c[l[b]]) != "undefined") {
			var d = c[l[b]];
			if (!n[d]) {
				n[d] = [];
				i[d] = []
			}
			n[d].push(u[b]);
			i[d].push(l[b])
		}
	}
	u = [];
	l = [];
	for (var b = 1; b <= 7; b++) {
		if (n[b] != null) {
			for (var o = 0; o < n[b].length; o++) {
				u.push(n[b][o]);
				l.push(i[b][o])
			}
		}
	}
	var j = this;
	var a = new Date();
	a.setDate(1);
	a.setMinutes(0);
	a.setSeconds(0);
	for (var b = 0; b < u.length; b++) {
		switch (l[b]) {
		case "%d":
		case "%j":
		case "%n":
		case "%m":
		case "%Y":
		case "%H":
		case "%G":
		case "%i":
		case "%s":
			if (!isNaN(u[b])) {
				a[{
						"%d" : "setDate",
						"%j" : "setDate",
						"%n" : "setMonth",
						"%m" : "setMonth",
						"%Y" : "setFullYear",
						"%H" : "setHours",
						"%G" : "setHours",
						"%i" : "setMinutes",
						"%s" : "setSeconds"
					}
					[l[b]]](Number(u[b]) + (l[b] == "%m" || l[b] == "%n" ? -1 : 0))
			}
			break;
		case "%M":
		case "%F":
			var h = this._getInd(u[b].toLowerCase(), j.langData[j.lang][{
							"%M" : "monthesSNames",
							"%F" : "monthesFNames"
						}
						[l[b]]]);
			if (h >= 0) {
				a.setMonth(h)
			}
			break;
		case "%y":
			if (!isNaN(u[b])) {
				var t = Number(u[b]);
				a.setFullYear(t + (t > 50 ? 1900 : 2000))
			}
			break;
		case "%g":
		case "%h":
			if (!isNaN(u[b])) {
				var t = Number(u[b]);
				if (t <= 12 && t >= 0) {
					a.setHours(t + (this._getInd("pm", u) >= 0 ? (t == 12 ? 0 : 12) : (t == 12 ? -12 : 0)))
				}
			}
			break
		}
	}
	j = null;
	return a
};
dhtmlXCalendarObject.prototype._dateToStr = function (f, d) {
	var c = this;
	if (f instanceof Date) {
		var e = function (g) {
			return (String(g).length == 1 ? "0" + String(g) : g)
		};
		var a = function (g) {
			switch (g) {
			case "%d":
				return e(f.getDate());
			case "%j":
				return f.getDate();
			case "%D":
				return c.langData[c.lang].daysSNames[f.getDay()];
			case "%l":
				return c.langData[c.lang].daysFNames[f.getDay()];
			case "%m":
				return e(f.getMonth() + 1);
			case "%n":
				return f.getMonth() + 1;
			case "%M":
				return c.langData[c.lang].monthesSNames[f.getMonth()];
			case "%F":
				return c.langData[c.lang].monthesFNames[f.getMonth()];
			case "%y":
				return e(f.getYear() % 100);
			case "%Y":
				return f.getFullYear();
			case "%g":
				return (f.getHours() + 11) % 12 + 1;
			case "%h":
				return e((f.getHours() + 11) % 12 + 1);
			case "%G":
				return f.getHours();
			case "%H":
				return e(f.getHours());
			case "%i":
				return e(f.getMinutes());
			case "%s":
				return e(f.getSeconds());
			case "%a":
				return (f.getHours() > 11 ? "pm" : "am");
			case "%A":
				return (f.getHours() > 11 ? "PM" : "AM");
			case "%%":
				"%";
			default:
				return g
			}
		};
		var b = String(d || this._dateFormat).replace(/%[a-zA-Z]/g, a)
	}
	c = null;
	return (b || String(f))
};
window.dhtmlxDblCalendarObject = window.dhtmlXDoubleCalendarObject = window.dhtmlXDoubleCalendar = function (b) {
	var a = this;
	this.leftCalendar = new dhtmlXCalendarObject(b);
	this.leftCalendar.hideTime();
	this.rightCalendar = new dhtmlXCalendarObject(b);
	this.rightCalendar.hideTime();
	this.leftCalendar.attachEvent("onClick", function (c) {
		a._updateRange("rightCalendar", c, null);
		a._evOnClick(["left", c])
	});
	this.rightCalendar.attachEvent("onClick", function (c) {
		a._updateRange("leftCalendar", null, c);
		a._evOnClick(["right", c])
	});
	this.leftCalendar.attachEvent("onBeforeChange", function (c) {
		return a._evOnBeforeChange(["left", c])
	});
	this.rightCalendar.attachEvent("onBeforeChange", function (c) {
		return a._evOnBeforeChange(["right", c])
	});
	this.show = function () {
		this.leftCalendar.show();
		this.rightCalendar.base.style.marginLeft = this.leftCalendar.base.offsetWidth - 1 + "px";
		this.rightCalendar.show()
	};
	this.hide = function () {
		this.leftCalendar.hide();
		this.rightCalendar.hide()
	};
	this.setDateFormat = function (c) {
		this.leftCalendar.setDateFormat(c);
		this.rightCalendar.setDateFormat(c)
	};
	this.setDates = function (d, c) {
		if (d != null) {
			this.leftCalendar.setDate(d)
		}
		if (c != null) {
			this.rightCalendar.setDate(c)
		}
		this._updateRange()
	};
	this._updateRange = function (c, e, d) {
		if (arguments.length == 3) {
			(c == "leftCalendar" ? this.leftCalendar : this.rightCalendar).setSensitiveRange(e, d)
		} else {
			this.leftCalendar.setSensitiveRange(null, this.rightCalendar.getDate());
			this.rightCalendar.setSensitiveRange(this.leftCalendar.getDate(), null)
		}
	};
	this.getFormatedDate = function () {
		return this.leftCalendar.getFormatedDate.apply(this.leftCalendar, arguments)
	};
	this.unload = function () {
		window.dhx4._eventable(this, "clear");
		this.leftCalendar.unload();
		this.rightCalendar.unload();
		this.leftCalendar = this.rightCalendar = null;
		this._updateRange = null;
		this._evOnClick = null;
		this._evOnBeforeChange = null;
		this.show = null;
		this.hide = null;
		this.setDateFormat = null;
		this.setDates = null;
		this.getFormatedDate = null;
		this.unload = null;
		a = null
	};
	this._evOnClick = function (c) {
		return this.callEvent("onClick", c)
	};
	this._evOnBeforeChange = function (c) {
		return this.callEvent("onBeforeChange", c)
	};
	window.dhx4._eventable(this);
	return this
};
