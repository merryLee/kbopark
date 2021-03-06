package com.baseball.board.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.baseball.action.Action;
import com.baseball.board.model.BoardDto;
import com.baseball.board.service.BoardServiceImpl;
import com.baseball.util.NullCheck;

public class BoardNotifyAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int seq = NullCheck.nullToZero(request.getParameter("seq"));
		if(seq != 0) {
			BoardDto boardDto = BoardServiceImpl.getBoardService().notifyArticle(seq);
			
			request.setAttribute("article", boardDto);
		}
		return "/community/view.jsp";
	}

}
