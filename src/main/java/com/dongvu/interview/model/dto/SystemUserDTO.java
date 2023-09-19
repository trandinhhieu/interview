package com.dongvu.interview.model.dto;

import lombok.Data;
@Data
public class SystemUserDTO {
	private String id;
    private String username;
    private String password;
    private String nickname;
    private String remark;
    private String deptId;
    private String postIds;
    private String email;
    private String mobile;
    private String sex;
    private String avatar;
    private String status;
    private String loginIp;
    private String loginDate;
    private String creator;
    private String createTime;
    private String updater;
    private String updateTime;
    private String deleted;
    private String tenantId;
}
