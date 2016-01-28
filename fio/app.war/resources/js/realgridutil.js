
/* div tag를 flash object tag로 대체 */

function setupGrid(tagid, width, height, onload, params) {
    var flashvars = {
        id: tagid
    };

    if (params) {
        for (var p in params) {
            flashvars[p] = params[p];
        }
    }

    if (onload) {
        flashvars.onload = typeof (onload) === "function" ? onload.name : onload;
        console && console.log(flashvars);
    }

    var pars = {
        quality: "high",
        wmode: "direct",
        allowscriptaccess: "sameDomain",
        allowfullscreen: "false",
        seamlesstabbing: false		
    };

    var attrs = {
        id: tagid,
        name: tagid,
        align: "middle"
    };

    /* SWFObject v2.2 <http://code.google.com/p/swfobject/> */
    var swfUrl = "objects/RealGridWeb.swf";
    if (location.href.indexOf("http://localhost") == 0) {
        swfUrl = swfUrl + "?" + new Date().getTime();
    }
    swfobject.embedSWF(swfUrl, tagid, width, height, "11.1.0", "objects/expressInstall.swf", flashvars, pars, attrs);
};

function setupTree(tagid, width, height, onload, params) {
    var flashvars = {
        id: tagid
    };

    if (params) {
        for (var p in params) {
            flashvars[p] = params[p];
        }
    }

    if (onload) {
        flashvars.onload = typeof (onload) === "function" ? onload.name : onload;
        console && console.log(flashvars);
    }

    var pars = {
        quality: "high",
        wmode: "direct",
        allowscriptaccess: "sameDomain",
        allowfullscreen: "true"
    };

    if (isSafari)
        pars.wmode = "direct";

    var attrs = {
        id: tagid,
        name: tagid,
        align: "middle"
    };

    /* used SWFObject v2.2 <http://code.google.com/p/swfobject/> */
    var swfUrl = "Objects/TreeGridWeb.swf";
    swfobject.embedSWF(swfUrl, tagid, width, height, "11.1.0", "objects/expressInstall.swf", flashvars, pars, attrs);
};

