/**
 * http.js: utilities for scripted HTTP requests
 *
 * From the book JavaScript: The Definitive Guide, 5th Edition,
 * by David Flanagan. Copyright 2006 O'Reilly Media, Inc. (ISBN: 0596101996)
 */
// 일부 수정. 전찬모

var HTTP;
if (HTTP && (typeof HTTP != "object" || HTTP.NAME))
    throw new Error("Namespace 'HTTP' already exists");

HTTP = {};
HTTP.NAME = "HTTP";    // The name of this namespace
HTTP.VERSION = 1.0;    // The version of this namespace

HTTP._factories = [
    function() { return new XMLHttpRequest(); },
    function() { return new ActiveXObject("Msxml2.XMLHTTP"); },
    function() { return new ActiveXObject("Microsoft.XMLHTTP"); }
];

HTTP._factory = null;

HTTP.newRequest = function() {
    if (HTTP._factory != null) return HTTP._factory();

    for(var i = 0; i < HTTP._factories.length; i++) {
        try {
            var factory = HTTP._factories[i];
            var request = factory();
            if (request != null) {
                HTTP._factory = factory;
                return request;
            }
        }
        catch(e) {
            continue;
        }
    }
    HTTP._factory = function() {
        throw new Error("XMLHttpRequest not supported");
    }
    HTTP._factory(); 
}

HTTP.post = function(url, values, callback, errorHandler) {
    var request = HTTP.newRequest();
    request.onreadystatechange = function() {
        if (request.readyState == 4) {
            if (request.status == 200) {
                callback(HTTP._getResponse(request));
            }
            else {
                if (errorHandler) errorHandler(request.status,
                                               request.statusText);
                else callback(null);
            }
        }
    }

    request.open("POST", url);
    request.setRequestHeader("Content-Type",
                             "application/x-www-form-urlencoded");
    request.send(HTTP.encodeFormData(values));
};


HTTP.encodeFormData = function(form) {
    var pairs = [];

    for(var i=0;i<form.elements.length;i++) {
    	var e = form.elements[i];
        var pair = encodeURIComponent(e.name) + '=' +
            	   encodeURIComponent(e.value);
        pairs.push(pair);
    }

    return pairs.join('&');
};

HTTP._getResponse = function(request) {
    switch(request.getResponseHeader("Content-Type")) {
    case "text/xml":
        return request.responseXML;

    case "text/json":
    case "application/json": 
    case "text/javascript":
    case "application/javascript":
    case "application/x-javascript":
        return eval(request.responseText);

    default:
        return request.responseText;
    }
};

var XML;

// Create our namespace, and specify some meta-information
XML = {};
XML.NAME = "XML";     // The name of this namespace
XML.VERSION = 1.0;    // The version of this namespace

XML.newDocument = function(rootTagName, namespaceURL) {
    if (!rootTagName) rootTagName = "";
    if (!namespaceURL) namespaceURL = "";
    
    if (document.implementation && document.implementation.createDocument) {
        // This is the W3C standard way to do it
        return document.implementation.createDocument(namespaceURL,
                                                      rootTagName, null);
    }
    else { // This is the IE way to do it
        // Create an empty document as an ActiveX object
        // If there is no root element, this is all we have to do
        var doc = new ActiveXObject("MSXML2.DOMDocument");

        // If there is a root tag, initialize the document
        if (rootTagName) {
            // Look for a namespace prefix
            var prefix = "";
            var tagname = rootTagName;
            var p = rootTagName.indexOf(':');
            if (p != -1) {
                prefix = rootTagName.substring(0, p);
                tagname = rootTagName.substring(p+1);
            }

            // If we have a namespace, we must have a namespace prefix
            // If we don't have a namespace, we discard any prefix
            if (namespaceURL) {
                if (!prefix) prefix = "a0"; // What Firefox uses
            }
            else prefix = "";

            // Create the root element (with optional namespace) as a
            // string of text
            var text = "<" + (prefix?(prefix+":"):"") +  tagname +
                (namespaceURL
                 ?(" xmlns:" + prefix + '="' + namespaceURL +'"')
                 :"") +
                "/>";
            // And parse that text into the empty document
            doc.loadXML(text);
        }
        return doc;
    }
};

/**
 * Parse the XML document contained in the string argument and return 
 * a Document object that represents it.
 */
XML.parse = function(text) {
    if (typeof DOMParser != "undefined") {
        // Mozilla, Firefox, and related browsers
        return (new DOMParser()).parseFromString(text, "application/xml");
    }
    else if (typeof ActiveXObject != "undefined") {
        // Internet Explorer.
        var doc = XML.newDocument();  // Create an empty document
        doc.loadXML(text);            // Parse text into it
        return doc;                   // Return it
    }
    else {
        // As a last resort, try loading the document from a data: URL
        // This is supposed to work in Safari.  Thanks to Manos Batsis and
        // his Sarissa library (sarissa.sourceforge.net) for this technique.
        var url = "data:text/xml;charset=utf-8," + encodeURIComponent(text);
        var request = new XMLHttpRequest();
        request.open("GET", url, false);
        request.send(null);
        return request.responseXML;
    }
};



/**
브라우저 타입확인
*/
function getBrowserType() {
	if (navigator.appName == "Microsoft Internet Explorer") return 1;
	
	if (navigator.appName == "Netscape") return 2;
	
	return 0;
}

/**
보이기 숨기기 (+/- 기호사용)
*/
function funcToggleView(divName,opt)
{
	var obj_div = document.getElementById(divName);
	
	var disStr = 'block';
	
	if (getBrowserType() == 2) {
		disStr = 'table';
	}  
	
	if(opt)
 	{
  		if(opt='on') {
   			obj_div.style.display=disStr;
  		} else {
  			obj_div.style.display='none';
  		}
 	} else {
  		if(obj_div.style.display=='none') {
   			obj_div.style.display=disStr;
  		} else {
  			obj_div.style.display='none';
  		}
 	}
 	
 	if (getBrowserType() == 1) {
		obj_caller = event.srcElement;
		if (obj_div.style.display == 'none') {
			obj_caller.innerText = '[+]';
		} else {
			obj_caller.innerText = '[-]';
		}
	}
}

/*
==================================================
최초작성일 : 2002년 11월 26일
--------------------------------------------------
  본 문서는 자유롭게 배포/복사 할 수 있으나 반드시
  이 문서의 저자에 대한 언급을 삭제하시면 안됩니다.
  (이 내용은 javaservice.net에서 copy.)
--------------------------------------------------
  이호훈(siva6)
  E-mail: siva6@dreamwiz.com
==================================================
변경. 전찬모.
*/
/* BEGIN - function for table sorting *************************************/
                    //Start Row for Sort
function funcSort(isNum)
{
	if(isNum == null) isNum = "S";
	
	if (getBrowserType() != 1) {
		alert("Netscape 계열 브라우져에서는 제공되지 않습니다.");
	} 
	
	var obj_div = event.srcElement;
	
    if( obj_div == null || obj_div.tagName != 'LABEL') return;

    //get td obj;
    var obj_td    = obj_div;
    while(obj_td.tagName != 'TD' && obj_td.parentNode != null) {
        obj_td = obj_td.parentNode;
    }
    var cellNum   = obj_td.cellIndex;

    //get tr obj;
    var obj_tr    = obj_td;
    while(obj_tr.tagName != 'TR' && obj_tr.parentNode != null) {
        obj_tr = obj_tr.parentNode;
    }

    //get table obj;
    var obj_table = obj_tr;
    while(obj_table.tagName != 'TABLE' && obj_table.parentNode != null) {
        obj_table = obj_table.parentNode;
    }

    var obj_trs = obj_table.rows;
    var obj_tds = obj_tr.cells;

    var startRow = 1;
    
    if( obj_div.order.toUpperCase() == 'ASC' ) {
        for(var i = startRow, max = obj_trs.length; i < max; i++) {
            var tmp_tr0       = obj_trs[i];
            var tmp_tr0_value = getValue(tmp_tr0.cells[cellNum]);
            for(var j = i ; j < max; j++) {
                var tmp_tr1 = obj_trs[j];
                
                if (isNum == "S") {
                    if(tmp_tr0_value > getValue(tmp_tr1.cells[cellNum])) {
	                    obj_table.moveRow(j, i);
	                    tmp_tr0 = tmp_tr1;
	                    tmp_tr0_value = getValue(tmp_tr0.cells[cellNum]);
                	}
                } else {
	                if(compareNum(tmp_tr0_value,getValue(tmp_tr1.cells[cellNum])) > 0) {
	                    obj_table.moveRow(j, i);
	                    tmp_tr0 = tmp_tr1;
	                    tmp_tr0_value = getValue(tmp_tr0.cells[cellNum]);
                	}
                }
            }
        }
        obj_div.order = 'DESC';
        obj_div.innerText = '▲';
    }else if( obj_div.order.toUpperCase() == 'DESC' ) {
        for(var i = startRow, max = obj_trs.length; i < max; i++) {
            var tmp_tr0       = obj_trs[i];
            var tmp_tr0_value = getValue(tmp_tr0.cells[cellNum]);
            for(var j = i ; j < max; j++) {
                var tmp_tr1 = obj_trs[j];
                
                if (isNum == "S") {
	                if(tmp_tr0_value < getValue(tmp_tr1.cells[cellNum])) {
	                    obj_table.moveRow(j, i);
	                    tmp_tr0 = tmp_tr1;
	                    tmp_tr0_value = getValue(tmp_tr0.cells[cellNum]);
	                }
	            } else {
	                if(compareNum(tmp_tr0_value,getValue(tmp_tr1.cells[cellNum])) < 0) {
	                    obj_table.moveRow(j, i);
	                    tmp_tr0 = tmp_tr1;
	                    tmp_tr0_value = getValue(tmp_tr0.cells[cellNum]);
	                }	            
	            }
            }
        }
        obj_div.order = 'ASC';
        obj_div.innerText = '▼';
    }
}

function compareNum(atr,btr) {
	var a = Number(atr.replace(/[^\d]/g,''));
	var b = Number(btr.replace(/[^\d]/g,''));
	if(isNaN(a)) a=0;
	if(isNaN(b)) b=0;	
	return a-b;
}

function getValue(obj)
{
    var retVal = obj.innerText;
    var objs   = obj.childNodes;
    for(var i = 0, max = objs.length; i < max; i++) {
        var obj = objs[i];
        if( obj.tagName != null && obj.tagName.toUpperCase() == 'INPUT') {
            if( obj.type.toUpperCase() == 'TEXT' ) {
                retVal += obj.value;
            }
        }
    }
    return retVal;
}
/* END - function for table sorting ***************************************/

/* START - function for table fold ***************************************/
            //접을 시작 위치, 접을개수
function funcFold(start, len)
{
    if(len == null) len = 1;
    var obj_div   = event.srcElement;
    alert(obj_div);
    if( obj_div == null || obj_div.tagName != 'LABEL') return;

	var obj_table = obj_div;
    while(obj_table.tagName != 'TABLE' && obj_table.parentNode != null) {
        obj_table = obj_table.parentNode;
    }

	var obj_trs   = obj_table.rows;
	var obj_tr, obj_tds, obj_td;
	for(var i = 0; i < obj_trs.length; i++) {
	    var obj_tr  = obj_trs[i];
	    var obj_tds = obj_tr.cells;
	    for( var j = start; j < start + len; j++) {
	        var obj_td = obj_tds[j];
	        if(obj_div.flag) {
	            obj_td.value     = obj_td.innerHTML;
	            obj_td.preWidth  = obj_td.width;
	            obj_td.innerHTML = '';
	            obj_td.width     = 1;
	        }else {
	            obj_td.innerHTML = obj_td.value;
	            obj_td.width = obj_td.preWidth;
	        }//if
	    }//for
	}//for

	obj_div.flag       = !obj_div.flag;
	obj_div.innerText  = (obj_div.flag)?'◀':'▶';
}
/* END - function for table fold ***************************************/
