/*
Product Name: dhtmlxForm 
Version: 4.0.1 
Edition: Standard 
License: content of this file is covered by GPL. Usage outside GPL terms is prohibited. To obtain Commercial or Enterprise license contact sales@dhtmlx.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/

dhtmlXCalendarObject.prototype.draw=function(){this.show()};dhtmlXCalendarObject.prototype.close=function(){this.hide()};dhtmlXCalendarObject.prototype.setYearsRange=function(){};dhtmlXCombo.prototype.loadXML=function(a,b){this.load(a,b)};dhtmlXCombo.prototype.loadXMLString=function(a){this.load(a)};dhtmlXCombo.prototype.enableOptionAutoHeight=function(){};dhtmlXCombo.prototype.enableOptionAutoPositioning=function(){};dhtmlXCombo.prototype.enableOptionAutoWidth=function(){};dhtmlXCombo.prototype.destructor=function(){this.unload()};dhtmlXCombo.prototype.render=function(){};dhtmlXCombo.prototype.setOptionHeight=function(){};dhtmlXCombo.prototype.attachChildCombo=function(){};dhtmlXCombo.prototype.setAutoSubCombo=function(){};dhtmlXForm.prototype.getItemsList=function(){var d=[];var c=[];for(var b in this.itemPull){var e=null;if(this.itemPull[b]._group){e=this.itemPull[b]._group}else{e=b.replace(this.idPrefix,"")}if(c[e]!=true){d.push(e)}c[e]=true}return d};dhtmlXForm.prototype.setItemText=function(){this.setItemLabel.apply(this,arguments)};dhtmlXForm.prototype.getItemText=function(){return this.getItemLabel.apply(this,arguments)};dhtmlXForm.prototype.loadStructString=function(b,a){this.loadStruct(b,a)};