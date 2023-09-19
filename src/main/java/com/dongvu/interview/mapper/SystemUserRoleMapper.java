package com.dongvu.interview.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.dongvu.interview.model.SystemUserRole;

@Mapper
public interface SystemUserRoleMapper {
    void insert(SystemUserRole userRole);

	void softDeleteByUserId(Long userId);
    
}
