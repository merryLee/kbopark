package com.baseball.auction.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.baseball.auction.model.AuctionDetailDto;
import com.baseball.util.db.DBClose;
import com.baseball.util.db.DBConnection;


public class AuctionEndDaoImpl implements AuctionEndDao {

	private static AuctionEndDao auctionEndDao;

	static {
		auctionEndDao = new AuctionEndDaoImpl();
	}
	
	public static AuctionEndDao getAuctionEndDao() {
		return auctionEndDao;
	}

	@Override
	public int auctionStatusEnd(String ano) {
		int cnt = 0;
		int cnt_member = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnection.makeConnection();
			conn.setAutoCommit(false);
			//경매상태 종료로 변경
			StringBuffer astatus_change = new StringBuffer();
			astatus_change.append("update auction \n");
			astatus_change.append("set astatus = 2 \n");
			astatus_change.append("where ano = ?");
			pstmt = conn.prepareStatement(astatus_change.toString());
			pstmt.setString(1,ano);
			pstmt.executeUpdate();
			pstmt.close();
			
			// 낙찰회원 찾기, biddate 추가
			StringBuffer successful_bid = new StringBuffer();	
			successful_bid.append("select  auction_detail.ano, auction_detail.mid,  auction_detail.bidprice\n");
			successful_bid.append("from auction_detail, (\n");
			successful_bid.append("                      select ano, max(bidprice) as bidprice \n");
			successful_bid.append("                      from auction_detail \n");
			successful_bid.append("                      where ano = ? \n");
			successful_bid.append("                      group by ano\n");
			successful_bid.append("                      ) ad\n");
			successful_bid.append("where  auction_detail.ano = ad.ano and  auction_detail.bidprice = ad.bidprice");
			pstmt = conn.prepareStatement(successful_bid.toString());
			pstmt.setString(1,ano);
			rs = pstmt.executeQuery();
			if(rs.next())	//입찰자가 있을경우만
			{
				AuctionDetailDto auctionDetailDto  = new AuctionDetailDto();
				auctionDetailDto.setAno(rs.getInt("ano"));
				auctionDetailDto.setMid(rs.getString("mid"));
				auctionDetailDto.setBidPrice(rs.getInt("bidprice"));
				
				//경매완료상세 테이블에 인서트 
				StringBuffer insert_successful_bid_result = new StringBuffer();	
				//경매완료상세 테이블에 낙찰시각(RBIDDATE) 컬럼 추가함 -> 루키상세에 일시(paydate)DATE에 insert할때 필요 
				insert_successful_bid_result.append("insert into auction_result(ano, mid, finalprice, rbiddate ) \n");
				insert_successful_bid_result.append("values(?, ?, ?, sysdate)");
				pstmt = conn.prepareStatement(insert_successful_bid_result.toString());
				pstmt.setInt(1, auctionDetailDto.getAno());
				pstmt.setString(2,auctionDetailDto.getMid());
				pstmt.setInt(3,auctionDetailDto.getBidPrice());
				pstmt.executeUpdate();
				pstmt.close();
			}
			
			// 낙찰받지 못한 회원 루키 원래대로 + 
			StringBuffer fail_bid = new StringBuffer();	
			fail_bid.append("select ano, mid, bidprice\n");
			fail_bid.append("from auction_detail \n");
			fail_bid.append("where ano = ? \n");
			pstmt = conn.prepareStatement(fail_bid.toString());
			pstmt.setString(1,ano);
			rs = pstmt.executeQuery();
			while(rs.next())	//입찰자중 입찰받지 못한 목록 
			{
				if(++cnt_member == 1)	//낙찰자 제외하고 
					continue;
				AuctionDetailDto auctionDetailDto  = new AuctionDetailDto();
				auctionDetailDto.setAno(rs.getInt("ano"));
				auctionDetailDto.setMid(rs.getString("mid"));
				auctionDetailDto.setBidPrice(rs.getInt("bidprice"));
				//회원상세 테이블에서 낙찰자 루키 감소시키고
				StringBuffer fail_bid_member_detail = new StringBuffer();	
				fail_bid_member_detail.append("update member_detail \n");
				fail_bid_member_detail.append("set rookie = rookie + ?");
				fail_bid_member_detail.append("where mid = ?");
				pstmt = conn.prepareStatement(fail_bid_member_detail.toString());
				pstmt.setInt(1,auctionDetailDto.getBidPrice());
				pstmt.setString(2, auctionDetailDto.getMid());
				pstmt.executeUpdate();
				pstmt.close();
				//루키상세 테이블에 낙찰실패 내역 insert 
				StringBuffer fail_bid_rookie_detail = new StringBuffer();	
				fail_bid_rookie_detail.append("insert into rookie_detail(mid, price, paydate, rtype, rdetail)");
				fail_bid_rookie_detail.append("values(?, ?, sysdate, '1', '낙찰실패')");
				pstmt = conn.prepareStatement(fail_bid_rookie_detail.toString());
				pstmt.setString(1, auctionDetailDto.getMid());
				pstmt.setInt(2,auctionDetailDto.getBidPrice());
				pstmt.executeUpdate();
				pstmt.close();
			}
				conn.commit();
				cnt = 1;
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				conn.rollback();
				cnt = 0;
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		} finally {
			DBClose.close(conn, pstmt, rs);
		}
		return cnt;
	}
}
