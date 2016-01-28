//v.3.0 build 110713
/*
Copyright DHTMLX LTD. http://www.dhtmlx.com
To use this component please contact sales@dhtmlx.com to obtain license
*/
function dhtmlXWindowsSngl() {}

function dhtmlXWindowsBtn() {}

function dhtmlXWindows() {
    if (window.dhtmlXContainer) {
        this.engine = "dhx";
        var b = "_" + this.engine + "_Engine";
        if (this[b]) {
            this[b]();
            this._isIPad = navigator.userAgent.search(/iPad/gi) >= 0;
            var c = this;
            this.pathPrefix = "dhxwins_";
            this.imagePath = dhtmlx.image_path || "codebase/imgs/";
            this.setImagePath = function (a) {
                this.imagePath = a
            };
            this.skin = "dhx_skyblue";
            this.skinParams = {
                dhx_black: {
                    header_height: 21,
                    border_left_width: 2,
                    border_right_width: 2,
                    border_bottom_height: 2
                },
                dhx_blue: {
                    header_height: 21,
                    border_left_width: 2,
                    border_right_width: 2,
                    border_bottom_height: 2
                },
                dhx_skyblue: {
                    header_height: 21,
                    border_left_width: 2,
                    border_right_width: 2,
                    border_bottom_height: 2
                }
            };
            this.setSkin = function (a) {
                this.skin = a;
                this._engineRedrawSkin()
            };
            this.isWindow = function (a) {
                var c = this.wins[a] != null;
                return c
            };
            this.findByText = function (a) {
                var c = [],
                    b;
                for (b in this.wins) this.wins[b].getText().search(a, "gi") >= 0 && (c[c.length] = this.wins[b]);
                return c
            };
            this.window = function (a) {
                var c = null;
                this.wins[a] != null && (c = this.wins[a]);
                return c
            };
            this.forEachWindow = function (a) {
                for (var c in this.wins) a(this.wins[c])
            };
            this.getBottommostWindow = function () {
                var a = this.getTopmostWindow(),
                    c;
                for (c in this.wins) this.wins[c].zi < a.zi && (a = this.wins[c]);
                return a.zi != 0 ? a : null
            };
            this.getTopmostWindow = function (a) {
                var c = {
                        zi: 0
                    },
                    b;
                for (b in this.wins) this.wins[b].zi > c.zi && (a == !0 && !this._isWindowHidden(this.wins[b]) && (c = this.wins[b]), a != !0 && (c = this.wins[b]));
                return c.zi != 0 ? c : null
            };
            this.wins = {};
            for (var e in this.wins) delete this.wins[e];
            this.autoViewport = !0;
            this._createViewport = function () {
                this.vp = document.body;
                this._clearVPCss();
                this.vp._css =
                    String(this.vp.className).length > 0 ? this.vp.className : "";
                this.vp.className += " dhtmlx_skin_" + this.skin + (this._r ? " dhx_wins_rtl" : "");
                this.modalCoverI = document.createElement("IFRAME");
                this.modalCoverI.frameBorder = "0";
                this.modalCoverI.className = "dhx_modal_cover_ifr";
                this.modalCoverI.setAttribute("src", "javascript:false;");
                this.modalCoverI.style.display = "none";
                this.modalCoverI.style.zIndex = 0;
                this.vp.appendChild(this.modalCoverI);
                this.modalCoverD = document.createElement("DIV");
                this.modalCoverD.className =
                    "dhx_modal_cover_dv";
                this.modalCoverD.style.display = "none";
                this.modalCoverD.style.zIndex = 0;
                this.vp.appendChild(this.modalCoverD);
                this._vpcover = document.createElement("DIV");
                this._vpcover.className = "dhx_content_vp_cover";
                this._vpcover.style.display = "none";
                this.vp.appendChild(this._vpcover);
                this._carcass = document.createElement("DIV");
                this._carcass.className = "dhx_carcass_resmove";
                this._carcass.style.display = "none";
                if (_isIE) this._carcass.innerHTML = "<iframe border=0 frameborder=0 style='filter: alpha(opacity=0); width: 100%; height:100%; position: absolute; top: 0px; left: 0px; width: 100%; height: 100%;'></iframe><div style='position: absolute; top: 0px; left: 0px; width: 100%; height: 100%;'></div>",
                    this._carcass.childNodes[0].setAttribute("src", "javascript:false;");
                this._carcass.onselectstart = function (a) {
                    a = a || event;
                    a.returnValue = !1
                };
                this.vp.appendChild(this._carcass)
            };
            this._clearVPCss = function () {
                this.vp.className = String(this.vp.className).replace(/[a-z_]{1,}/gi, function (a) {
                    return {
                        dhtmlx_skin_dhx_skyblue: 1,
                        dhtmlx_skin_dhx_blue: 1,
                        dhtmlx_skin_dhx_black: 1,
                        dhtmlx_skin_dhx_web: 1
                    }[a] == 1 ? "" : a
                })
            };
            this._autoResizeViewport = function () {
                for (var a in this.wins) {
                    if (this.wins[a]._isFullScreened) this.wins[a]._content.style.width =
                        document.body.offsetWidth - (_isIE ? 4 : 0) + "px", this.wins[a]._content.style.height = document.body.offsetHeight == 0 ? window.innerHeight ? window.innerHeight + "px" : document.body.scrollHeight + "px" : document.body.offsetHeight - (_isIE ? 4 : 0) + "px", this.wins[a].layout != null && _isOpera && this.wins[a].layout._fixCellsContentOpera950(), this.wins[a].updateNestedObjects();
                    this.wins[a]._isMaximized && this.wins[a].style.display != "none" && (this._restoreWindow(this.wins[a]), this._maximizeWindow(this.wins[a]))
                }
                if (this.vp != document.body &&
                    this.autoViewport != !1)
                    for (a in this.vp.style.width = (_isIE ? document.body.offsetWidth - 4 : window.innerWidth) + "px", this.vp.style.height = (_isIE ? document.body.offsetHeight - 4 : window.innerHeight) + "px", this.wins) {
                        var c = this.wins[a],
                            b = !1,
                            e = !1;
                        if (c.x > this.vp.offsetWidth - 10) c.x = this.vp.offsetWidth - 10, b = !0;
                        var g = c._skinParams != null ? c._skinParams : this.skinParams[this.skin];
                        if (c.y + g.header_height > this.vp.offsetHeight) c.y = this.vp.offsetHeight - g.header_height, e = !0;
                        (b || e) && this._engineRedrawWindowPos(c)
                    }
            };
            this.enableAutoViewport =
                function (a) {
                    if (this.vp == document.body && (this.autoViewport = a, a == !1)) document.body.className = this.vp._css, this.vp = document.createElement("DIV"), this.vp.autocreated = !0, this.vp.className = "dhtmlx_winviewport dhtmlx_skin_" + this.skin + (this._r ? " dhx_wins_rtl" : ""), this.vp.style.left = "0px", this.vp.style.top = "0px", document.body.appendChild(this.vp), this.vp.ax = 0, this.vp.ay = 0, this._autoResizeViewport(), this.vp.appendChild(this.modalCoverI), this.vp.appendChild(this.modalCoverD), this.vp.appendChild(this._carcass)
            };
            this.attachViewportTo = function (a) {
                if (this.autoViewport == !1) this.vp != document.body && this.vp.parentNode.removeChild(this.vp), this.vp = typeof a == "string" ? document.getElementById(a) : a, this.vp.autocreated = !1, this._clearVPCss(), this.vp.className += " dhtmlx_skin_" + this.skin + (this._r ? " dhx_wins_rtl" : ""), this.vp.style.position = "relative", this.vp.style.overflow = "hidden", this.vp.ax = 0, this.vp.ay = 0, this.vp.appendChild(this.modalCoverI), this.vp.appendChild(this.modalCoverD), this.vp.appendChild(this._carcass)
            };
            this.setViewport =
                function (a, c, b, e, g) {
                    if (this.autoViewport == !1) this.vp.style.left = a + "px", this.vp.style.top = c + "px", this.vp.style.width = b + "px", this.vp.style.height = e + "px", g != null && g.appendChild(this.vp), this.vp.ax = getAbsoluteLeft(this.vp), this.vp.ay = getAbsoluteTop(this.vp)
            };
            this._effects = {
                move: !1,
                resize: !1
            };
            this.setEffect = function (a, c) {
                this._effects[a] != null && typeof c == "boolean" && (this._effects[a] = c)
            };
            this.getEffect = function (a) {
                return this._effects[a]
            };
            this.createWindow = function (a, b, h, e, g) {
                var d = document.createElement("DIV");
                d.className = "dhtmlx_window_inactive";
                d.dir = "ltr";
                for (var i in this.wins) this.wins[i].zi += this.zIndexStep, this.wins[i].style.zIndex = this.wins[i].zi;
                d.zi = this.zIndexStep;
                d.style.zIndex = d.zi;
                d.active = !1;
                d._isWindow = !0;
                d.isWindow = !0;
                d.w = Number(e);
                d.h = Number(g);
                d.x = b;
                d.y = h;
                this._engineFixWindowPosInViewport(d);
                d._isModal = !1;
                d._allowResize = !0;
                d.maxW = "auto";
                d.maxH = "auto";
                d.minW = 200;
                d.minH = 140;
                d.iconsPresent = !0;
                d.icons = [this.imagePath + this.pathPrefix + this.skin + "/active/icon_normal.gif", this.imagePath + this.pathPrefix +
                    this.skin + "/inactive/icon_normal.gif"
                ];
                d._allowMove = !0;
                d._allowMoveGlobal = !0;
                d._allowResizeGlobal = !0;
                d._keepInViewport = !1;
                var k = this.skinParams[this.skin];
                d.idd = a;
                this.vp.appendChild(d);
                this._engineSetWindowBody(d);
                this._engineRedrawWindowPos(d);
                this._engineRedrawWindowSize(d);
                this._engineUpdateWindowIcon(d, d.icons[0]);
                this._engineDiableOnSelectInWindow(d, !0);
                this.wins[a] = d;
                dhtmlxEventable(d);
                this._engineGetWindowHeader(d)[this._isIPad ? "ontouchstart" : "onmousedown"] = function (a) {
                    var a = a || event,
                        b = c.wins[this.idd];
                    b.isOnTop() || b.bringToTop();
                    if (!c._engineGetWindowHeaderState(b) && c._engineCheckHeaderMouseDown(b, a) && b._allowMove && b._allowMoveGlobal) {
                        this._wasMoved = !1;
                        b.moveOffsetX = b.x - (c._isIPad ? a.touches[0].clientX : a.clientX);
                        b.moveOffsetY = b.y - (c._isIPad ? a.touches[0].clientY : a.clientY);
                        c.movingWin = b;
                        if (c._effects.move == !1) c._carcass.x = c.movingWin.x, c._carcass.y = c.movingWin.y, c._carcass.w = parseInt(c.movingWin.style.width) + (_isIE ? 0 : -2), c._carcass.h = parseInt(c.movingWin.style.height) + (_isIE ? 0 : -2), c._carcass.style.left =
                            c._carcass.x + "px", c._carcass.style.top = c._carcass.y + "px", c._carcass.style.width = c._carcass.w + "px", c._carcass.style.height = c._carcass.h + "px", c._carcass.style.zIndex = c._getTopZIndex(!0) + 1, c._carcass._keepInViewport = d._keepInViewport;
                        c._blockSwitcher(!0);
                        c._vpcover.style.zIndex = c.movingWin.style.zIndex - 1;
                        c._vpcover.style.display = "";
                        a.returnValue = !1;
                        a.cancelBubble = !0;
                        return !1
                    }
                };
                this._engineGetWindowHeader(d).ondblclick = function (a) {
                    var b = c.wins[this.idd];
                    if (c._engineCheckHeaderMouseDown(b, a || event)) b._allowResizeGlobal &&
                        !b._isParked && (b._isMaximized == !0 ? c._restoreWindow(b) : c._maximizeWindow(b))
                };
                d.setText = function (a) {
                    c._engineGetWindowLabel(this).innerHTML = a
                };
                d.getText = function () {
                    return c._engineGetWindowLabel(this).innerHTML
                };
                d.getId = function () {
                    return this.idd
                };
                d.show = function () {
                    c._showWindow(this)
                };
                d.hide = function () {
                    c._hideWindow(this)
                };
                d.minimize = function () {
                    c._restoreWindow(this)
                };
                d.maximize = function () {
                    c._maximizeWindow(this)
                };
                d.close = function () {
                    c._closeWindow(this)
                };
                d.park = function () {
                    this._isParkedAllowed && c._parkWindow(this)
                };
                d.stick = function () {
                    c._stickWindow(this)
                };
                d.unstick = function () {
                    c._unstickWindow(this)
                };
                d.isSticked = function () {
                    return this._isSticked
                };
                d.setIcon = function (a, b) {
                    c._setWindowIcon(d, a, b)
                };
                d.getIcon = function () {
                    return c._getWindowIcon(this)
                };
                d.clearIcon = function () {
                    c._clearWindowIcons(this)
                };
                d.restoreIcon = function () {
                    c._restoreWindowIcons(this)
                };
                d.keepInViewport = function (a) {
                    this._keepInViewport = a
                };
                d.setModal = function (a) {
                    a == !0 ? c.modalWin != null || c.modalWin == this || c._setWindowModal(this, !0) : c.modalWin == this &&
                        c._setWindowModal(this, !1)
                };
                d.isModal = function () {
                    return this._isModal
                };
                d.isHidden = function () {
                    return c._isWindowHidden(this)
                };
                d.isMaximized = function () {
                    return this._isMaximized
                };
                d.isParked = function () {
                    return this._isParked
                };
                d.allowPark = function () {
                    c._allowParking(this)
                };
                d.denyPark = function () {
                    c._denyParking(this)
                };
                d.isParkable = function () {
                    return this._isParkedAllowed
                };
                d.allowResize = function () {
                    c._allowReszieGlob(this)
                };
                d.denyResize = function () {
                    c._denyResize(this)
                };
                d.isResizable = function () {
                    return this._allowResizeGlobal
                };
                d.allowMove = function () {
                    if (!this._isMaximized) this._allowMove = !0;
                    this._allowMoveGlobal = !0
                };
                d.denyMove = function () {
                    this._allowMoveGlobal = !1
                };
                d.isMovable = function () {
                    return this._allowMoveGlobal
                };
                d.bringToTop = function () {
                    c._bringOnTop(this);
                    c._makeActive(this)
                };
                d.bringToBottom = function () {
                    c._bringOnBottom(this)
                };
                d.isOnTop = function () {
                    return c._isWindowOnTop(this)
                };
                d.isOnBottom = function () {
                    return c._isWindowOnBottom(this)
                };
                d.setPosition = function (a, b) {
                    this.x = a;
                    this.y = b;
                    c._engineFixWindowPosInViewport(this);
                    c._engineRedrawWindowPos(this)
                };
                d.getPosition = function () {
                    return [this.x, this.y]
                };
                d.setDimension = function (a, b) {
                    if (a != null) {
                        if (this.maxW != "auto" && a > this.maxW) a = this.maxW;
                        if (a < this.minW) a = this.minW;
                        this.w = a
                    }
                    if (b != null) {
                        if (this.maxH != "auto" && b > this.maxH) b = this.maxH;
                        if (b < this.minH) b = this.minH;
                        this.h = b
                    }
                    c._fixWindowDimensionInViewport(this);
                    c._engineFixWindowPosInViewport(this);
                    c._engineRedrawWindowSize(this);
                    this.updateNestedObjects()
                };
                d.getDimension = function () {
                    return [this.w, this.h]
                };
                d.setMaxDimension = function (a,
                    b) {
                    this.maxW = isNaN(a) ? "auto" : a;
                    this.maxH = isNaN(b) ? "auto" : b;
                    c._engineRedrawWindowSize(this)
                };
                d.getMaxDimension = function () {
                    return [this.maxW, this.maxH]
                };
                d.setMinDimension = function (a, b) {
                    if (a != null) this.minW = a;
                    if (b != null) this.minH = b;
                    c._fixWindowDimensionInViewport(this);
                    c._engineRedrawWindowPos(this)
                };
                d.getMinDimension = function () {
                    return [this.minW, this.minH]
                };
                d._adjustToContent = function (a, b) {
                    c._engineAdjustWindowToContent(this, a, b)
                };
                d._doOnAttachMenu = function () {
                    c._engineRedrawWindowSize(this);
                    this.updateNestedObjects()
                };
                d._doOnAttachToolbar = function () {
                    c._engineRedrawWindowSize(this);
                    this.updateNestedObjects()
                };
                d._doOnAttachStatusBar = function () {
                    c._engineRedrawWindowSize(this);
                    this.updateNestedObjects()
                };
                d._doOnFrameMouseDown = function () {
                    this.bringToTop()
                };
                d._doOnFrameContentLoaded = function () {
                    c.callEvent("onContentLoaded", [this])
                };
                d.addUserButton = function (a, b, f, h) {
                    var d = c._addUserButton(this, a, b, f, h);
                    return d
                };
                d.removeUserButton = function (a) {
                    a == "minmax1" || a == "minmax2" || a == "park" || a == "close" || a == "stick" || a == "unstick" ||
                        a == "help" || btn != null && c._removeUserButton(this, a)
                };
                d.progressOn = function () {
                    c._engineSwitchWindowProgress(this, !0)
                };
                d.progressOff = function () {
                    c._engineSwitchWindowProgress(this, !1)
                };
                d.setToFullScreen = function (a) {
                    c._setWindowToFullScreen(this, a)
                };
                d.showHeader = function () {
                    c._engineSwitchWindowHeader(this, !0)
                };
                d.hideHeader = function () {
                    c._engineSwitchWindowHeader(this, !1)
                };
                d.progressOff();
                d.canStartResize = !1;
                d.onmousemove = function (a) {
                    if (_isIE && this._isMaximized) return !0;
                    var a = a || event,
                        b = a.target || a.srcElement;
                    String(b.className).search("dhtmlx_wins_resizer") < 0 && (b = null);
                    if (!this._allowResize || this._allowResizeGlobal == !1 || !b) {
                        if (b && b.style.cursor != "default") b.style.cursor = "default";
                        if (this.style.cursor != "default") this.style.cursor = "default";
                        this.canStartResize = !1;
                        return !0
                    }
                    if (c.resizingWin == null && c.movingWin == null && !this._isParked) {
                        if (c._isIPad) var f = a.touches[0].clientX,
                            h = a.touches[0].clientY;
                        else f = _isIE || _isOpera ? a.offsetX : a.layerX, h = _isIE || _isOpera ? a.offsetY : a.layerY;
                        var e = c._engineAllowWindowResize(d,
                            b, f, h);
                        if (e == null) {
                            this.canStartResize = !1;
                            if (b.style.cursor != "default") b.style.cursor = "default";
                            if (this.style.cursor != "default") this.style.cursor = "default"
                        } else {
                            c.resizingDirs = e;
                            var j = {
                                x: a.clientX,
                                y: a.clientY
                            };
                            switch (c.resizingDirs) {
                            case "border_left":
                                b.style.cursor = "w-resize";
                                this.resizeOffsetX = this.x - j.x;
                                break;
                            case "border_right":
                                b.style.cursor = "e-resize";
                                this.resizeOffsetXW = this.x + this.w - j.x;
                                break;
                            case "border_top":
                                b.style.cursor = "n-resize";
                                this.resizeOffsetY = this.y - j.y;
                                break;
                            case "border_bottom":
                                b.style.cursor =
                                    "n-resize";
                                this.resizeOffsetYH = this.y + this.h - j.y;
                                break;
                            case "corner_left":
                                b.style.cursor = "sw-resize";
                                this.resizeOffsetX = this.x - a.clientX;
                                this.resizeOffsetYH = this.y + this.h - j.y;
                                break;
                            case "corner_up_left":
                                b.style.cursor = "nw-resize";
                                this.resizeOffsetY = this.y - j.y;
                                this.resizeOffsetX = this.x - j.x;
                                break;
                            case "corner_right":
                                b.style.cursor = "nw-resize";
                                this.resizeOffsetXW = this.x + this.w - j.x;
                                this.resizeOffsetYH = this.y + this.h - j.y;
                                break;
                            case "corner_up_right":
                                b.style.cursor = "sw-resize", this.resizeOffsetY = this.y -
                                    j.y, this.resizeOffsetXW = this.x + this.w - j.x
                            }
                            this.canStartResize = !0;
                            this.style.cursor = b.style.cursor;
                            a.cancelBubble = !0;
                            return a.returnValue = !1
                        }
                    }
                };
                d.onmousedown = function (a) {
                    c._getActive() != this && c._makeActive(this);
                    c._bringOnTop(this);
                    if (this.canStartResize) {
                        c._blockSwitcher(!0);
                        c.resizingWin = this;
                        if (!c._effects.resize) c._carcass.x = c.resizingWin.x, c._carcass.y = c.resizingWin.y, c._carcass.w = Number(c.resizingWin.w) + (_isIE ? 0 : -2), c._carcass.h = Number(c.resizingWin.h) + (_isIE ? 0 : -2), c._carcass.style.left = c._carcass.x +
                            "px", c._carcass.style.top = c._carcass.y + "px", c._carcass.style.width = c._carcass.w + "px", c._carcass.style.height = c._carcass.h + "px", c._carcass.style.zIndex = c._getTopZIndex(!0) + 1, c._carcass.style.cursor = this.style.cursor, c._carcass._keepInViewport = this._keepInViewport, c._carcass.style.display = "";
                        c._vpcover.style.zIndex = c.resizingWin.style.zIndex - 1;
                        c._vpcover.style.display = "";
                        this.vs[this.av].layout && this.callEvent("_onBeforeTryResize", [this]);
                        a = a || event
                    }
                };
                this._addDefaultButtons(d);
                d.button = function (a) {
                    var c =
                        null;
                    this.btns[a] != null && (c = this.btns[a]);
                    return c
                };
                d.center = function () {
                    c._centerWindow(this, !1)
                };
                d.centerOnScreen = function () {
                    c._centerWindow(this, !0)
                };
                d._attachContent("empty", null);
                d._redraw = function () {
                    c._engineRedrawWindowSize(this)
                };
                d.bringToTop();
                this._engineRedrawWindowSize(d);
                return this.wins[a]
            };
            this.zIndexStep = 50;
            this._getTopZIndex = function (a) {
                var c = 0,
                    b;
                for (b in this.wins)
                    if (a == !0) {
                        if (this.wins[b].zi > c) c = this.wins[b].zi
                    } else if (this.wins[b].zi > c && !this.wins[b]._isSticked) c = this.wins[b].zi;
                return c
            };
            this.movingWin = null;
            this._moveWindow = function (a) {
                if (this.movingWin != null) {
                    if (!this.movingWin._allowMove || !this.movingWin._allowMoveGlobal) return;
                    if (this._effects.move == !0) {
                        if (this._engineGetWindowHeader(this.movingWin).style.cursor != "move") this._engineGetWindowHeader(this.movingWin).style.cursor = "move";
                        this._wasMoved = !0;
                        this.movingWin.x = (this._isIPad ? a.touches[0].clientX : a.clientX) + this.movingWin.moveOffsetX;
                        this.movingWin.y = (this._isIPad ? a.touches[0].clientY : a.clientY) + this.movingWin.moveOffsetY;
                        this._engineFixWindowPosInViewport(this.movingWin);
                        this._engineRedrawWindowPos(this.movingWin)
                    } else {
                        if (this._carcass.style.display != "") this._carcass.style.display = "";
                        if (this._carcass.style.cursor != "move") this._carcass.style.cursor = "move";
                        if (this._engineGetWindowHeader(this.movingWin).style.cursor != "move") this._engineGetWindowHeader(this.movingWin).style.cursor = "move";
                        this._carcass.x = (this._isIPad ? a.touches[0].clientX : a.clientX) + this.movingWin.moveOffsetX;
                        this._carcass.y = (this._isIPad ? a.touches[0].clientY :
                            a.clientY) + this.movingWin.moveOffsetY;
                        this._engineFixWindowPosInViewport(this._carcass);
                        this._carcass.style.left = this._carcass.x + "px";
                        this._carcass.style.top = this._carcass.y + "px"
                    }
                }
                if (this.resizingWin != null && this.resizingWin._allowResize) {
                    var c = {
                        x: a.clientX,
                        y: a.clientY
                    };
                    if (this.resizingDirs == "border_left" || this.resizingDirs == "corner_left" || this.resizingDirs == "corner_up_left")
                        if (this._effects.resize) {
                            var b = c.x + this.resizingWin.resizeOffsetX,
                                e = b > this.resizingWin.x ? -1 : 1;
                            newW = this.resizingWin.w + Math.abs(b -
                                this.resizingWin.x) * e;
                            newW < this.resizingWin.minW && e < 0 ? (this.resizingWin.x = this.resizingWin.x + this.resizingWin.w - this.resizingWin.minW, this.resizingWin.w = this.resizingWin.minW) : (this.resizingWin.w = newW, this.resizingWin.x = b);
                            this._engineRedrawWindowPos(this.resizingWin);
                            this._engineRedrawWindowSize(this.resizingWin)
                        } else {
                            b = c.x + this.resizingWin.resizeOffsetX;
                            e = b > this._carcass.x ? -1 : 1;
                            newW = this._carcass.w + Math.abs(b - this._carcass.x) * e;
                            if (newW > this.resizingWin.maxW) newW = this.resizingWin.maxW, b = this._carcass.x +
                                this._carcass.w - this.resizingWin.maxW;
                            newW < this.resizingWin.minW && e < 0 ? (this._carcass.x = this._carcass.x + this._carcass.w - this.resizingWin.minW, this._carcass.w = this.resizingWin.minW) : (this._carcass.w = newW, this._carcass.x = b);
                            this._carcass.style.left = this._carcass.x + "px";
                            this._carcass.style.width = this._carcass.w + "px"
                        }
                    if (this.resizingDirs == "border_right" || this.resizingDirs == "corner_right" || this.resizingDirs == "corner_up_right")
                        if (this._effects.resize) {
                            b = c.x - (this.resizingWin.x + this.resizingWin.w) + this.resizingWin.resizeOffsetXW;
                            newW = this.resizingWin.w + b;
                            if (newW < this.resizingWin.minW) newW = this.resizingWin.minW;
                            this.resizingWin.w = newW;
                            this._engineRedrawWindowPos(this.resizingWin);
                            this._engineRedrawWindowSize(this.resizingWin)
                        } else {
                            b = c.x - (this._carcass.x + this._carcass.w) + this.resizingWin.resizeOffsetXW;
                            newW = this._carcass.w + b;
                            if (newW < this.resizingWin.minW) newW = this.resizingWin.minW;
                            if (this.resizingWin.maxW != "auto" && newW > this.resizingWin.maxW) newW = this.resizingWin.maxW;
                            this._carcass.w = newW;
                            this._carcass.style.width = this._carcass.w +
                                "px"
                        }
                    if (this.resizingDirs == "border_bottom" || this.resizingDirs == "corner_left" || this.resizingDirs == "corner_right")
                        if (this._effects.resize) {
                            b = c.y - (this.resizingWin.y + this.resizingWin.h) + this.resizingWin.resizeOffsetYH;
                            newH = this.resizingWin.h + b;
                            if (newH < this.resizingWin.minH) newH = this.resizingWin.minH;
                            this.resizingWin.h = newH;
                            this._engineRedrawWindowPos(this.resizingWin);
                            this._engineRedrawWindowSize(this.resizingWin)
                        } else {
                            b = c.y - (this._carcass.y + this._carcass.h) + this.resizingWin.resizeOffsetYH;
                            newH = this._carcass.h +
                                b;
                            if (newH < this.resizingWin.minH) newH = this.resizingWin.minH;
                            if (newH > this.resizingWin.maxH) newH = this.resizingWin.maxH;
                            this._carcass.h = newH;
                            this._carcass.style.height = this._carcass.h + "px"
                        }
                    if ((this.resizingDirs == "border_top" || this.resizingDirs == "corner_up_right" || this.resizingDirs == "corner_up_left") && !this._effects.resize) {
                        b = c.y + this.resizingWin.resizeOffsetY;
                        e = b > this.resizingWin.y ? -1 : 1;
                        newH = this.resizingWin.h + Math.abs(b - this.resizingWin.y) * e;
                        if (newH > this.resizingWin.maxH) newH = this.resizingWin.maxH, b =
                            this.resizingWin.y + this.resizingWin.h - this.resizingWin.maxH;
                        newH < this.resizingWin.minH && e < 0 ? (this._carcass.y = this._carcass.y + this._carcass.h - this.resizingWin.minH, this._carcass.h = this.resizingWin.minH) : (this._carcass.h = newH + (_isIE ? 0 : -2), this._carcass.y = b);
                        this._carcass.style.top = this._carcass.y + "px";
                        this._carcass.style.height = this._carcass.h + "px"
                    }
                }
            };
            this._stopMove = function () {
                if (this.movingWin != null) {
                    if (this._effects.move) {
                        var a = this.movingWin;
                        this.movingWin = null;
                        this._blockSwitcher(!1);
                        this._engineGetWindowHeader(a).style.cursor =
                            "";
                        _isFF && (a.h++, c._engineRedrawWindowPos(a), a.h--, c._engineRedrawWindowPos(a))
                    } else this._carcass.style.cursor = "", this._carcass.style.display = "none", a = this.movingWin, this._engineGetWindowHeader(a).style.cursor = "", this.movingWin = null, this._blockSwitcher(!1), a.setPosition(parseInt(this._carcass.style.left), parseInt(this._carcass.style.top));
                    this._vpcover.style.display = "none";
                    this._wasMoved && (a.checkEvent("onMoveFinish") ? a.callEvent("onMoveFinish", [a]) : this.callEvent("onMoveFinish", [a]));
                    this._wasMoved = !1
                }
                if (this.resizingWin != null) a = this.resizingWin, this.resizingWin = null, this._blockSwitcher(!1), this._effects.resize ? a.updateNestedObjects() : (this._carcass.style.display = "none", a.setDimension(this._carcass.w + (_isIE ? 0 : 2), this._carcass.h + (_isIE ? 0 : 2)), a.setPosition(this._carcass.x, this._carcass.y)), a.vs[a.av].layout && a.vs[a.av].layout.callEvent("onResize", []), this._vpcover.style.display = "none", a.checkEvent("onResizeFinish") ? a.callEvent("onResizeFinish", [a]) : this.callEvent("onResizeFinish", [a])
            };
            this._fixWindowDimensionInViewport =
                function (a) {
                    if (a.w < a.minW) a.w = a.minW;
                    if (!a._isParked && a.h < a.minH) a.h = a.minH
            };
            this._bringOnTop = function (a) {
                var c = a.zi,
                    b = this._getTopZIndex(a._isSticked),
                    e;
                for (e in this.wins)
                    if (this.wins[e] != a && (a._isSticked || !a._isSticked && !this.wins[e]._isSticked) && this.wins[e].zi > c) this.wins[e].zi -= this.zIndexStep, this.wins[e].style.zIndex = this.wins[e].zi;
                a.zi = b;
                a.style.zIndex = a.zi
            };
            this._makeActive = function (a, c) {
                for (var b in this.wins)
                    if (this.wins[b] == a) {
                        var e = !1;
                        this.wins[b].className != "dhtmlx_window_active" &&
                            !c && (e = !0);
                        this.wins[b].className = "dhtmlx_window_active";
                        this._engineUpdateWindowIcon(this.wins[b], this.wins[b].icons[0]);
                        e == !0 && (a.checkEvent("onFocus") ? a.callEvent("onFocus", [a]) : this.callEvent("onFocus", [a]))
                    } else this.wins[b].className = "dhtmlx_window_inactive", this._engineUpdateWindowIcon(this.wins[b], this.wins[b].icons[1])
            };
            this._getActive = function () {
                var a = null,
                    b;
                for (b in this.wins) this.wins[b].className == "dhtmlx_window_active" && (a = this.wins[b]);
                return a
            };
            this._centerWindow = function (a, b) {
                if (a._isMaximized !=
                    !0) {
                    if (b == !0) var c = _isIE ? document.body.offsetWidth : window.innerWidth,
                        e = _isIE ? document.body.offsetHeight : window.innerHeight;
                    else c = this.vp == document.body ? document.body.offsetWidth : Number(parseInt(this.vp.style.width)) && String(this.vp.style.width).search("%") == -1 ? parseInt(this.vp.style.width) : this.vp.offsetWidth, e = this.vp == document.body ? document.body.offsetHeight : Number(parseInt(this.vp.style.height)) && String(this.vp.style.height).search("%") == -1 ? parseInt(this.vp.style.height) : this.vp.offsetHeight;
                    var g = Math.round(c / 2 - a.w / 2),
                        d = Math.round(e / 2 - a.h / 2);
                    a.x = g;
                    a.y = d;
                    this._engineFixWindowPosInViewport(a);
                    this._engineRedrawWindowPos(a)
                }
            };
            this._addDefaultButtons = function (a) {
                var b = this._engineGetWindowButton(a, "stick");
                b.title = this.i18n.stick;
                b.isVisible = !1;
                b.style.display = "none";
                b._isEnabled = !0;
                b.isPressed = !1;
                b.label = "stick";
                b._doOnClick = function () {
                    this.isPressed = !0;
                    c._stickWindow(a)
                };
                var h = this._engineGetWindowButton(a, "sticked");
                h.title = this.i18n.unstick;
                h.isVisible = !1;
                h.style.display = "none";
                h._isEnabled = !0;
                h.isPressed = !1;
                h.label = "sticked";
                h._doOnClick = function () {
                    this.isPressed = !1;
                    c._unstickWindow(a)
                };
                var e = this._engineGetWindowButton(a, "help");
                e.title = this.i18n.help;
                e.isVisible = !1;
                e.style.display = "none";
                e._isEnabled = !0;
                e.isPressed = !1;
                e.label = "help";
                e._doOnClick = function () {
                    c._needHelp(a)
                };
                var g = this._engineGetWindowButton(a, "park");
                g.titleIfParked = this.i18n.parkdown;
                g.titleIfNotParked = this.i18n.parkup;
                g.title = g.titleIfNotParked;
                g.isVisible = !0;
                g._isEnabled = !0;
                g.isPressed = !1;
                g.label = "park";
                g._doOnClick =
                    function () {
                        c._parkWindow(a)
                };
                var d = this._engineGetWindowButton(a, "minmax1");
                d.title = this.i18n.maximize;
                d.isVisible = !0;
                d._isEnabled = !0;
                d.isPressed = !1;
                d.label = "minmax1";
                d._doOnClick = function () {
                    c._maximizeWindow(a)
                };
                var i = this._engineGetWindowButton(a, "minmax2");
                i.title = this.i18n.restore;
                i.isVisible = !1;
                i.style.display = "none";
                i._isEnabled = !0;
                i.isPressed = !1;
                i.label = "minmax2";
                i._doOnClick = function () {
                    c._restoreWindow(a)
                };
                var k = this._engineGetWindowButton(a, "close");
                k.title = this.i18n.close;
                k.isVisible = !0;
                k._isEnabled = !0;
                k.isPressed = !1;
                k.label = "close";
                k._doOnClick = function () {
                    c._closeWindow(a)
                };
                var l = this._engineGetWindowButton(a, "dock");
                l.title = this.i18n.dock;
                l.style.display = "none";
                l.isVisible = !1;
                l._isEnabled = !0;
                l.isPressed = !1;
                l.label = "dock";
                l._doOnClick = function () {};
                a._isSticked = !1;
                a._isParked = !1;
                a._isParkedAllowed = !0;
                a._isMaximized = !1;
                a._isDocked = !1;
                a.btns = {};
                a.btns.stick = b;
                a.btns.sticked = h;
                a.btns.help = e;
                a.btns.park = g;
                a.btns.minmax1 = d;
                a.btns.minmax2 = i;
                a.btns.close = k;
                a.btns.dock = l;
                for (var m in a.btns) this._attachEventsOnButton(a,
                    a.btns[m])
            };
            this._attachEventsOnButton = function (a, b) {
                this._isIPad ? (b.ontouchstart = function (a) {
                    a.cancelBubble = !0;
                    return a.returnValue = !1
                }, b.ontouchend = function (b) {
                    b.cancelBubble = !0;
                    b.returnValue = !1;
                    if (!this._isEnabled) return !1;
                    this.checkEvent("onClick") ? this.callEvent("onClick", [a, this]) : this._doOnClick();
                    return !1
                }) : (b.onmouseover = function () {
                    this.className = this._isEnabled ? "dhtmlx_wins_btns_button dhtmlx_button_" + this.label + "_over_" + (this.isPressed ? "pressed" : "default") : "dhtmlx_wins_btns_button dhtmlx_button_" +
                        this.label + "_disabled"
                }, b.onmouseout = function () {
                    this._isEnabled ? (this.isPressed = !1, this.className = "dhtmlx_wins_btns_button dhtmlx_button_" + this.label + "_default") : this.className = "dhtmlx_wins_btns_button dhtmlx_button_" + this.label + "_disabled"
                }, b.onmousedown = function () {
                    this._isEnabled ? (this.isPressed = !0, this.className = "dhtmlx_wins_btns_button dhtmlx_button_" + this.label + "_over_pressed") : this.className = "dhtmlx_wins_btns_button dhtmlx_button_" + this.label + "_disabled"
                }, b.onmouseup = function () {
                    if (this._isEnabled) {
                        var b =
                            this.isPressed;
                        this.isPressed = !1;
                        this.className = "dhtmlx_wins_btns_button dhtmlx_button_" + this.label + "_over_default";
                        b && (this.checkEvent("onClick") ? this.callEvent("onClick", [a, this]) : this._doOnClick())
                    } else this.className = "dhtmlx_wins_btns_button dhtmlx_button_" + this.label + "_disabled"
                });
                b.show = function () {
                    c._showButton(a, this.label)
                };
                b.hide = function () {
                    c._hideButton(a, this.label)
                };
                b.enable = function () {
                    c._enableButton(a, this.label)
                };
                b.disable = function () {
                    c._disableButton(a, this.label)
                };
                b.isEnabled = function () {
                    return this._isEnabled
                };
                b.isHidden = function () {
                    return !this.isVisible
                };
                dhtmlxEventable(b)
            };
            this._parkWindow = function (a, b) {
                if (a._isParkedAllowed || b)
                    if (!this.enableParkEffect || !a.parkBusy)
                        if (a._isParked) this.enableParkEffect && !b ? (a.parkBusy = !0, this._doParkDown(a)) : (a.h = a.lastParkH, this._engineRedrawWindowSize(a), this._engineDoOnWindowParkDown(a), a.updateNestedObjects(), a.btns.park.title = a.btns.park.titleIfNotParked, a._allowResizeGlobal == !0 && (this._enableButton(a, "minmax1"), this._enableButton(a, "minmax2")), a._isParked = !1, b ||
                            (a.checkEvent("onParkDown") ? a.callEvent("onParkDown", [a]) : this.callEvent("onParkDown", [a])));
                        else if (this.enableParkEffect && !b)
                    if (a.lastParkH = String(a.h).search(/\%$/) == -1 ? a.h : a.offsetHeight, a._allowResizeGlobal == !0 && (this._disableButton(a, "minmax1"), this._disableButton(a, "minmax2")), this.enableParkEffect) a.parkBusy = !0, this._doParkUp(a);
                    else {
                        var c = a._skinParams != null ? a._skinParams : this.skinParams[this.skin];
                        a.h = c.header_height + c.border_bottom_height;
                        a.btns.park.title = a.btns.park.titleIfParked
                    } else a.lastParkH =
                    String(a.h).search(/\%$/) == -1 ? a.h : a.offsetHeight, a.h = this._engineGetWindowParkedHeight(a), this._engineRedrawWindowSize(a), this._engineDoOnWindowParkUp(a), a.btns.park.title = a.btns.park.titleIfParked, a._isParked = !0, b || (a.checkEvent("onParkUp") ? a.callEvent("onParkUp", [a]) : this.callEvent("onParkUp", [a]))
            };
            this._allowParking = function (a) {
                a._isParkedAllowed = !0;
                this._enableButton(a, "park")
            };
            this._denyParking = function (a) {
                a._isParkedAllowed = !1;
                this._disableButton(a, "park")
            };
            this.enableParkEffect = !1;
            this.parkSpeed =
                this.parkStartSpeed = 80;
            this.parkTM = null;
            this.parkTMTime = 5;
            this._doParkUp = function (a) {
                if (String(a.h).search(/\%$/) != -1) a.h = a.offsetHeight;
                a.h -= this.parkSpeed;
                var b = this._engineGetWindowParkedHeight(a);
                a.h <= b ? (a.h = b, this._engineGetWindowButton(a, "park").title = this._engineGetWindowButton(a, "park").titleIfParked, a._isParked = !0, a.parkBusy = !1, this._engineRedrawWindowSize(a), this._engineDoOnWindowParkUp(a), a.checkEvent("onParkUp") ? a.callEvent("onParkUp", [a]) : this.callEvent("onParkUp", [a])) : (this._engineRedrawWindowSize(a),
                    this.parkTM = window.setTimeout(function () {
                        c._doParkUp(a)
                    }, this.parkTMTime))
            };
            this._doParkDown = function (a) {
                a.h += this.parkSpeed;
                a.h >= a.lastParkH ? (a.h = a.lastParkH, this._engineGetWindowButton(a, "park").title = this._engineGetWindowButton(a, "park").titleIfNotParked, a._allowResizeGlobal == !0 && (this._enableButton(a, "minmax1"), this._enableButton(a, "minmax2")), a._isParked = !1, a.parkBusy = !1, this._engineRedrawWindowSize(a), a.updateNestedObjects(), this._engineDoOnWindowParkDown(a), a.checkEvent("onParkDown") ? a.callEvent("onParkDown", [a]) : this.callEvent("onParkDown", [a])) : (this._engineRedrawWindowSize(a), this.parkTM = window.setTimeout(function () {
                    c._doParkDown(a)
                }, this.parkTMTime))
            };
            this._enableButton = function (a, b) {
                var c = this._engineGetWindowButton(a, b);
                if (c) c._isEnabled = !0, c.className = "dhtmlx_wins_btns_button dhtmlx_button_" + c.label + "_default"
            };
            this._disableButton = function (a, b) {
                var c = this._engineGetWindowButton(a, b);
                if (c) c._isEnabled = !1, c.className = "dhtmlx_wins_btns_button dhtmlx_button_" + a.btns[b].label + "_disabled"
            };
            this._allowReszieGlob =
                function (a) {
                    a._allowResizeGlobal = !0;
                    this._enableButton(a, "minmax1");
                    this._enableButton(a, "minmax2")
            };
            this._denyResize = function (a) {
                a._allowResizeGlobal = !1;
                this._disableButton(a, "minmax1");
                this._disableButton(a, "minmax2")
            };
            this._maximizeWindow = function (a) {
                if (a._allowResizeGlobal != !1) {
                    var b = a._isParked;
                    b && this._parkWindow(a, !0);
                    a.lastMaximizeX = a.x;
                    a.lastMaximizeY = a.y;
                    a.lastMaximizeW = a.w;
                    a.lastMaximizeH = a.h;
                    a.maxW != "auto" && a.maxW != "auto" ? (a.x = Math.round(a.x + (a.w - a.maxW) / 2), a.y = Math.round(a.y + (a.h - a.maxH) /
                        2), a._allowMove = !0) : (a.x = 0, a.y = 0, a._allowMove = !1);
                    a._isMaximized = !0;
                    a._allowResize = !1;
                    a.w = a.maxW == "auto" ? this.vp == document.body ? "100%" : this.vp.style.width != "" && String(this.vp.style.width).search("%") == -1 ? parseInt(this.vp.style.width) : this.vp.offsetWidth : a.maxW;
                    a.h = a.maxH == "auto" ? this.vp == document.body ? "100%" : this.vp.style.height != "" && String(this.vp.style.width).search("%") == -1 ? parseInt(this.vp.style.height) : this.vp.offsetHeight : a.maxH;
                    this._hideButton(a, "minmax1");
                    this._showButton(a, "minmax2");
                    this._engineRedrawWindowPos(a);
                    b ? this._parkWindow(a, !0) : (this._engineRedrawWindowSize(a), a.updateNestedObjects());
                    a.checkEvent("onMaximize") ? a.callEvent("onMaximize", [a]) : this.callEvent("onMaximize", [a])
                }
            };
            this._restoreWindow = function (a) {
                if (a._allowResizeGlobal != !1) {
                    a.layout && a.layout._defineWindowMinDimension(a);
                    var b = a._isParked;
                    b && this._parkWindow(a, !0);
                    a.maxW != "auto" && a.maxW != "auto" ? (a.x = Math.round(a.x + (a.w - a.lastMaximizeW) / 2), a.y = Math.round(a.y + (a.h - a.lastMaximizeH) / 2)) : (a.x = a.lastMaximizeX, a.y = a.lastMaximizeY);
                    a.w = a.lastMaximizeW;
                    a.h = a.lastMaximizeH;
                    a._isMaximized = !1;
                    a._allowMove = a._allowMoveGlobal;
                    a._allowResize = !0;
                    this._fixWindowDimensionInViewport(a);
                    this._hideButton(a, "minmax2");
                    this._showButton(a, "minmax1");
                    this._engineRedrawWindowPos(a);
                    b ? this._parkWindow(a, !0) : (this._engineRedrawWindowSize(a), a.updateNestedObjects());
                    a.checkEvent("onMinimize") ? a.callEvent("onMinimize", [a]) : this.callEvent("onMinimize", [a])
                }
            };
            this._showButton = function (a, b) {
                var c = this._engineGetWindowButton(a, b);
                if (c) c.isVisible = !0, c.style.display = "",
                    c.style.visibility = "visible", this._engineRedrawWindowTitle(a)
            };
            this._hideButton = function (a, b) {
                var c = this._engineGetWindowButton(a, b);
                if (c) c.isVisible = !1, c.style.display = "none", c.style.visibility = "hidden", this._engineRedrawWindowTitle(a)
            };
            this._showWindow = function (a) {
                a.style.display = "";
                a.checkEvent("onShow") ? a.callEvent("onShow", [a]) : this.callEvent("onShow", [a]);
                var b = this._getActive();
                b == null ? (this._bringOnTop(a), this._makeActive(a)) : this._isWindowHidden(b) && (this._bringOnTop(a), this._makeActive(a))
            };
            this._hideWindow = function (a) {
                a.style.display = "none";
                a.checkEvent("onHide") ? a.callEvent("onHide", [a]) : this.callEvent("onHide", [a]);
                var b = this.getTopmostWindow(!0);
                b != null && (this._bringOnTop(b), this._makeActive(b))
            };
            this._isWindowHidden = function (a) {
                var b = a.style.display == "none";
                return b
            };
            this._closeWindow = function (a) {
                if (this._focusFixIE) this._focusFixIE.style.top = (this.vp == document.body ? 0 : getAbsoluteTop(this.vp)) + a.y + "px", this._focusFixIE.focus();
                if (a.checkEvent("onClose")) {
                    if (!a.callEvent("onClose", [a])) return
                } else if (!this.callEvent("onClose", [a])) return;
                this._removeWindowGlobal(a);
                var b = {
                        zi: 0
                    },
                    c;
                for (c in this.wins) this.wins[c].zi > b.zi && (b = this.wins[c]);
                b != null && this._makeActive(b)
            };
            this._needHelp = function (a) {
                a.checkEvent("onHelp") ? a.callEvent("onHelp", [a]) : this.callEvent("onHelp", [a])
            };
            this._setWindowIcon = function (a, b, c) {
                a.iconsPresent = !0;
                a.icons[0] = this.imagePath + b;
                a.icons[1] = this.imagePath + c;
                this._engineUpdateWindowIcon(a, a.icons[a.isOnTop() ? 0 : 1])
            };
            this._getWindowIcon = function (a) {
                return a.iconsPresent ? [a.icons[0], a.icons[1]] : [null, null]
            };
            this._clearWindowIcons = function (a) {
                a.iconsPresent = !1;
                a.icons[0] = this.imagePath + this.pathPrefix + this.skin + "/active/icon_blank.gif";
                a.icons[1] = this.imagePath + this.pathPrefix + this.skin + "/inactive/icon_blank.gif";
                this._engineUpdateWindowIcon(a, a.icons[a.isOnTop() ? 0 : 1])
            };
            this._restoreWindowIcons = function (a) {
                a.iconsPresent = !0;
                a.icons[0] = this.imagePath + this.pathPrefix + this.skin + "/active/icon_normal.gif";
                a.icons[1] = this.imagePath + this.pathPrefix + this.skin + "/inactive/icon_normal.gif";
                this._engineUpdateWindowIcon(a, a.icons[a.className == "dhtmlx_window_active" ? 0 : 1])
            };
            this._attachWindowContentTo = function (a, b, c, e) {
                var g = this._engineGetWindowContent(a).parentNode;
                g.parentNode.removeChild(g);
                a.hide();
                g.style.left = "0px";
                g.style.top = "0px";
                g.style.width = (c != null ? c : b.offsetWidth) + "px";
                g.style.height = (e != null ? e : b.offsetHeight) + "px";
                g.style.position = "relative";
                b.appendChild(g);
                this._engineGetWindowContent(a).style.width = g.style.width;
                this._engineGetWindowContent(a).style.height = g.style.height
            };
            this._setWindowToFullScreen = function (a, b) {
                if (b == !0) {
                    var c = a._content;
                    c.parentNode.removeChild(c);
                    a.hide();
                    a._isFullScreened = !0;
                    c.style.left = "0px";
                    c.style.top = "0px";
                    c.style.width = document.body.offsetWidth - (_isIE ? 4 : 0) + "px";
                    c.style.height = document.body.offsetHeight == 0 ? window.innerHeight ? window.innerHeight + "px" : document.body.scrollHeight + "px" : document.body.offsetHeight - (_isIE ? 4 : 0) + "px";
                    c.style.position = "absolute";
                    document.body.appendChild(c)
                } else if (b == !1) {
                    var c = a.childNodes[0].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0].childNodes[0].childNodes[1],
                        e = a._content;
                    document.body.removeChild(e);
                    c.appendChild(e);
                    a._isFullScreened = !1;
                    a.setDimension(a.w, a.h);
                    a.show();
                    a.bringToTop();
                    a.center()
                }
                a.updateNestedObjects()
            };
            this._isWindowOnTop = function (a) {
                var b = this.getTopmostWindow() == a;
                return b
            };
            this._bringOnBottom = function (a) {
                for (var b in this.wins)
                    if (this.wins[b].zi < a.zi) this.wins[b].zi += this.zIndexStep, this.wins[b].style.zIndex = this.wins[b].zi;
                a.zi = 50;
                a.style.zIndex = a.zi;
                this._makeActive(this.getTopmostWindow())
            };
            this._isWindowOnBottom = function (a) {
                var b = !0,
                    c;
                for (c in this.wins) this.wins[c] != a && (b = b && this.wins[c].zi > a.zi);
                return b
            };
            this._stickWindow = function (a) {
                a._isSticked = !0;
                this._hideButton(a, "stick");
                this._showButton(a, "sticked");
                this._bringOnTop(a)
            };
            this._unstickWindow = function (a) {
                a._isSticked = !1;
                this._hideButton(a, "sticked");
                this._showButton(a, "stick");
                this._bringOnTopAnyStickedWindows()
            };
            this._addUserButton = function (a, b, c, e) {
                var g = this._engineAddUserButton(a, b, c);
                g.title = e;
                g.isVisible = !0;
                g._isEnabled = !0;
                g.isPressed = !1;
                g.label = b;
                a.btns[b] = g;
                g._doOnClick = function () {};
                this._attachEventsOnButton(a, g)
            };
            this._removeUserButton = function (a, b) {
                this._removeButtonGlobal(a, b)
            };
            this._blockSwitcher = function (a) {
                for (var b in this.wins) a == !0 ? this.wins[b].showCoverBlocker() : this.wins[b].hideCoverBlocker()
            };
            this.modalWin = this.resizingWin = null;
            this.resizingDirs = "none";
            if (_isIE) this._focusFixIE = document.createElement("INPUT"), this._focusFixIE.className = "dhx_windows_ieonclosefocusfix", this._focusFixIE.style.position = "absolute", this._focusFixIE.style.width =
                "1px", this._focusFixIE.style.height = "1px", this._focusFixIE.style.border = "none", this._focusFixIE.style.background = "none", this._focusFixIE.style.left = "-10px", this._focusFixIE.style.fontSize = "1px", document.body.appendChild(this._focusFixIE);
            this._createViewport();
            this._doOnMouseUp = function () {
                c != null && c._stopMove()
            };
            this._doOnMoseMove = function (a) {
                a = a || event;
                c != null && c._moveWindow(a)
            };
            this._resizeTM = null;
            this._resizeTMTime = 200;
            this._lw = null;
            this._doOnResize = function () {
                if (c._lw != document.documentElement.clientHeight) window.clearTimeout(c._resizeTM),
                    c._resizeTM = window.setTimeout(function () {
                        c._autoResizeViewport()
                    }, c._resizeTMTime);
                c._lw = document.documentElement.clientHeight
            };
            this._doOnUnload = function () {
                c.unload()
            };
            this._doOnSelectStart = function (a) {
                a = a || event;
                if (c.movingWin != null || c.resizingWin != null) a.returnValue = !1
            };
            _isIE && document.body.attachEvent("onselectstart", this._doOnSelectStart);
            dhtmlxEvent(window, "resize", this._doOnResize);
            dhtmlxEvent(document.body, "unload", this._doOnUnload);
            this._isIPad ? (document.addEventListener("touchmove", this._doOnMoseMove, !1), document.addEventListener("touchend", this._doOnMouseUp, !1)) : (dhtmlxEvent(document.body, "mouseup", this._doOnMouseUp), dhtmlxEvent(this.vp, "mousemove", this._doOnMoseMove), dhtmlxEvent(this.vp, "mouseup", this._doOnMouseUp));
            this._setWindowModal = function (a, b) {
                b == !0 ? (this._makeActive(a), this._bringOnTop(a), this.modalWin = a, a._isModal = !0, this.modalCoverI.style.zIndex = a.zi - 2, this.modalCoverI.style.display = "", this.modalCoverD.style.zIndex = a.zi - 2, this.modalCoverD.style.display = "") : (this.modalWin = null, a._isModal = !1, this.modalCoverI.style.zIndex = 0, this.modalCoverI.style.display = "none", this.modalCoverD.style.zIndex = 0, this.modalCoverD.style.display = "none")
            };
            this._bringOnTopAnyStickedWindows = function () {
                var a = [],
                    b;
                for (b in this.wins) this.wins[b]._isSticked && (a[a.length] = this.wins[b]);
                for (var c = 0; c < a.length; c++) this._bringOnTop(a[c]);
                if (a.length == 0)
                    for (b in this.wins) this.wins[b].className == "dhtmlx_window_active" && this._bringOnTop(this.wins[b])
            };
            this.unload = function () {
                this._clearAll()
            };
            this._removeButtonGlobal =
                function (a, b) {
                    if (a.btns[b]) {
                        var c = a.btns[b];
                        c.title = null;
                        c.isVisible = null;
                        c._isEnabled = null;
                        c.isPressed = null;
                        c.label = null;
                        c._doOnClick = null;
                        c.attachEvent = null;
                        c.callEvent = null;
                        c.checkEvent = null;
                        c.detachEvent = null;
                        c.disable = null;
                        c.enable = null;
                        c.eventCatcher = null;
                        c.hide = null;
                        c.isEnabled = null;
                        c.isHidden = null;
                        c.show = null;
                        c.onmousedown = null;
                        c.onmouseout = null;
                        c.onmouseover = null;
                        c.onmouseup = null;
                        c.parentNode && c.parentNode.removeChild(c);
                        c = null;
                        a.btns[b] = null
                    }
            };
            this._removeWindowGlobal = function (a) {
                this.modalWin ==
                    a && this._setWindowModal(a, !1);
                var b = a.idd;
                a.coverBlocker().onselectstart = null;
                a._dhxContDestruct();
                this._engineDiableOnSelectInWindow(a, !1);
                this._engineGetWindowHeader(a).onmousedown = null;
                this.resizingWin = this.movingWin = this._engineGetWindowHeader(a).ondblclick = null;
                for (var c in a.btns) this._removeButtonGlobal(a, c);
                a.btns = null;
                a._adjustToContent = null;
                a._doOnAttachMenu = null;
                a._doOnAttachStatusBar = null;
                a._doOnAttachToolbar = null;
                a._redraw = null;
                a.addUserButton = null;
                a.allowMove = null;
                a.allowPark = null;
                a.allowResize =
                    null;
                a.attachEvent = null;
                a.bringToBottom = null;
                a.bringToTop = null;
                a.callEvent = null;
                a.center = null;
                a.centerOnScreen = null;
                a.checkEvent = null;
                a.clearIcon = null;
                a.close = null;
                a.denyMove = null;
                a.denyPark = null;
                a.denyResize = null;
                a.detachEvent = null;
                a.eventCatcher = null;
                a.getDimension = null;
                a.getIcon = null;
                a.getId = null;
                a.getMaxDimension = null;
                a.getMinDimension = null;
                a.getPosition = null;
                a.getText = null;
                a.hide = null;
                a.hideHeader = null;
                a.isHidden = null;
                a.isMaximized = null;
                a.isModal = null;
                a.isMovable = null;
                a.isOnBottom = null;
                a.isOnTop =
                    null;
                a.isParkable = null;
                a.isParked = null;
                a.isResizable = null;
                a.isSticked = null;
                a.keepInViewport = null;
                a.maximize = null;
                a.minimize = null;
                a.park = null;
                a.progressOff = null;
                a.progressOn = null;
                a.removeUserButton = null;
                a.restoreIcon = null;
                a.setDimension = null;
                a.setIcon = null;
                a.setMaxDimension = null;
                a.setMinDimension = null;
                a.setModal = null;
                a.setPosition = null;
                a.setText = null;
                a.setToFullScreen = null;
                a.show = null;
                a.showHeader = null;
                a.stick = null;
                a.unstick = null;
                a.onmousemove = null;
                a.onmousedown = null;
                a.icons = null;
                a.button = null;
                a._dhxContDestruct =
                    null;
                a.dhxContGlobal.obj = null;
                a.dhxContGlobal.setContent = null;
                a.dhxContGlobal.dhxcont = null;
                a.dhxContGlobal = null;
                if (a._frame) {
                    for (; a._frame.childNodes.length > 0;) a._frame.removeChild(a._frame.childNodes[0]);
                    a._frame = null
                }
                this._parseNestedForEvents(a);
                a._content = null;
                a.innerHTML = "";
                a.parentNode.removeChild(a);
                a = null;
                this.wins[b] = null;
                delete this.wins[b];
                b = null
            };
            this._removeEvents = function (a) {
                a.onmouseover = null;
                a.onmouseout = null;
                a.onmousemove = null;
                a.onclick = null;
                a.ondblclick = null;
                a.onmouseenter = null;
                a.onmouseleave = null;
                a.onmouseup = null;
                a.onmousewheel = null;
                a.onmousedown = null;
                a.onselectstart = null;
                a.onfocus = null;
                a.style.display = ""
            };
            this._parseNestedForEvents = function (a) {
                this._removeEvents(a);
                for (var b = 0; b < a.childNodes.length; b++) a.childNodes[b].tagName != null && this._parseNestedForEvents(a.childNodes[b])
            };
            this._clearAll = function () {
                this._clearDocumentEvents();
                for (var a in this.wins) this._removeWindowGlobal(this.wins[a]);
                this.wins = null;
                for (this._parseNestedForEvents(this._carcass); this._carcass.childNodes.length >
                    0;) this._carcass.removeChild(this._carcass.childNodes[0]);
                this._carcass.onselectstart = null;
                this._carcass.parentNode.removeChild(this._carcass);
                this._carcass = null;
                this._parseNestedForEvents(this._vpcover);
                this._vpcover.parentNode.removeChild(this._vpcover);
                this._vpcover = null;
                this._parseNestedForEvents(this.modalCoverD);
                this.modalCoverD.parentNode.removeChild(this.modalCoverD);
                this.modalCoverD = null;
                this._parseNestedForEvents(this.modalCoverI);
                this.modalCoverI.parentNode.removeChild(this.modalCoverI);
                this.modalCoverI = null;
                this.vp.autocreated == !0 && this.vp.parentNode.removeChild(this.vp);
                this.vp = null;
                for (a in this.skinParams) delete this.skinParams[a];
                c = this.window = this.unload = this.setViewport = this.setSkin = this.setImagePath = this.setEffect = this.isWindow = this.getTopmostWindow = this.getEffect = this.getBottommostWindow = this.forEachWindow = this.findByText = this.eventCatcher = this.enableAutoViewport = this.detachEvent = this.createWindow = this.checkEvent = this.callEvent = this.attachViewportTo = this.attachEvent = this._unstickWindow =
                    this._stopMove = this._stickWindow = this._showWindow = this._showButton = this._setWindowToFullScreen = this._setWindowModal = this._setWindowIcon = this._restoreWindowIcons = this._restoreWindow = this._removeWindowGlobal = this._removeUserButton = this._removeEvents = this._removeButtonGlobal = this._parseNestedForEvents = this._parkWindow = this._needHelp = this._moveWindow = this._maximizeWindow = this._makeActive = this._isWindowOnTop = this._isWindowOnBottom = this._isWindowHidden = this._hideWindow = this._hideButton = this._getWindowIcon =
                    this._getTopZIndex = this._getActive = this._genStr = this._fixWindowDimensionInViewport = this._engineUpdateWindowIcon = this._engineSwitchWindowProgress = this._engineSwitchWindowHeader = this._engineSetWindowBody = this._engineRedrawWindowTitle = this._engineRedrawWindowSize = this._engineRedrawWindowPos = this._engineRedrawSkin = this._engineGetWindowParkedHeight = this._engineGetWindowLabel = this._engineGetWindowHeaderState = this._engineGetWindowHeader = this._engineGetWindowContent = this._engineGetWindowButton = this._engineFixWindowPosInViewport =
                    this._engineDoOnWindowParkUp = this._engineDoOnWindowParkDown = this._engineDiableOnSelectInWindow = this._engineCheckHeaderMouseDown = this._engineAllowWindowResize = this._engineAdjustWindowToContent = this._engineAddUserButton = this._enableButton = this._doParkUp = this._doParkDown = this._doOnUnload = this._doOnSelectStart = this._doOnResize = this._doOnMouseUp = this._doOnMoseMove = this._disableButton = this._dhx_Engine = this._denyResize = this._denyParking = this._createViewport = this._closeWindow = this._clearWindowIcons = this._clearDocumentEvents =
                    this._clearAll = this._centerWindow = this._bringOnTopAnyStickedWindows = this._bringOnTop = this._bringOnBottom = this._blockSwitcher = this._autoResizeViewport = this._attachWindowContentTo = this._attachEventsOnButton = this._allowReszieGlob = this._allowParking = this._addUserButton = this._addDefaultButtons = wins = this._engineSkinParams = this._effects = this.skinParams = null
            };
            this._clearDocumentEvents = function () {
                _isIE ? (window.detachEvent("onresize", this._doOnResize), document.body.detachEvent("onselectstart", this._doOnSelectStart),
                    document.body.detachEvent("onmouseup", this._doOnMouseUp), document.body.detachEvent("onunload", this._doOnUnload), this.vp.detachEvent("onmousemove", this._doOnMoseMove), this.vp.detachEvent("onmouseup", this._doOnMouseUp)) : (window.removeEventListener("resize", this._doOnResize, !1), document.body.removeEventListener("mouseup", this._doOnMouseUp, !1), document.body.removeEventListener("unload", this._doOnUnload, !1), this.vp.removeEventListener("mousemove", this._doOnMoseMove, !1), this.vp.removeEventListener("mouseup",
                    this._doOnMouseUp, !1))
            };
            this._genStr = function (a) {
                for (var b = "", c = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", e = 0; e < a; e++) b += c.charAt(Math.round(Math.random() * (c.length - 1)));
                return b
            };
            dhtmlxEventable(this);
            return this
        } else alert(this.i18n.noenginealert)
    } else alert(this.i18n.dhx)
}
dhtmlXWindows.prototype._dhx_Engine = function () {
    this._engineEnabled = !0;
    this._engineName = "dhx";
    this._engineSkinParams = {
        dhx_blue: {
            hh: 21,
            lbw: 2,
            rbw: 2,
            lch: 2,
            lcw: 14,
            rch: 14,
            rcw: 14,
            bbh: 2,
            mnh: 23,
            tbh: 25,
            sbh: 20,
            noh_t: null,
            noh_h: null
        },
        dhx_black: {
            hh: 21,
            lbw: 2,
            rbw: 2,
            lch: 2,
            lcw: 14,
            rch: 14,
            rcw: 14,
            bbh: 2,
            mnh: 23,
            tbh: 25,
            sbh: 20,
            noh_t: null,
            noh_h: null
        },
        dhx_skyblue: {
            hh: 29,
            lbw: 2,
            rbw: 2,
            lch: 2,
            lcw: 14,
            rch: 14,
            rcw: 14,
            bbh: 2,
            mnh: 23,
            tbh: 25,
            sbh: 20,
            noh_t: 5,
            noh_h: -10
        },
        dhx_web: {
            hh: 27,
            lbw: 5,
            rbw: 5,
            lch: 5,
            lcw: 14,
            rch: 14,
            rcw: 14,
            bbh: 5,
            mnh: 23,
            tbh: 25,
            sbh: 20,
            noh_t: 5,
            noh_h: -10
        }
    };
    this._isIE6 = !1;
    if (_isIE) this._isIE6 = window.XMLHttpRequest == null ? !0 : !1;
    this._engineSetWindowBody = function (b) {
        b.innerHTML = "<div iswin='1' class='dhtmlx_wins_body_outer' style='position: relative;'>" + (this._isIE6 ? "<iframe frameborder='0' class='dhtmlx_wins_ie6_cover_fix' onload='this.contentWindow.document.body.style.overflow=\"hidden\";'></iframe>" : "") + "<div class='dhtmlx_wins_icon'></div><div class='dhtmlx_wins_progress'></div><div class='dhtmlx_wins_title'>dhtmlxWindow</div><div class='dhtmlx_wins_btns'><div class='dhtmlx_wins_btns_button dhtmlx_button_sticked_default'></div><div class='dhtmlx_wins_btns_button dhtmlx_button_stick_default'></div><div class='dhtmlx_wins_btns_button dhtmlx_button_help_default'></div><div class='dhtmlx_wins_btns_button dhtmlx_button_park_default'></div><div class='dhtmlx_wins_btns_button dhtmlx_button_minmax2_default'></div><div class='dhtmlx_wins_btns_button dhtmlx_button_minmax1_default'></div><div class='dhtmlx_wins_btns_button dhtmlx_button_close_default'></div><div class='dhtmlx_wins_btns_button dhtmlx_button_dock_default'></div></div><div class='dhtmlx_wins_body_inner'></div><div winResT='yes' class='dhtmlx_wins_resizer_t' style='display:none;'></div><div winResL='yes' class='dhtmlx_wins_resizer_l'></div><div winResR='yes' class='dhtmlx_wins_resizer_r'></div><div winResB='yes' class='dhtmlx_wins_resizer_b'></div><div class='white_line'></div><div class='white_line2'></div></div>";
        b.dhxContGlobal = new dhtmlXContainer(b);
        if (this.skin == "dhx_skyblue") b.dhxContGlobal.obj._offsetWidth = -10, b.dhxContGlobal.obj._offsetHeight = -5, b.dhxContGlobal.obj._offsetLeft = 5, b.dhxContGlobal.obj._offsetHeightSaved = b.dhxContGlobal.obj._offsetHeight;
        if (this.skin == "dhx_web") b.dhxContGlobal.obj._offsetWidth = -10, b.dhxContGlobal.obj._offsetHeight = -5, b.dhxContGlobal.obj._offsetLeft = 5, b.dhxContGlobal.obj._offsetHeightSaved = b.dhxContGlobal.obj._offsetHeight;
        b.skin = this.skin;
        b.dhxContGlobal.setContent(b.childNodes[0].childNodes[this._isIE6 ?
            5 : 4]);
        b.coverBlocker().onselectstart = function (b) {
            b = b || event;
            b.returnValue = !1;
            b.cancelBubble = !0
        }
    };
    this._engineDiableOnSelectInWindow = function (b, c) {
        var e = [];
        e[0] = b.childNodes[0].childNodes[this._isIE6 ? 1 : 0];
        e[1] = b.childNodes[0].childNodes[this._isIE6 ? 2 : 1];
        e[2] = b.childNodes[0].childNodes[this._isIE6 ? 3 : 2];
        e[3] = b.childNodes[0].childNodes[this._isIE6 ? 4 : 3];
        e[4] = b.childNodes[0].childNodes[this._isIE6 ? 6 : 5];
        e[5] = b.childNodes[0].childNodes[this._isIE6 ? 7 : 6];
        e[6] = b.childNodes[0].childNodes[this._isIE6 ? 8 : 7];
        e[7] =
            b.childNodes[0].childNodes[this._isIE6 ? 9 : 8];
        for (var a = 0; a < e.length; a++) e[a].onselectstart = c ? function (a) {
            a = a || event;
            return a.returnValue = !1
        } : null
    };
    this._engineGetWindowHeader = function (b) {
        b.childNodes[0].idd = b.idd;
        return b.childNodes[0]
    };
    this._engineRedrawWindowSize = function (b) {
        b.style.width = String(b.w).search("%") == -1 ? b.w + "px" : b.w;
        b.style.height = String(b.h).search("%") == -1 ? b.h + "px" : b.h;
        var c = b.childNodes[0];
        c.style.width = b.clientWidth + "px";
        c.style.height = b.clientHeight + "px";
        if (c.offsetWidth > b.clientWidth) c.style.width =
            b.clientWidth * 2 - c.offsetWidth + "px";
        if (c.offsetHeight > b.clientHeight) {
            var e = b.clientHeight * 2 - c.offsetHeight;
            e < 0 && (e = 0);
            c.style.height = e + "px"
        }
        var a = b._noHeader == !0 ? b._hdrSize : this._engineSkinParams[this.skin].hh;
        this._engineRedrawWindowTitle(b);
        b.adjustContent(c, a)
    };
    this._engineRedrawWindowPos = function (b) {
        if (!b._isFullScreened) b.style.left = b.x + "px", b.style.top = b.y + "px"
    };
    this._engineFixWindowPosInViewport = function (b) {
        var c = b._noHeader == !0 ? b._hdrSize : this._engineSkinParams[this.skin].hh;
        if (b._keepInViewport) {
            if (b.x <
                0) b.x = 0;
            if (b.x + b.w > this.vp.offsetWidth) b.x = this.vp.offsetWidth - b.w;
            if (b.y + b.h > this.vp.offsetHeight) b.y = this.vp.offsetHeight - b.h;
            if (b.y < 0) b.y = 0
        } else {
            if (b.y + c > this.vp.offsetHeight) b.y = this.vp.offsetHeight - c;
            if (b.y < 0) b.y = 0;
            if (b.x + b.w - 10 < 0) b.x = 10 - b.w;
            if (b.x > this.vp.offsetWidth - 10) b.x = this.vp.offsetWidth - 10
        }
    };
    this._engineCheckHeaderMouseDown = function (b, c) {
        if (this._isIPad) {
            var e = c.touches[0].clientX,
                a = c.touches[0].clientY,
                f = c.target || c.srcElement;
            return f == b.childNodes[0] || f == b.childNodes[0].childNodes[0] ||
                f == b.childNodes[0].childNodes[2] || f == b.childNodes[0].childNodes[3] ? !0 : !1
        } else e = _isIE || _isOpera ? c.offsetX : c.layerX, a = _isIE || _isOpera ? c.offsetY : c.layerY, f = c.target || c.srcElement;
        var h = b._noHeader == !0 ? b._hdrSize : this._engineSkinParams[this.skin].hh;
        return a <= h && (f == b.childNodes[0] || f == b.childNodes[0].childNodes[this._isIE6 ? 1 : 0] || f == b.childNodes[0].childNodes[this._isIE6 ? 3 : 2] || f == b.childNodes[0].childNodes[this._isIE6 ? 4 : 3]) ? !0 : !1
    };
    this._engineGetWindowContent = function () {
        alert("_engineGetWindowContent")
    };
    this._engineGetWindowButton = function (b, c) {
        for (var e = null, a = "dhtmlx_button_" + String(c).toLowerCase() + "_", f = 0; f < b.childNodes[0].childNodes[this._isIE6 ? 4 : 3].childNodes.length; f++) {
            var h = b.childNodes[0].childNodes[this._isIE6 ? 4 : 3].childNodes[f];
            String(h.className).search(a) != -1 && (e = h)
        }
        return e
    };
    this._engineAddUserButton = function (b, c, e) {
        isNaN(e) && (e = 0);
        var a = document.createElement("DIV");
        a.className = "dhtmlx_wins_btns_button dhtmlx_button_" + c + "_default";
        var f = b.childNodes[0].childNodes[this._isIE6 ? 4 : 3],
            e = f.childNodes.length - e;
        e < 0 && (e = 0);
        e >= f.childNodes.length ? f.appendChild(a) : f.insertBefore(a, f.childNodes[e]);
        this._engineRedrawWindowTitle(b);
        return a
    };
    this._engineGetWindowParkedHeight = function () {
        return this._engineSkinParams[this.skin].hh + 1
    };
    this._engineDoOnWindowParkDown = function (b) {
        b.childNodes[0].childNodes[this._isIE6 ? 6 : 5].style.display = b._noHeader == !0 ? "" : "none";
        b.childNodes[0].childNodes[this._isIE6 ? 7 : 6].style.display = "";
        b.childNodes[0].childNodes[this._isIE6 ? 8 : 7].style.display = "";
        b.childNodes[0].childNodes[this._isIE6 ?
            9 : 8].style.display = ""
    };
    this._engineDoOnWindowParkUp = function (b) {
        b.childNodes[0].childNodes[this._isIE6 ? 6 : 5].style.display = "none";
        b.childNodes[0].childNodes[this._isIE6 ? 7 : 6].style.display = "none";
        b.childNodes[0].childNodes[this._isIE6 ? 8 : 7].style.display = "none";
        b.childNodes[0].childNodes[this._isIE6 ? 9 : 8].style.display = "none"
    };
    this._engineUpdateWindowIcon = function (b, c) {
        b.childNodes[0].childNodes[this._isIE6 ? 1 : 0].style.backgroundImage = "url('" + c + "')"
    };
    this._engineAllowWindowResize = function (b, c, e, a) {
        if (c.getAttribute) {
            var f =
                this._engineSkinParams[this.skin],
                h = b._noHeader == !0 ? b._hdrSize : this._engineSkinParams[this.skin].hh;
            return c.getAttribute("winResL") != null && c.getAttribute("winResL") == "yes" && a >= h ? a >= b.h - f.lch ? "corner_left" : a <= f.lch && b._noHeader == !0 ? "corner_up_left" : "border_left" : c.getAttribute("winResR") != null && c.getAttribute("winResR") == "yes" && a >= h ? a >= b.h - f.rch ? "corner_right" : a <= f.rch && b._noHeader == !0 ? "corner_up_right" : "border_right" : c.getAttribute("winResT") != null && c.getAttribute("winResT") == "yes" && b._noHeader ==
                !0 ? e <= f.lcw ? "corner_up_left" : e >= b.w - f.rcw ? "corner_up_right" : "border_top" : c.getAttribute("winResB") != null && c.getAttribute("winResB") == "yes" ? e <= f.lcw ? "corner_left" : e >= b.w - f.rcw ? "corner_right" : "border_bottom" : null
        }
    };
    this._engineAdjustWindowToContent = function (b, c, e) {
        var a = c + b.w - b.vs[b.av].dhxcont.clientWidth,
            f = e + b.h - b.vs[b.av].dhxcont.clientHeight;
        b.setDimension(a, f)
    };
    this._engineRedrawSkin = function () {
        this.vp.className = "dhtmlx_winviewport dhtmlx_skin_" + this.skin + (this._r ? " dhx_wins_rtl" : "");
        var b = this._engineSkinParams[this.skin],
            c;
        for (c in this.wins) this.skin == "dhx_skyblue" ? (this.wins[c].dhxContGlobal.obj._offsetTop = this.wins[c]._noHeader ? b.noh_t : null, this.wins[c].dhxContGlobal.obj._offsetWidth = -10, this.wins[c].dhxContGlobal.obj._offsetHeight = this.wins[c]._noHeader ? b.noh_h : -5, this.wins[c].dhxContGlobal.obj._offsetLeft = 5, this.wins[c].dhxContGlobal.obj._offsetHeightSaved = -5) : (this.wins[c].dhxContGlobal.obj._offsetWidth = null, this.wins[c].dhxContGlobal.obj._offsetHeight = null, this.wins[c].dhxContGlobal.obj._offsetLeft = null, this.wins[c].dhxContGlobal.obj._offsetTop =
            null, this.wins[c].dhxContGlobal.obj._offsetHeightSaved = null), this.wins[c].skin = this.skin, this._restoreWindowIcons(this.wins[c]), this._engineRedrawWindowSize(this.wins[c])
    };
    this._engineSwitchWindowProgress = function (b, c) {
        c == !0 ? (b.childNodes[0].childNodes[this._isIE6 ? 1 : 0].style.display = "none", b.childNodes[0].childNodes[this._isIE6 ? 2 : 1].style.display = "") : (b.childNodes[0].childNodes[this._isIE6 ? 2 : 1].style.display = "none", b.childNodes[0].childNodes[this._isIE6 ? 1 : 0].style.display = "")
    };
    this._engineSwitchWindowHeader =
        function (b, c) {
            if (!b._noHeader) b._noHeader = !1;
            if (c == b._noHeader) {
                b._noHeader = c == !0 ? !1 : !0;
                b._hdrSize = 0;
                b.childNodes[0].childNodes[this._isIE6 ? 5 : 4].className = "dhtmlx_wins_body_inner" + (b._noHeader ? " dhtmlx_wins_no_header" : "");
                b.childNodes[0].childNodes[this._isIE6 ? 6 : 5].style.display = b._noHeader ? "" : "none";
                b.childNodes[0].childNodes[this._isIE6 ? 1 : 0].style.display = b._noHeader ? "none" : "";
                b.childNodes[0].childNodes[this._isIE6 ? 3 : 2].style.display = b._noHeader ? "none" : "";
                b.childNodes[0].childNodes[this._isIE6 ?
                    4 : 3].style.display = b._noHeader ? "none" : "";
                var e = this._engineSkinParams[this.skin];
                b._noHeader ? (b.dhxContGlobal.obj._offsetHeightSaved = b.dhxContGlobal.obj._offsetHeight, b.dhxContGlobal.obj._offsetHeight = e.noh_h, b.dhxContGlobal.obj._offsetTop = e.noh_t) : (b.dhxContGlobal.obj._offsetHeight = b.dhxContGlobal.obj._offsetHeightSaved, b.dhxContGlobal.obj._offsetTop = null);
                this._engineRedrawWindowSize(b)
            }
    };
    this._engineGetWindowHeaderState = function (b) {
        return b._noHeader ? !0 : !1
    };
    this._engineGetWindowLabel = function (b) {
        return b.childNodes[0].childNodes[this._isIE6 ?
            3 : 2]
    };
    this._engineRedrawWindowTitle = function (b) {
        if (b._noHeader !== !0) {
            var c = b.childNodes[0].childNodes[this._isIE6 ? 1 : 0].offsetWidth,
                e = b.childNodes[0].childNodes[this._isIE6 ? 4 : 3].offsetWidth,
                a = b.offsetWidth - c - e - 24;
            a < 0 ? a = "100%" : a += "px";
            b.childNodes[0].childNodes[this._isIE6 ? 3 : 2].style.width = a
        }
    }
};


//v.3.0 build 110713

/*
Copyright DHTMLX LTD. http://www.dhtmlx.com
To use this component please contact sales@dhtmlx.com to obtain license
*/