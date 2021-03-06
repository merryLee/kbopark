package com.baseball.auction.dao;

import java.util.List;
import java.util.Map;

import com.baseball.auction.model.AuctionDetailDto;

public interface AuctionBidDetailDao {
	List<AuctionDetailDto> auctionBidDetailList(Map<String, String> map);
	int totalBidCount(Map<String, String> map);
}
