package com.baseball.board.dao;

import java.util.List;
import java.util.Map;

import com.baseball.board.model.BoardDto;

public interface BoardDao {
	int getNextSeq();
	void updateHit(int seq);
	void updateStatus(int seq);

	//	PageNavigation makePageNavigation(int bcode, int pg, String key, String word, int listsize);
	
	int writeArticle(BoardDto boardDto);
	BoardDto viewArticle(int seq);
	int deleteArticle(int seq);
	int modifyArticle(BoardDto boardDto);
	List<BoardDto> listArticle(Map<String, String> map);
	List<BoardDto> bestArticle(int tno);

	int getTotalArticleCount(Map<String, String> map);
	int getPrevBno(int tno, int seq);
	int getNextBno(int tno, int seq);
	List<BoardDto> hotBoardArticle(int tno);

}
