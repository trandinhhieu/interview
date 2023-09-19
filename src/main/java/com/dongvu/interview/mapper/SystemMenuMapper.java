package com.dongvu.interview.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.dongvu.interview.model.SystemMenu;

@Mapper
public interface SystemMenuMapper {
    List<SystemMenu> getMenusByParentIdAndUserId(Long parentId, Long userId);
}
