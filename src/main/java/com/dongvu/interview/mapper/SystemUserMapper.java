package com.dongvu.interview.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.dongvu.interview.model.SystemUser;

@Mapper
public interface SystemUserMapper {

    void insert(SystemUser user);

    SystemUser findById(long id);

    List<SystemUser> findAll();

    void update(SystemUser user);

    void delete(long id);

    int countByUsername(String username);

    int countByEmail(String email);

    List<SystemUser> findUsersBySearchCriteria(String search);

    SystemUser findByUsername(String username);

    SystemUser findByEmail(String email);

}
