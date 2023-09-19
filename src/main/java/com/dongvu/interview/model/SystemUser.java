package com.dongvu.interview.model;

import java.util.Date;
import java.util.Set;

import lombok.Data;
@Data
public class SystemUser {
    private Long id;
    private String username;
    private String password;
    private String nickname;
    private String remark;
    private Long deptId;
    private String postIds;
    private String email;
    private String mobile;
    private Integer sex;
    private String avatar;
    private Integer status;
    private String loginIp;
    private Date loginDate;
    private String creator;
    private Date createTime;
    private String updater;
    private Date updateTime;
    private Boolean deleted;
    private Long tenantId;
    private Set<SystemUserRole> userRoles;
}