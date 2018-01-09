package com.baseball.auction.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.baseball.auction.dao.AuctionBidDetailDaoImpl;
import com.baseball.auction.model.AuctionDetailDto;
import com.baseball.auction.util.DetailPageNavigation;
import com.baseball.util.Constance;
import com.kitri.common.dao.CommonDaoImpl;

public class AuctionBidDetailServiceImpl implements AuctionBidDetailService {

	private static AuctionBidDetailService auctionBidDetailService;
	
	static {
		auctionBidDetailService = new AuctionBidDetailServiceImpl();
	}
	
	public static AuctionBidDetailService getAuctionBidDetailService() {
		return auctionBidDetailService;
	}
	
	@Override
	public List<AuctionDetailDto> auctionBidDetailList(int ano, int pg) {
		
		int end = pg * Constance.CATEGORY_LIST_SIZE;
		int start = end - Constance.CATEGORY_LIST_SIZE;
		Map<String, String> map = new HashMap<String, String>();
		map.put("ano", ano + "");
		map.put("start", start + "");
		map.put("end",  end + "");
		return AuctionBidDetailDaoImpl.getAuctionBidDetailDao().auctionBidDetailList(map);		
	}

	@Override
	public DetailPageNavigation makePageNavigation(int ano, int pg) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("ano", ano + "");
		map.put("pg", pg + "");
		
		DetailPageNavigation detailPageNavigation = new DetailPageNavigation();
		int pgSize = Constance.CATEGORY_PAGE_SIZE;
		detailPageNavigation.setPageNo(pg);
		int totalArticleCount = AuctionBidDetailDaoImpl.getAuctionBidDetailDao().totalBidCount(map);
		detailPageNavigation.setTotalArticleCount(totalArticleCount);
		
		return null;
	}

}
