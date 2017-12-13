package com.baseball.factory;

import com.baseball.admin.action.ListNoticeAction;
import com.baseball.admin.action.NtypeListAction;
import com.baseball.admin.action.UserListAction;
import com.baseball.admin.action.ViewNoticeAction;
import com.baseball.admin.action.WrtieNoticeAction;

public class AdminActionFactory {
	private static UserListAction userListAction;
	private static WrtieNoticeAction writeNoticeAction;
	private static ListNoticeAction listNoticeAction;
	private static NtypeListAction ntypeListAction;
	private static ViewNoticeAction viewNoticeAction;
	static {
		
		userListAction = new UserListAction();
		writeNoticeAction = new WrtieNoticeAction();
		listNoticeAction = new ListNoticeAction();
		ntypeListAction = new NtypeListAction();
		viewNoticeAction = new ViewNoticeAction();
	}

	public static ViewNoticeAction getViewNoticeAction() {
		return viewNoticeAction;
	}

	public static UserListAction getUserListAction() {
		return userListAction;
	}

	public static WrtieNoticeAction getWriteNoticeAction() {
		return writeNoticeAction;
	}

	public static ListNoticeAction getListNoticeAction() {
		return listNoticeAction;
	}

	public static NtypeListAction getNtypeListAction() {
		return ntypeListAction;
	}
	
	
}
