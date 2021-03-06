package com.baseball.board.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.baseball.board.model.BoardDto;
import com.baseball.util.db.DBClose;
import com.baseball.util.db.DBConnection;

public class BoardDaoImpl implements BoardDao {

	private static BoardDao boardDao;

	static {
		boardDao = new BoardDaoImpl();
	}

	private BoardDaoImpl() {
	}

	public static BoardDao getBoardDao() {
		return boardDao;
	}

	@Override
	public int getNextSeq() {
		int seq = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("select board_seq.nextval from dual");
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			rs.next();
			seq = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt, rs);
		}
		return seq;
	}

	@Override
	public int writeArticle(BoardDto boardDto) {
		int cnt = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("insert into board (bno, mid, bname, bdetail, tno, bcount, bdate, bstatus, mname) \n");
			sql.append("			values (?, ?, ?, ?, ?, 0, sysdate, 0, ?) \n");
			pstmt = conn.prepareStatement(sql.toString());
			int idx = 0;
			pstmt.setInt(++idx, boardDto.getBno());
			pstmt.setString(++idx, boardDto.getMid());
			pstmt.setString(++idx, boardDto.getBname());
			pstmt.setString(++idx, boardDto.getBdetail());
			pstmt.setInt(++idx, boardDto.getTno());
			pstmt.setString(++idx, boardDto.getMname());
			cnt = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt);
		}
		return cnt;
	}

	@Override
	public void updateHit(int seq) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("update board \n");
			sql.append("set bcount = bcount + 1 \n");
			sql.append("where bno = ?");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, seq);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt);
		}
	}

	@Override
	public BoardDto viewArticle(int seq) {
		BoardDto boardDto = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("select b.bno, b.mid, b.bname, b.bdetail, b.tno, b.bcount, b.bdate, b.bstatus \n");
			sql.append("from board b \n");
			sql.append("where b.bno = ?");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, seq);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				boardDto = new BoardDto();
				boardDto.setBno(rs.getInt("bno"));
				boardDto.setMid(rs.getString("mid"));
				boardDto.setBname(rs.getString("bname"));
				boardDto.setBdetail(rs.getString("bdetail"));
				boardDto.setTno(rs.getInt("tno"));
				boardDto.setBcount(rs.getInt("bcount"));
				boardDto.setBdate(rs.getString("bdate"));
				boardDto.setBstatus(rs.getInt("bstatus"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt, rs);
		}
		return boardDto;
	}

	@Override
	public int modifyArticle(BoardDto boardDto) {
		int cnt = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		System.out.println("BoardDI modifyArticle ����");
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();

			sql.append("UPDATE board \n");
			sql.append("SET bname = ?, bdetail = ? \n");
			sql.append("WHERE bno = ?");
			pstmt = conn.prepareStatement(sql.toString());
			int idx = 0;
			pstmt.setString(++idx, boardDto.getBname());
			pstmt.setString(++idx, boardDto.getBdetail());
			pstmt.setInt(++idx, boardDto.getBno());
			cnt = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt);
		}
		return cnt;
	}

	@Override
	public int deleteArticle(int seq) {
		int cnt = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("DELETE FROM board \n");
			sql.append("WHERE bno = ?");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, seq);
			cnt = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt);
		}
		System.out.println("BoardDaoImpl Delete ����cnt >>> " + cnt);
		return cnt;
	}

	@Override
	public List<BoardDto> listArticle(Map<String, String> map) {
		List<BoardDto> list = new ArrayList<BoardDto>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("select b.*, (SELECT COUNT(*) FROM board_reply r WHERE r.bno=b.bno) replycnt \n");
			sql.append("from ( \n");
			sql.append("	  select rownum rn, a.* \n");
			sql.append("	  from ( \n");
			sql.append("	  	  select  bno, mid, mname, bname, bdetail, tno, bcount, bstatus, \n");
			sql.append("				  case  \n");
			sql.append("					when to_char(bdate, 'yymmdd') = to_char(sysdate, 'yymmdd') \n");
			sql.append("					then to_char(bdate, 'hh24:mi:ss') \n");
			sql.append("					else to_char(bdate, 'yy.mm.dd') \n");
			sql.append("				  end bdate \n");
			sql.append("	  	  from board b \n");
			sql.append("	  	  where b.tno = ? \n");
			String word = map.get("word");
			if (!word.isEmpty()) {
				String key = map.get("key");
				if ("mname".equals(key))
					sql.append("	  	  and mname = ? \n");
				else
					sql.append("	  	  and " + key + " like '%'||?||'%' \n");
			}
			sql.append("	  	  order by bno desc \n");
			sql.append("	 	  ) a \n");
			sql.append("	  where rownum <= ? \n");
			sql.append("	 ) b \n");
			sql.append("where b.rn > ? \n");
			pstmt = conn.prepareStatement(sql.toString());
			int idx = 0;
			pstmt.setString(++idx, map.get("tno"));
			if (!word.isEmpty())
				pstmt.setString(++idx, word);
			pstmt.setString(++idx, map.get("end"));
			pstmt.setString(++idx, map.get("start"));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BoardDto boardDto = new BoardDto();
				boardDto.setBno(rs.getInt("bno"));
				boardDto.setMid(rs.getString("mid"));
				boardDto.setMname(rs.getString("mname"));
				boardDto.setBname(rs.getString("bname"));
				boardDto.setBdetail(rs.getString("bdetail"));
				boardDto.setTno(rs.getInt("tno"));
				boardDto.setBcount(rs.getInt("bcount"));
				boardDto.setBdate(rs.getString("bdate"));
				boardDto.setBstatus(rs.getInt("bstatus"));
				boardDto.setTotalreply(rs.getInt("replycnt"));
				list.add(boardDto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt, rs);
		}
		return list;
	}

	@Override
	public List<BoardDto> bestArticle(int tno) {
		List<BoardDto> bestlist = new ArrayList<BoardDto>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("select rownum rn, a.*, (SELECT COUNT(*) FROM board_reply r WHERE r.bno=a.bno) replycnt \n");
			sql.append("from ( \n");
			sql.append("	select bno, mid, bname, bdetail, tno, bcount, bstatus, bdate \n");
			sql.append("	from board \n");
			sql.append("	where tno = ? \n");
			sql.append("	order by bcount desc) a \n");
			sql.append("where rownum <= 10");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, tno);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BoardDto boardDto = new BoardDto();
				boardDto.setBno(rs.getInt("bno"));
				boardDto.setMid(rs.getString("mid"));
				boardDto.setBname(rs.getString("bname"));
				boardDto.setBdetail(rs.getString("bdetail"));
				boardDto.setTno(rs.getInt("tno"));
				boardDto.setBcount(rs.getInt("bcount"));
				boardDto.setBdate(rs.getString("bdate"));
				boardDto.setBstatus(rs.getInt("bstatus"));
				boardDto.setTotalreply(rs.getInt("replycnt"));
				bestlist.add(boardDto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt, rs);
		}
		return bestlist;
	}

	@Override
	public int getTotalArticleCount(Map<String, String> map) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("select count(bno) \n");
			sql.append("from board \n");
			sql.append("where tno = ? \n");
			String word = map.get("word");
			if(!word.isEmpty()) {
				String key = map.get("key");
				if ("mname".equals(key))
					sql.append("	  	  and mname = ? \n");
				else
					sql.append("	  	  and " + key + " like '%'||?||'%' \n");
			}
			
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, map.get("tno"));
			if(!word.isEmpty())
				pstmt.setString(2, word);
			rs = pstmt.executeQuery();
			rs.next();
			count = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt, rs);
		}
		System.out.println("BoardDI totalcount >> " + count);
		return count;
	}

	@Override
	public void updateStatus(int seq) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("update board \n");
			sql.append("set bstatus = '1' \n");
			sql.append("where bno = ?");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, seq);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt);
		}
	}

	@Override
	public int getPrevBno(int tno, int seq) {
		int pseq = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT MAX(bno) \n");
			sql.append("FROM board \n");
			sql.append("WHERE tno = ? AND bno < ?");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, tno);
			pstmt.setInt(2, seq);
			rs = pstmt.executeQuery();
			if(rs.next())
				pseq = rs.getInt(1);
			else
				pseq = seq;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt, rs);
		}
		System.out.println("BoardDI pseq >> " + pseq);
		return pseq;
	}

	@Override
	public int getNextBno(int tno, int seq) {
		int nseq = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT MIN(bno) \n");
			sql.append("FROM board \n");
			sql.append("WHERE tno = ? AND bno > ?");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, tno);
			pstmt.setInt(2, seq);
			rs = pstmt.executeQuery();
			if(rs.next())
				nseq = rs.getInt(1);
			else
				nseq = seq;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt, rs);
		}
		System.out.println("BoardDI nseq >> " + nseq);
		return nseq;
	}

	@Override
	public List<BoardDto> hotBoardArticle(int tno) {
		List<BoardDto> hotlist = new ArrayList<BoardDto>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("select a.* \n");
			sql.append("from (  \n");
			sql.append("	select b.bno, mid, bname, bdetail, tno, bcount, bstatus, bdate, (SELECT COUNT(*) FROM board_reply r WHERE r.bno=b.bno) replycnt \n"); 
			sql.append("	from board b \n");
			sql.append("	where tno = ? \n");
			sql.append("	order by replycnt desc, bcount desc) a  \n");
			sql.append("where rownum <= 3");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setInt(1, tno);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BoardDto boardDto = new BoardDto();
				boardDto.setBno(rs.getInt("bno"));
				boardDto.setMid(rs.getString("mid"));
				boardDto.setBname(rs.getString("bname"));
				boardDto.setBdetail(rs.getString("bdetail"));
				boardDto.setTno(rs.getInt("tno"));
				boardDto.setBcount(rs.getInt("bcount"));
				boardDto.setBdate(rs.getString("bdate"));
				boardDto.setBstatus(rs.getInt("bstatus"));
				boardDto.setTotalreply(rs.getInt("replycnt"));
				hotlist.add(boardDto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt, rs);
		}
		System.out.println("BoardDI hotboardlist >> " + hotlist.size());
		return hotlist;
	}	
	
}