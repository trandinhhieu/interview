package com.dongvu.interview.model;

import java.util.Date;

import lombok.Data;

@Data
public class SystemMenu {
    private Long id;
    private String name;
    private String permission;
    private Integer type;
    private Integer sort;
    private Long parentId;
    private String path;
    private String icon;
    private String component;
    private String componentName;
    private Integer status;
    private Boolean visible;
    private Boolean keepAlive;
    private Boolean alwaysShow;
    private String creator;
    private Date createTime;
    private String updater;
    private Date updateTime;
    private Boolean deleted;
    private Long tenantId;
}
