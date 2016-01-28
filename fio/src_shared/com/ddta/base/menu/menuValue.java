package com.ddta.base.menu;

public class menuValue 
{
	private String menuName;
	private String menuCommand;
	private String menuType;

	public menuValue(String _menuName, String _menuCommand,String _menuType) {
	    this.menuName = _menuName;
	    this.menuCommand = _menuCommand;
	    this.menuType = _menuType;
	  }

	public String getMenuType() {
		return menuType;
	}

	public void setMenuType(String menuType) {
		this.menuType = menuType;
	}

	public String getMenuName() {
		return menuName;
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	public String getMenuCommand() {
		return menuCommand;
	}

	public void setMenuCommand(String menuCommand) {
		this.menuCommand = menuCommand;
	}
	
	
}
