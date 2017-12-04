package com.baseball.schedule.service;

import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

import com.baseball.schedule.scheduleDto.ScheduleDto;
import com.baseball.schedule.scheduledao.ScheduleDao;
import com.baseball.schedule.scheduledao.ScheduleDaoImpl;

public class ScheduleServiceImpl implements ScheduleService {
	
	private static ScheduleService scheduleService;
	
	static {
		
		scheduleService = new ScheduleServiceImpl();
		
	}
	
	
	private ScheduleServiceImpl() {
	}
	

	public static ScheduleService getScheduleService() {
		return scheduleService;
	}

	@Override
	public ScheduleDto viewSchedule() {
		return ScheduleDaoImpl.getScheduleDao().getSchedule();
	}

}
