package com.baseball.auction.service;

import java.util.List;
import com.baseball.auction.model.AuctionDetailDto;

public interface AuctionCategoryService {
	List<AuctionDetailDto> auctionCategoryList(String category1, String category2);
}