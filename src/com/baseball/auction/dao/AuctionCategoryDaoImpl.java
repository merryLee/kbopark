package com.baseball.auction.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.baseball.auction.model.AuctionDetailDto;
import com.baseball.util.db.DBClose;
import com.baseball.util.db.DBConnection;

public class AuctionCategoryDaoImpl implements AuctionCategoryDao {
	
	private static AuctionCategoryDao auctionCategoryDao;

	static {
		auctionCategoryDao = new AuctionCategoryDaoImpl();
	}
	
	public static AuctionCategoryDao getAuctionCategoryDao() {
		return auctionCategoryDao;
	}

	@Override
	public List<AuctionDetailDto> auctionCategoryList(Map<String, String> map) {
		
	
		List<AuctionDetailDto> list = new ArrayList<AuctionDetailDto>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.makeConnection();
			StringBuffer category_all = new StringBuffer();
			category_all.append("select a_ad.aname, to_char(a_ad.endtime, 'yyyy.mm.dd.hh24.mi.ss') as endtime, to_char(a_ad.starttime, 'yyyy.mm.dd.hh24.mi.ss') as starttime, a_ad.bidprice, a_ad.bidnum, ai.aimage, a_ad.astatus, a_ad.ano\n");
			category_all.append("from auction_image ai,( \n");
			category_all.append("						select a.*, ad.bidprice, ad.bidnum\n");
			category_all.append("						from auction a,( \n");
			category_all.append("										select ano, max(bidprice) as bidprice, count(*) as bidnum \n");
			category_all.append("										from auction_detail \n");
			category_all.append("										group by ano \n");
			category_all.append("										)ad \n");
//			category_all.append("						group by a.astatus \n");				
			category_all.append("						where a.ano = ad.ano(+) \n");
			category_all.append("						)a_ad \n");
			String category1 = map.get("category1");
			String category2 = map.get("category2");
			if(category1.isEmpty())	// 대분류 카테고리가 없으면
			{
				category_all.append("where a_ad.ano = ai.ano(+)\n"); // 전체보기
			}
			else if(category2.isEmpty()) //대분류는 있고 소분류가 없으면
			{
				category_all.append("where a_ad.ano = ai.ano(+) and \n");
				category_all.append("case when a_ad.category1 = ? \n");
				category_all.append(" \n");
				category_all.append(" \n");
			}
			else // 대분류 소분류 둘다 있으면 
			{				
				category_all.append("where a_ad.ano = ai.ano(+) and a_ad.category1 = ? and a_ad.category2 = ? \n");
			}
			category_all.append("order by a_ad.starttime desc\n");	// 기본은 등록시간순으로 
			pstmt = conn.prepareStatement(category_all.toString());
			int idx = 0;
			
			if(!category1.isEmpty())	// 대분류 카테고리가 있고
			{
				pstmt.setString(++idx,category1);
				if(!category2.isEmpty()) //소분류 카테고리도 있으면
				{
					pstmt.setString(++idx,category2);
				}
			}
			
			rs = pstmt.executeQuery();
			int cnt = 0;
			while(rs.next()) {
				System.out.println("카테고리 넥스트");
				AuctionDetailDto auctionDetailDto = new AuctionDetailDto();
				auctionDetailDto.setAname(rs.getString("aname"));
				auctionDetailDto.setEndTime(rs.getString("endtime"));
				auctionDetailDto.setStartTime(rs.getString("starttime"));
				auctionDetailDto.setBidPrice(rs.getInt("bidprice"));
				auctionDetailDto.setBidNum(rs.getInt("bidnum"));
				auctionDetailDto.setAimage(rs.getString("aimage"));
				auctionDetailDto.setAstatus(rs.getInt("astatus"));
				auctionDetailDto.setAno(rs.getInt("ano"));
				
				list.add(auctionDetailDto);				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBClose.close(conn, pstmt, rs);
		}	
		System.out.println("카테고리 사이즈 : " + list.size());
		return list;
	}
}
