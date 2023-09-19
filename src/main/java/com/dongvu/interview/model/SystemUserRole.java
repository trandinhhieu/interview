package com.dongvu.interview.model;

import java.util.Date;

import lombok.Data;

@Data
public class SystemUserRole {
    private Long id;
    private Long userId;
    private Long roleId;
    private String creator;
    private Date createTime;
    private String updater;
    private Date updateTime;
    private Boolean deleted;
    private Long tenantId;
}
