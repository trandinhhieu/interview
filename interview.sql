-- 将以下数据导入MySQL并完成下列操作
-- 使用JDK1.8 SpringBoot, MyBatis，MySQL, Redis构建后端服务，提供以下接口
-- 1. 新增、修改、删除、查询用户接口
-- 2. system_users、system_user_role、system_role、system_role_menu、system_menu表关联返回用户名称、角色名称及菜单名称
-- 3. 根据用户ID返回当前用户可见菜单（要求返回Tree）
-- 4. 调用接口3的返回值需要缓存至redis并设置1分钟过期，重复调用时优先返回缓存内容

-- 完成以上操作后提供单元测试并打印返回结果

create table interview.system_dept
(
    id             bigint auto_increment comment '部门id'
        primary key,
    name           varchar(30) default ''                not null comment '部门名称',
    parent_id      bigint      default 0                 not null comment '父部门id',
    sort           int         default 0                 not null comment '显示顺序',
    leader_user_id bigint                                null comment '负责人',
    phone          varchar(11)                           null comment '联系电话',
    email          varchar(50)                           null comment '邮箱',
    status         tinyint                               not null comment '部门状态（0正常 1停用）',
    creator        varchar(64) default ''                null comment '创建者',
    create_time    datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater        varchar(64) default ''                null comment '更新者',
    update_time    datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted        bit         default b'0'              not null comment '是否删除',
    tenant_id      bigint      default 0                 not null comment '租户编号'
)
    comment '部门表' collate = utf8mb4_unicode_ci;

create table interview.system_dict_data
(
    id          bigint auto_increment comment '字典编码'
        primary key,
    sort        int          default 0                 not null comment '字典排序',
    label       varchar(100) default ''                not null comment '字典标签',
    value       varchar(100) default ''                not null comment '字典键值',
    dict_type   varchar(100) default ''                not null comment '字典类型',
    status      tinyint      default 0                 not null comment '状态（0正常 1停用）',
    color_type  varchar(100) default ''                null comment '颜色类型',
    css_class   varchar(100) default ''                null comment 'css 样式',
    remark      varchar(500)                           null comment '备注',
    creator     varchar(64)  default ''                null comment '创建者',
    create_time datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64)  default ''                null comment '更新者',
    update_time datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit          default b'0'              not null comment '是否删除'
)
    comment '字典数据表' collate = utf8mb4_unicode_ci;

create table interview.system_dict_type
(
    id           bigint auto_increment comment '字典主键'
        primary key,
    name         varchar(100) default ''                not null comment '字典名称',
    type         varchar(100) default ''                not null comment '字典类型',
    status       tinyint      default 0                 not null comment '状态（0正常 1停用）',
    remark       varchar(500)                           null comment '备注',
    creator      varchar(64)  default ''                null comment '创建者',
    create_time  datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater      varchar(64)  default ''                null comment '更新者',
    update_time  datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted      bit          default b'0'              not null comment '是否删除',
    deleted_time datetime                               null comment '删除时间',
    constraint dict_type
        unique (type)
)
    comment '字典类型表' collate = utf8mb4_unicode_ci;

create table interview.system_error_code
(
    id               bigint auto_increment comment '错误码编号'
        primary key,
    type             tinyint      default 0                 not null comment '错误码类型',
    application_name varchar(50)                            not null comment '应用名',
    code             int          default 0                 not null comment '错误码编码',
    message          varchar(512) default ''                not null comment '错误码错误提示',
    memo             varchar(512) default ''                null comment '备注',
    creator          varchar(64)  default ''                null comment '创建者',
    create_time      datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater          varchar(64)  default ''                null comment '更新者',
    update_time      datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted          bit          default b'0'              not null comment '是否删除'
)
    comment '错误码表' collate = utf8mb4_unicode_ci;

create table interview.system_login_log
(
    id          bigint auto_increment comment '访问ID'
        primary key,
    log_type    bigint                                not null comment '日志类型',
    trace_id    varchar(64) default ''                not null comment '链路追踪编号',
    user_id     bigint      default 0                 not null comment '用户编号',
    user_type   tinyint     default 0                 not null comment '用户类型',
    username    varchar(50) default ''                not null comment '用户账号',
    result      tinyint                               not null comment '登陆结果',
    user_ip     varchar(50)                           not null comment '用户 IP',
    user_agent  varchar(512)                          not null comment '浏览器 UA',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除',
    tenant_id   bigint      default 0                 not null comment '租户编号'
)
    comment '系统访问记录' collate = utf8mb4_unicode_ci;

create table interview.system_mail_account
(
    id          bigint auto_increment comment '主键'
        primary key,
    mail        varchar(255)                          not null comment '邮箱',
    username    varchar(255)                          not null comment '用户名',
    password    varchar(255)                          not null comment '密码',
    host        varchar(255)                          not null comment 'SMTP 服务器域名',
    port        int                                   not null comment 'SMTP 服务器端口',
    ssl_enable  bit         default b'0'              not null comment '是否开启 SSL',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除'
)
    comment '邮箱账号表' collate = utf8mb4_unicode_ci;

create table interview.system_mail_log
(
    id                bigint auto_increment comment '编号'
        primary key,
    user_id           bigint                                null comment '用户编号',
    user_type         tinyint                               null comment '用户类型',
    to_mail           varchar(255)                          not null comment '接收邮箱地址',
    account_id        bigint                                not null comment '邮箱账号编号',
    from_mail         varchar(255)                          not null comment '发送邮箱地址',
    template_id       bigint                                not null comment '模板编号',
    template_code     varchar(63)                           not null comment '模板编码',
    template_nickname varchar(255)                          null comment '模版发送人名称',
    template_title    varchar(255)                          not null comment '邮件标题',
    template_content  varchar(10240)                        not null comment '邮件内容',
    template_params   varchar(255)                          not null comment '邮件参数',
    send_status       tinyint     default 0                 not null comment '发送状态',
    send_time         datetime                              null comment '发送时间',
    send_message_id   varchar(255)                          null comment '发送返回的消息 ID',
    send_exception    varchar(4096)                         null comment '发送异常',
    creator           varchar(64) default ''                null comment '创建者',
    create_time       datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater           varchar(64) default ''                null comment '更新者',
    update_time       datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted           bit         default b'0'              not null comment '是否删除'
)
    comment '邮件日志表' collate = utf8mb4_unicode_ci;

create table interview.system_mail_template
(
    id          bigint auto_increment comment '编号'
        primary key,
    name        varchar(63)                           not null comment '模板名称',
    code        varchar(63)                           not null comment '模板编码',
    account_id  bigint                                not null comment '发送的邮箱账号编号',
    nickname    varchar(255)                          null comment '发送人名称',
    title       varchar(255)                          not null comment '模板标题',
    content     varchar(10240)                        not null comment '模板内容',
    params      varchar(255)                          not null comment '参数数组',
    status      tinyint                               not null comment '开启状态',
    remark      varchar(255)                          null comment '备注',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除'
)
    comment '邮件模版表' collate = utf8mb4_unicode_ci;

create table interview.system_menu
(
    id             bigint auto_increment comment '菜单ID'
        primary key,
    name           varchar(50)                            not null comment '菜单名称',
    permission     varchar(100) default ''                not null comment '权限标识',
    type           tinyint                                not null comment '菜单类型',
    sort           int          default 0                 not null comment '显示顺序',
    parent_id      bigint       default 0                 not null comment '父菜单ID',
    path           varchar(200) default ''                null comment '路由地址',
    icon           varchar(100) default '#'               null comment '菜单图标',
    component      varchar(255)                           null comment '组件路径',
    component_name varchar(255)                           null comment '组件名',
    status         tinyint      default 0                 not null comment '菜单状态',
    visible        bit          default b'1'              not null comment '是否可见',
    keep_alive     bit          default b'1'              not null comment '是否缓存',
    always_show    bit          default b'1'              not null comment '是否总是显示',
    creator        varchar(64)  default ''                null comment '创建者',
    create_time    datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater        varchar(64)  default ''                null comment '更新者',
    update_time    datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted        bit          default b'0'              not null comment '是否删除'
)
    comment '菜单权限表' collate = utf8mb4_unicode_ci;

create table interview.system_notice
(
    id          bigint auto_increment comment '公告ID'
        primary key,
    title       varchar(50)                           not null comment '公告标题',
    content     text                                  not null comment '公告内容',
    type        tinyint                               not null comment '公告类型（1通知 2公告）',
    status      tinyint     default 0                 not null comment '公告状态（0正常 1关闭）',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除',
    tenant_id   bigint      default 0                 not null comment '租户编号'
)
    comment '通知公告表' collate = utf8mb4_unicode_ci;

create table interview.system_notify_message
(
    id                bigint auto_increment comment '用户ID'
        primary key,
    user_id           bigint                                not null comment '用户id',
    user_type         tinyint                               not null comment '用户类型',
    template_id       bigint                                not null comment '模版编号',
    template_code     varchar(64)                           not null comment '模板编码',
    template_nickname varchar(63)                           not null comment '模版发送人名称',
    template_content  varchar(1024)                         not null comment '模版内容',
    template_type     int                                   not null comment '模版类型',
    template_params   varchar(255)                          not null comment '模版参数',
    read_status       bit                                   not null comment '是否已读',
    read_time         datetime                              null comment '阅读时间',
    creator           varchar(64) default ''                null comment '创建者',
    create_time       datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater           varchar(64) default ''                null comment '更新者',
    update_time       datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted           bit         default b'0'              not null comment '是否删除',
    tenant_id         bigint      default 0                 not null comment '租户编号'
)
    comment '站内信消息表' collate = utf8mb4_unicode_ci;

create table interview.system_notify_template
(
    id          bigint auto_increment comment '主键'
        primary key,
    name        varchar(63)                           not null comment '模板名称',
    code        varchar(64)                           not null comment '模版编码',
    nickname    varchar(255)                          not null comment '发送人名称',
    content     varchar(1024)                         not null comment '模版内容',
    type        tinyint                               not null comment '类型',
    params      varchar(255)                          null comment '参数数组',
    status      tinyint                               not null comment '状态',
    remark      varchar(255)                          null comment '备注',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除'
)
    comment '站内信模板表' collate = utf8mb4_unicode_ci;

create table interview.system_oauth2_access_token
(
    id            bigint auto_increment comment '编号'
        primary key,
    user_id       bigint                                not null comment '用户编号',
    user_type     tinyint                               not null comment '用户类型',
    access_token  varchar(255)                          not null comment '访问令牌',
    refresh_token varchar(32)                           not null comment '刷新令牌',
    client_id     varchar(255)                          not null comment '客户端编号',
    scopes        varchar(255)                          null comment '授权范围',
    expires_time  datetime                              not null comment '过期时间',
    creator       varchar(64) default ''                null comment '创建者',
    create_time   datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater       varchar(64) default ''                null comment '更新者',
    update_time   datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted       bit         default b'0'              not null comment '是否删除',
    tenant_id     bigint      default 0                 not null comment '租户编号'
)
    comment 'OAuth2 访问令牌' collate = utf8mb4_unicode_ci;

create table interview.system_oauth2_approve
(
    id           bigint auto_increment comment '编号'
        primary key,
    user_id      bigint                                 not null comment '用户编号',
    user_type    tinyint                                not null comment '用户类型',
    client_id    varchar(255)                           not null comment '客户端编号',
    scope        varchar(255) default ''                not null comment '授权范围',
    approved     bit          default b'0'              not null comment '是否接受',
    expires_time datetime                               not null comment '过期时间',
    creator      varchar(64)  default ''                null comment '创建者',
    create_time  datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater      varchar(64)  default ''                null comment '更新者',
    update_time  datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted      bit          default b'0'              not null comment '是否删除',
    tenant_id    bigint       default 0                 not null comment '租户编号'
)
    comment 'OAuth2 批准表' collate = utf8mb4_unicode_ci;

create table interview.system_oauth2_client
(
    id                             bigint auto_increment comment '编号'
        primary key,
    client_id                      varchar(255)                          not null comment '客户端编号',
    secret                         varchar(255)                          not null comment '客户端密钥',
    name                           varchar(255)                          not null comment '应用名',
    logo                           varchar(255)                          not null comment '应用图标',
    description                    varchar(255)                          null comment '应用描述',
    status                         tinyint                               not null comment '状态',
    access_token_validity_seconds  int                                   not null comment '访问令牌的有效期',
    refresh_token_validity_seconds int                                   not null comment '刷新令牌的有效期',
    redirect_uris                  varchar(255)                          not null comment '可重定向的 URI 地址',
    authorized_grant_types         varchar(255)                          not null comment '授权类型',
    scopes                         varchar(255)                          null comment '授权范围',
    auto_approve_scopes            varchar(255)                          null comment '自动通过的授权范围',
    authorities                    varchar(255)                          null comment '权限',
    resource_ids                   varchar(255)                          null comment '资源',
    additional_information         varchar(4096)                         null comment '附加信息',
    creator                        varchar(64) default ''                null comment '创建者',
    create_time                    datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater                        varchar(64) default ''                null comment '更新者',
    update_time                    datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted                        bit         default b'0'              not null comment '是否删除'
)
    comment 'OAuth2 客户端表' collate = utf8mb4_unicode_ci;

create table interview.system_oauth2_code
(
    id           bigint auto_increment comment '编号'
        primary key,
    user_id      bigint                                 not null comment '用户编号',
    user_type    tinyint                                not null comment '用户类型',
    code         varchar(32)                            not null comment '授权码',
    client_id    varchar(255)                           not null comment '客户端编号',
    scopes       varchar(255) default ''                null comment '授权范围',
    expires_time datetime                               not null comment '过期时间',
    redirect_uri varchar(255)                           null comment '可重定向的 URI 地址',
    state        varchar(255) default ''                not null comment '状态',
    creator      varchar(64)  default ''                null comment '创建者',
    create_time  datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater      varchar(64)  default ''                null comment '更新者',
    update_time  datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted      bit          default b'0'              not null comment '是否删除',
    tenant_id    bigint       default 0                 not null comment '租户编号'
)
    comment 'OAuth2 授权码表' collate = utf8mb4_unicode_ci;

create table interview.system_oauth2_refresh_token
(
    id            bigint auto_increment comment '编号'
        primary key,
    user_id       bigint                                not null comment '用户编号',
    refresh_token varchar(32)                           not null comment '刷新令牌',
    user_type     tinyint                               not null comment '用户类型',
    client_id     varchar(255)                          not null comment '客户端编号',
    scopes        varchar(255)                          null comment '授权范围',
    expires_time  datetime                              not null comment '过期时间',
    creator       varchar(64) default ''                null comment '创建者',
    create_time   datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater       varchar(64) default ''                null comment '更新者',
    update_time   datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted       bit         default b'0'              not null comment '是否删除',
    tenant_id     bigint      default 0                 not null comment '租户编号'
)
    comment 'OAuth2 刷新令牌' collate = utf8mb4_unicode_ci;

create table interview.system_operate_log
(
    id               bigint auto_increment comment '日志主键'
        primary key,
    trace_id         varchar(64)   default ''                not null comment '链路追踪编号',
    user_id          bigint                                  not null comment '用户编号',
    user_type        tinyint       default 0                 not null comment '用户类型',
    module           varchar(50)                             not null comment '模块标题',
    name             varchar(50)                             not null comment '操作名',
    type             bigint        default 0                 not null comment '操作分类',
    content          varchar(2000) default ''                not null comment '操作内容',
    exts             varchar(512)  default ''                not null comment '拓展字段',
    request_method   varchar(16)   default ''                null comment '请求方法名',
    request_url      varchar(255)  default ''                null comment '请求地址',
    user_ip          varchar(50)                             null comment '用户 IP',
    user_agent       varchar(200)                            null comment '浏览器 UA',
    java_method      varchar(512)  default ''                not null comment 'Java 方法名',
    java_method_args varchar(8000) default ''                null comment 'Java 方法的参数',
    start_time       datetime                                not null comment '操作时间',
    duration         int                                     not null comment '执行时长',
    result_code      int           default 0                 not null comment '结果码',
    result_msg       varchar(512)  default ''                null comment '结果提示',
    result_data      varchar(4000) default ''                null comment '结果数据',
    creator          varchar(64)   default ''                null comment '创建者',
    create_time      datetime      default CURRENT_TIMESTAMP not null comment '创建时间',
    updater          varchar(64)   default ''                null comment '更新者',
    update_time      datetime      default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted          bit           default b'0'              not null comment '是否删除',
    tenant_id        bigint        default 0                 not null comment '租户编号'
)
    comment '操作日志记录' collate = utf8mb4_unicode_ci;

create table interview.system_post
(
    id          bigint auto_increment comment '岗位ID'
        primary key,
    code        varchar(64)                           not null comment '岗位编码',
    name        varchar(50)                           not null comment '岗位名称',
    sort        int                                   not null comment '显示顺序',
    status      tinyint                               not null comment '状态（0正常 1停用）',
    remark      varchar(500)                          null comment '备注',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除',
    tenant_id   bigint      default 0                 not null comment '租户编号'
)
    comment '岗位信息表' collate = utf8mb4_unicode_ci;

create table interview.system_role
(
    id                  bigint auto_increment comment '角色ID'
        primary key,
    name                varchar(30)                            not null comment '角色名称',
    code                varchar(100)                           not null comment '角色权限字符串',
    sort                int                                    not null comment '显示顺序',
    data_scope          tinyint      default 1                 not null comment '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
    data_scope_dept_ids varchar(500) default ''                not null comment '数据范围(指定部门数组)',
    status              tinyint                                not null comment '角色状态（0正常 1停用）',
    type                tinyint                                not null comment '角色类型',
    remark              varchar(500)                           null comment '备注',
    creator             varchar(64)  default ''                null comment '创建者',
    create_time         datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater             varchar(64)  default ''                null comment '更新者',
    update_time         datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted             bit          default b'0'              not null comment '是否删除',
    tenant_id           bigint       default 0                 not null comment '租户编号'
)
    comment '角色信息表' collate = utf8mb4_unicode_ci;

create table interview.system_role_menu
(
    id          bigint auto_increment comment '自增编号'
        primary key,
    role_id     bigint                                not null comment '角色ID',
    menu_id     bigint                                not null comment '菜单ID',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除',
    tenant_id   bigint      default 0                 not null comment '租户编号'
)
    comment '角色和菜单关联表' collate = utf8mb4_unicode_ci;

create table interview.system_sensitive_word
(
    id          bigint auto_increment comment '编号'
        primary key,
    name        varchar(255)                          not null comment '敏感词',
    description varchar(512)                          null comment '描述',
    tags        varchar(255)                          null comment '标签数组',
    status      tinyint                               not null comment '状态',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除'
)
    comment '敏感词' collate = utf8mb4_unicode_ci;

create table interview.system_sms_channel
(
    id           bigint auto_increment comment '编号'
        primary key,
    signature    varchar(12)                           not null comment '短信签名',
    code         varchar(63)                           not null comment '渠道编码',
    status       tinyint                               not null comment '开启状态',
    remark       varchar(255)                          null comment '备注',
    api_key      varchar(128)                          not null comment '短信 API 的账号',
    api_secret   varchar(128)                          null comment '短信 API 的秘钥',
    callback_url varchar(255)                          null comment '短信发送回调 URL',
    creator      varchar(64) default ''                null comment '创建者',
    create_time  datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater      varchar(64) default ''                null comment '更新者',
    update_time  datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted      bit         default b'0'              not null comment '是否删除'
)
    comment '短信渠道' collate = utf8mb4_unicode_ci;

create table interview.system_sms_code
(
    id          bigint auto_increment comment '编号'
        primary key,
    mobile      varchar(11)                           not null comment '手机号',
    code        varchar(6)                            not null comment '验证码',
    create_ip   varchar(15)                           not null comment '创建 IP',
    scene       tinyint                               not null comment '发送场景',
    today_index tinyint                               not null comment '今日发送的第几条',
    used        tinyint                               not null comment '是否使用',
    used_time   datetime                              null comment '使用时间',
    used_ip     varchar(255)                          null comment '使用 IP',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除',
    tenant_id   bigint      default 0                 not null comment '租户编号'
)
    comment '手机验证码' collate = utf8mb4_unicode_ci;

create index idx_mobile
    on interview.system_sms_code (mobile)
    comment '手机号';

create table interview.system_sms_log
(
    id               bigint auto_increment comment '编号'
        primary key,
    channel_id       bigint                                not null comment '短信渠道编号',
    channel_code     varchar(63)                           not null comment '短信渠道编码',
    template_id      bigint                                not null comment '模板编号',
    template_code    varchar(63)                           not null comment '模板编码',
    template_type    tinyint                               not null comment '短信类型',
    template_content varchar(255)                          not null comment '短信内容',
    template_params  varchar(255)                          not null comment '短信参数',
    api_template_id  varchar(63)                           not null comment '短信 API 的模板编号',
    mobile           varchar(11)                           not null comment '手机号',
    user_id          bigint                                null comment '用户编号',
    user_type        tinyint                               null comment '用户类型',
    send_status      tinyint     default 0                 not null comment '发送状态',
    send_time        datetime                              null comment '发送时间',
    send_code        int                                   null comment '发送结果的编码',
    send_msg         varchar(255)                          null comment '发送结果的提示',
    api_send_code    varchar(63)                           null comment '短信 API 发送结果的编码',
    api_send_msg     varchar(255)                          null comment '短信 API 发送失败的提示',
    api_request_id   varchar(255)                          null comment '短信 API 发送返回的唯一请求 ID',
    api_serial_no    varchar(255)                          null comment '短信 API 发送返回的序号',
    receive_status   tinyint     default 0                 not null comment '接收状态',
    receive_time     datetime                              null comment '接收时间',
    api_receive_code varchar(63)                           null comment 'API 接收结果的编码',
    api_receive_msg  varchar(255)                          null comment 'API 接收结果的说明',
    creator          varchar(64) default ''                null comment '创建者',
    create_time      datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater          varchar(64) default ''                null comment '更新者',
    update_time      datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted          bit         default b'0'              not null comment '是否删除'
)
    comment '短信日志' collate = utf8mb4_unicode_ci;

create table interview.system_sms_template
(
    id              bigint auto_increment comment '编号'
        primary key,
    type            tinyint                               not null comment '短信签名',
    status          tinyint                               not null comment '开启状态',
    code            varchar(63)                           not null comment '模板编码',
    name            varchar(63)                           not null comment '模板名称',
    content         varchar(255)                          not null comment '模板内容',
    params          varchar(255)                          not null comment '参数数组',
    remark          varchar(255)                          null comment '备注',
    api_template_id varchar(63)                           not null comment '短信 API 的模板编号',
    channel_id      bigint                                not null comment '短信渠道编号',
    channel_code    varchar(63)                           not null comment '短信渠道编码',
    creator         varchar(64) default ''                null comment '创建者',
    create_time     datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater         varchar(64) default ''                null comment '更新者',
    update_time     datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted         bit         default b'0'              not null comment '是否删除'
)
    comment '短信模板' collate = utf8mb4_unicode_ci;

create table interview.system_social_user
(
    id             bigint unsigned auto_increment comment '主键(自增策略)'
        primary key,
    type           tinyint                               not null comment '社交平台的类型',
    openid         varchar(32)                           not null comment '社交 openid',
    token          varchar(256)                          null comment '社交 token',
    raw_token_info varchar(1024)                         not null comment '原始 Token 数据，一般是 JSON 格式',
    nickname       varchar(32)                           not null comment '用户昵称',
    avatar         varchar(255)                          null comment '用户头像',
    raw_user_info  varchar(1024)                         not null comment '原始用户数据，一般是 JSON 格式',
    code           varchar(256)                          not null comment '最后一次的认证 code',
    state          varchar(256)                          null comment '最后一次的认证 state',
    creator        varchar(64) default ''                null comment '创建者',
    create_time    datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater        varchar(64) default ''                null comment '更新者',
    update_time    datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted        bit         default b'0'              not null comment '是否删除',
    tenant_id      bigint      default 0                 not null comment '租户编号'
)
    comment '社交用户表' collate = utf8mb4_unicode_ci;

create table interview.system_social_user_bind
(
    id             bigint unsigned auto_increment comment '主键(自增策略)'
        primary key,
    user_id        bigint                                not null comment '用户编号',
    user_type      tinyint                               not null comment '用户类型',
    social_type    tinyint                               not null comment '社交平台的类型',
    social_user_id bigint                                not null comment '社交用户的编号',
    creator        varchar(64) default ''                null comment '创建者',
    create_time    datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater        varchar(64) default ''                null comment '更新者',
    update_time    datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted        bit         default b'0'              not null comment '是否删除',
    tenant_id      bigint      default 0                 not null comment '租户编号'
)
    comment '社交绑定表' collate = utf8mb4_unicode_ci;

create table interview.system_tenant
(
    id              bigint auto_increment comment '租户编号'
        primary key,
    name            varchar(30)                            not null comment '租户名',
    contact_user_id bigint                                 null comment '联系人的用户编号',
    contact_name    varchar(30)                            not null comment '联系人',
    contact_mobile  varchar(500)                           null comment '联系手机',
    status          tinyint      default 0                 not null comment '租户状态（0正常 1停用）',
    domain          varchar(256) default ''                null comment '绑定域名',
    package_id      bigint                                 not null comment '租户套餐编号',
    expire_time     datetime                               not null comment '过期时间',
    account_count   int                                    not null comment '账号数量',
    creator         varchar(64)  default ''                not null comment '创建者',
    create_time     datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater         varchar(64)  default ''                null comment '更新者',
    update_time     datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted         bit          default b'0'              not null comment '是否删除'
)
    comment '租户表' collate = utf8mb4_unicode_ci;

create table interview.system_tenant_package
(
    id          bigint auto_increment comment '套餐编号'
        primary key,
    name        varchar(30)                            not null comment '套餐名',
    status      tinyint      default 0                 not null comment '租户状态（0正常 1停用）',
    remark      varchar(256) default ''                null comment '备注',
    menu_ids    varchar(2048)                          not null comment '关联的菜单编号',
    creator     varchar(64)  default ''                not null comment '创建者',
    create_time datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64)  default ''                null comment '更新者',
    update_time datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit          default b'0'              not null comment '是否删除'
)
    comment '租户套餐表' collate = utf8mb4_unicode_ci;

create table interview.system_user_post
(
    id          bigint auto_increment comment 'id'
        primary key,
    user_id     bigint      default 0                 not null comment '用户ID',
    post_id     bigint      default 0                 not null comment '岗位ID',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              not null comment '是否删除',
    tenant_id   bigint      default 0                 not null comment '租户编号'
)
    comment '用户岗位表' collate = utf8mb4_unicode_ci;

create table interview.system_user_role
(
    id          bigint auto_increment comment '自增编号'
        primary key,
    user_id     bigint                                not null comment '用户ID',
    role_id     bigint                                not null comment '角色ID',
    creator     varchar(64) default ''                null comment '创建者',
    create_time datetime    default CURRENT_TIMESTAMP null comment '创建时间',
    updater     varchar(64) default ''                null comment '更新者',
    update_time datetime    default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit         default b'0'              null comment '是否删除',
    tenant_id   bigint      default 0                 not null comment '租户编号'
)
    comment '用户和角色关联表' collate = utf8mb4_unicode_ci;

create table interview.system_users
(
    id          bigint auto_increment comment '用户ID'
        primary key,
    username    varchar(30)                            not null comment '用户账号',
    password    varchar(100) default ''                not null comment '密码',
    nickname    varchar(30)                            not null comment '用户昵称',
    remark      varchar(500)                           null comment '备注',
    dept_id     bigint                                 null comment '部门ID',
    post_ids    varchar(255)                           null comment '岗位编号数组',
    email       varchar(50)  default ''                null comment '用户邮箱',
    mobile      varchar(11)  default ''                null comment '手机号码',
    sex         tinyint      default 0                 null comment '用户性别',
    avatar      varchar(512) default ''                null comment '头像地址',
    status      tinyint      default 0                 not null comment '帐号状态（0正常 1停用）',
    login_ip    varchar(50)  default ''                null comment '最后登录IP',
    login_date  datetime                               null comment '最后登录时间',
    creator     varchar(64)  default ''                null comment '创建者',
    create_time datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updater     varchar(64)  default ''                null comment '更新者',
    update_time datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    deleted     bit          default b'0'              not null comment '是否删除',
    tenant_id   bigint       default 0                 not null comment '租户编号',
    constraint idx_username
        unique (username, update_time, tenant_id)
)
    comment '用户信息表' collate = utf8mb4_unicode_ci;

INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (100, '芋道源码', 0, 0, 1, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1',
        '2022-06-19 00:29:10', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (101, '深圳总公司', 100, 1, 104, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1',
        '2022-05-16 20:25:23', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (102, '长沙分公司', 100, 2, null, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '',
        '2021-12-15 05:01:40', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (103, '研发部门', 101, 1, 104, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '103',
        '2022-01-14 01:04:14', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (104, '市场部门', 101, 2, null, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '',
        '2021-12-15 05:01:38', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (105, '测试部门', 101, 3, null, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1',
        '2022-05-16 20:25:15', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (106, '财务部门', 101, 4, 103, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '103',
        '2022-01-15 21:32:22', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (107, '运维部门', 101, 5, null, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '',
        '2021-12-15 05:01:33', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (108, '市场部门', 102, 1, null, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1',
        '2022-02-16 08:35:45', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (109, '财务部门', 102, 2, null, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '',
        '2021-12-15 05:01:29', false, 1);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (110, '新部门', 0, 1, null, null, null, 0, '110', '2022-02-23 20:46:30', '110', '2022-02-23 20:46:30', false,
        121);
INSERT INTO interview.system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (111, '顶级部门', 0, 1, null, null, null, 0, '113', '2022-03-07 21:44:50', '113', '2022-03-07 21:44:50', false,
        122);

INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1, 1, '男', '1', 'system_user_sex', 0, 'default', 'A', '性别男', 'admin', '2021-01-05 17:03:48', '1',
        '2022-03-29 00:14:39', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (2, 2, '女', '2', 'system_user_sex', 1, 'success', '', '性别女', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 01:30:51', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (8, 1, '正常', '1', 'infra_job_status', 0, 'success', '', '正常状态', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 19:33:38', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (9, 2, '暂停', '2', 'infra_job_status', 0, 'danger', '', '停用状态', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 19:33:45', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (12, 1, '系统内置', '1', 'infra_config_type', 0, 'danger', '', '参数类型 - 系统内置', 'admin',
        '2021-01-05 17:03:48', '1', '2022-02-16 19:06:02', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (13, 2, '自定义', '2', 'infra_config_type', 0, 'primary', '', '参数类型 - 自定义', 'admin',
        '2021-01-05 17:03:48', '1', '2022-02-16 19:06:07', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (14, 1, '通知', '1', 'system_notice_type', 0, 'success', '', '通知', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 13:05:57', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (15, 2, '公告', '2', 'system_notice_type', 0, 'info', '', '公告', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 13:06:01', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (16, 0, '其它', '0', 'system_operate_type', 0, 'default', '', '其它操作', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 09:32:46', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (17, 1, '查询', '1', 'system_operate_type', 0, 'info', '', '查询操作', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 09:33:16', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (18, 2, '新增', '2', 'system_operate_type', 0, 'primary', '', '新增操作', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 09:33:13', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (19, 3, '修改', '3', 'system_operate_type', 0, 'warning', '', '修改操作', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 09:33:22', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (20, 4, '删除', '4', 'system_operate_type', 0, 'danger', '', '删除操作', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 09:33:27', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (22, 5, '导出', '5', 'system_operate_type', 0, 'default', '', '导出操作', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 09:33:32', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (23, 6, '导入', '6', 'system_operate_type', 0, 'default', '', '导入操作', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 09:33:35', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (27, 1, '开启', '0', 'common_status', 0, 'primary', '', '开启状态', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 08:00:39', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (28, 2, '关闭', '1', 'common_status', 0, 'info', '', '关闭状态', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 08:00:44', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (29, 1, '目录', '1', 'system_menu_type', 0, '', '', '目录', 'admin', '2021-01-05 17:03:48', '',
        '2022-02-01 16:43:45', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (30, 2, '菜单', '2', 'system_menu_type', 0, '', '', '菜单', 'admin', '2021-01-05 17:03:48', '',
        '2022-02-01 16:43:41', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (31, 3, '按钮', '3', 'system_menu_type', 0, '', '', '按钮', 'admin', '2021-01-05 17:03:48', '',
        '2022-02-01 16:43:39', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (32, 1, '内置', '1', 'system_role_type', 0, 'danger', '', '内置角色', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 13:02:08', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (33, 2, '自定义', '2', 'system_role_type', 0, 'primary', '', '自定义角色', 'admin', '2021-01-05 17:03:48', '1',
        '2022-02-16 13:02:12', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (34, 1, '全部数据权限', '1', 'system_data_scope', 0, '', '', '全部数据权限', 'admin', '2021-01-05 17:03:48', '',
        '2022-02-01 16:47:17', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (35, 2, '指定部门数据权限', '2', 'system_data_scope', 0, '', '', '指定部门数据权限', 'admin',
        '2021-01-05 17:03:48', '', '2022-02-01 16:47:18', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (36, 3, '本部门数据权限', '3', 'system_data_scope', 0, '', '', '本部门数据权限', 'admin', '2021-01-05 17:03:48',
        '', '2022-02-01 16:47:16', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (37, 4, '本部门及以下数据权限', '4', 'system_data_scope', 0, '', '', '本部门及以下数据权限', 'admin',
        '2021-01-05 17:03:48', '', '2022-02-01 16:47:21', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (38, 5, '仅本人数据权限', '5', 'system_data_scope', 0, '', '', '仅本人数据权限', 'admin', '2021-01-05 17:03:48',
        '', '2022-02-01 16:47:23', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (39, 0, '成功', '0', 'system_login_result', 0, 'success', '', '登陆结果 - 成功', '', '2021-01-18 06:17:36', '1',
        '2022-02-16 13:23:49', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (40, 10, '账号或密码不正确', '10', 'system_login_result', 0, 'primary', '', '登陆结果 - 账号或密码不正确', '',
        '2021-01-18 06:17:54', '1', '2022-02-16 13:24:27', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (41, 20, '用户被禁用', '20', 'system_login_result', 0, 'warning', '', '登陆结果 - 用户被禁用', '',
        '2021-01-18 06:17:54', '1', '2022-02-16 13:23:57', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (42, 30, '验证码不存在', '30', 'system_login_result', 0, 'info', '', '登陆结果 - 验证码不存在', '',
        '2021-01-18 06:17:54', '1', '2022-02-16 13:24:07', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (43, 31, '验证码不正确', '31', 'system_login_result', 0, 'info', '', '登陆结果 - 验证码不正确', '',
        '2021-01-18 06:17:54', '1', '2022-02-16 13:24:11', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (44, 100, '未知异常', '100', 'system_login_result', 0, 'danger', '', '登陆结果 - 未知异常', '',
        '2021-01-18 06:17:54', '1', '2022-02-16 13:24:23', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (45, 1, '是', 'true', 'infra_boolean_string', 0, 'danger', '', 'Boolean 是否类型 - 是', '',
        '2021-01-19 03:20:55', '1', '2022-03-15 23:01:45', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (46, 1, '否', 'false', 'infra_boolean_string', 0, 'info', '', 'Boolean 是否类型 - 否', '', '2021-01-19 03:20:55',
        '1', '2022-03-15 23:09:45', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (47, 1, '永不超时', '1', 'infra_redis_timeout_type', 0, 'primary', '', 'Redis 未设置超时的情况', '',
        '2021-01-26 00:53:17', '1', '2022-02-16 19:03:35', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (48, 1, '动态超时', '2', 'infra_redis_timeout_type', 0, 'info', '', '程序里动态传入超时时间，无法固定', '',
        '2021-01-26 00:55:00', '1', '2022-02-16 19:03:41', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (49, 3, '固定超时', '3', 'infra_redis_timeout_type', 0, 'success', '', 'Redis 设置了过期时间', '',
        '2021-01-26 00:55:26', '1', '2022-02-16 19:03:45', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (50, 1, '单表（增删改查）', '1', 'infra_codegen_template_type', 0, '', '', null, '', '2021-02-05 07:09:06', '',
        '2022-03-10 16:33:15', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (51, 2, '树表（增删改查）', '2', 'infra_codegen_template_type', 0, '', '', null, '', '2021-02-05 07:14:46', '',
        '2022-03-10 16:33:19', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (53, 0, '初始化中', '0', 'infra_job_status', 0, 'primary', '', null, '', '2021-02-07 07:46:49', '1',
        '2022-02-16 19:33:29', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (57, 0, '运行中', '0', 'infra_job_log_status', 0, 'primary', '', 'RUNNING', '', '2021-02-08 10:04:24', '1',
        '2022-02-16 19:07:48', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (58, 1, '成功', '1', 'infra_job_log_status', 0, 'success', '', null, '', '2021-02-08 10:06:57', '1',
        '2022-02-16 19:07:52', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (59, 2, '失败', '2', 'infra_job_log_status', 0, 'warning', '', '失败', '', '2021-02-08 10:07:38', '1',
        '2022-02-16 19:07:56', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (60, 1, '会员', '1', 'user_type', 0, 'primary', '', null, '', '2021-02-26 00:16:27', '1', '2022-02-16 10:22:19',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (61, 2, '管理员', '2', 'user_type', 0, 'success', '', null, '', '2021-02-26 00:16:34', '1',
        '2022-02-16 10:22:22', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (62, 0, '未处理', '0', 'infra_api_error_log_process_status', 0, 'primary', '', null, '', '2021-02-26 07:07:19',
        '1', '2022-02-16 20:14:17', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (63, 1, '已处理', '1', 'infra_api_error_log_process_status', 0, 'success', '', null, '', '2021-02-26 07:07:26',
        '1', '2022-02-16 20:14:08', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (64, 2, '已忽略', '2', 'infra_api_error_log_process_status', 0, 'danger', '', null, '', '2021-02-26 07:07:34',
        '1', '2022-02-16 20:14:14', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (66, 2, '阿里云', 'ALIYUN', 'system_sms_channel_code', 0, 'primary', '', null, '1', '2021-04-05 01:05:26', '1',
        '2022-02-16 10:09:52', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (67, 1, '验证码', '1', 'system_sms_template_type', 0, 'warning', '', null, '1', '2021-04-05 21:50:57', '1',
        '2022-02-16 12:48:30', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (68, 2, '通知', '2', 'system_sms_template_type', 0, 'primary', '', null, '1', '2021-04-05 21:51:08', '1',
        '2022-02-16 12:48:27', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (69, 0, '营销', '3', 'system_sms_template_type', 0, 'danger', '', null, '1', '2021-04-05 21:51:15', '1',
        '2022-02-16 12:48:22', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (70, 0, '初始化', '0', 'system_sms_send_status', 0, 'primary', '', null, '1', '2021-04-11 20:18:33', '1',
        '2022-02-16 10:26:07', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (71, 1, '发送成功', '10', 'system_sms_send_status', 0, 'success', '', null, '1', '2021-04-11 20:18:43', '1',
        '2022-02-16 10:25:56', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (72, 2, '发送失败', '20', 'system_sms_send_status', 0, 'danger', '', null, '1', '2021-04-11 20:18:49', '1',
        '2022-02-16 10:26:03', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (73, 3, '不发送', '30', 'system_sms_send_status', 0, 'info', '', null, '1', '2021-04-11 20:19:44', '1',
        '2022-02-16 10:26:10', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (74, 0, '等待结果', '0', 'system_sms_receive_status', 0, 'primary', '', null, '1', '2021-04-11 20:27:43', '1',
        '2022-02-16 10:28:24', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (75, 1, '接收成功', '10', 'system_sms_receive_status', 0, 'success', '', null, '1', '2021-04-11 20:29:25', '1',
        '2022-02-16 10:28:28', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (76, 2, '接收失败', '20', 'system_sms_receive_status', 0, 'danger', '', null, '1', '2021-04-11 20:29:31', '1',
        '2022-02-16 10:28:32', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (77, 0, '调试(钉钉)', 'DEBUG_DING_TALK', 'system_sms_channel_code', 0, 'info', '', null, '1',
        '2021-04-13 00:20:37', '1', '2022-02-16 10:10:00', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (78, 1, '自动生成', '1', 'system_error_code_type', 0, 'warning', '', null, '1', '2021-04-21 00:06:48', '1',
        '2022-02-16 13:57:20', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (79, 2, '手动编辑', '2', 'system_error_code_type', 0, 'primary', '', null, '1', '2021-04-21 00:07:14', '1',
        '2022-02-16 13:57:24', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (80, 100, '账号登录', '100', 'system_login_type', 0, 'primary', '', '账号登录', '1', '2021-10-06 00:52:02', '1',
        '2022-02-16 13:11:34', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (81, 101, '社交登录', '101', 'system_login_type', 0, 'info', '', '社交登录', '1', '2021-10-06 00:52:17', '1',
        '2022-02-16 13:11:40', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (83, 200, '主动登出', '200', 'system_login_type', 0, 'primary', '', '主动登出', '1', '2021-10-06 00:52:58', '1',
        '2022-02-16 13:11:49', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (85, 202, '强制登出', '202', 'system_login_type', 0, 'danger', '', '强制退出', '1', '2021-10-06 00:53:41', '1',
        '2022-02-16 13:11:57', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (86, 0, '病假', '1', 'bpm_oa_leave_type', 0, 'primary', '', null, '1', '2021-09-21 22:35:28', '1',
        '2022-02-16 10:00:41', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (87, 1, '事假', '2', 'bpm_oa_leave_type', 0, 'info', '', null, '1', '2021-09-21 22:36:11', '1',
        '2022-02-16 10:00:49', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (88, 2, '婚假', '3', 'bpm_oa_leave_type', 0, 'warning', '', null, '1', '2021-09-21 22:36:38', '1',
        '2022-02-16 10:00:53', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (113, 1, '微信公众号支付', 'wx_pub', 'pay_channel_code', 0, 'success', '', '微信公众号支付', '1',
        '2021-12-03 10:40:24', '1', '2023-07-19 20:08:47', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (114, 2, '微信小程序支付', 'wx_lite', 'pay_channel_code', 0, 'success', '', '微信小程序支付', '1',
        '2021-12-03 10:41:06', '1', '2023-07-19 20:08:50', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (115, 3, '微信 App 支付', 'wx_app', 'pay_channel_code', 0, 'success', '', '微信 App 支付', '1',
        '2021-12-03 10:41:20', '1', '2023-07-19 20:08:56', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (116, 10, '支付宝 PC 网站支付', 'alipay_pc', 'pay_channel_code', 0, 'primary', '', '支付宝 PC 网站支付', '1',
        '2021-12-03 10:42:09', '1', '2023-07-19 20:09:12', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (117, 11, '支付宝 Wap 网站支付', 'alipay_wap', 'pay_channel_code', 0, 'primary', '', '支付宝 Wap 网站支付', '1',
        '2021-12-03 10:42:26', '1', '2023-07-19 20:09:16', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (118, 12, '支付宝 App 支付', 'alipay_app', 'pay_channel_code', 0, 'primary', '', '支付宝 App 支付', '1',
        '2021-12-03 10:42:55', '1', '2023-07-19 20:09:20', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (119, 14, '支付宝扫码支付', 'alipay_qr', 'pay_channel_code', 0, 'primary', '', '支付宝扫码支付', '1',
        '2021-12-03 10:43:10', '1', '2023-07-19 20:09:28', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (120, 10, '通知成功', '10', 'pay_notify_status', 0, 'success', '', '通知成功', '1', '2021-12-03 11:02:41', '1',
        '2023-07-19 10:08:19', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (121, 20, '通知失败', '20', 'pay_notify_status', 0, 'danger', '', '通知失败', '1', '2021-12-03 11:02:59', '1',
        '2023-07-19 10:08:21', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (122, 0, '等待通知', '0', 'pay_notify_status', 0, 'info', '', '未通知', '1', '2021-12-03 11:03:10', '1',
        '2023-07-19 10:08:24', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (123, 10, '支付成功', '10', 'pay_order_status', 0, 'success', '', '支付成功', '1', '2021-12-03 11:18:29', '1',
        '2023-07-19 18:04:28', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (124, 30, '支付关闭', '30', 'pay_order_status', 0, 'info', '', '支付关闭', '1', '2021-12-03 11:18:42', '1',
        '2023-07-19 18:05:07', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (125, 0, '等待支付', '0', 'pay_order_status', 0, 'info', '', '未支付', '1', '2021-12-03 11:18:18', '1',
        '2023-07-19 18:04:15', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1118, 0, '等待退款', '0', 'pay_refund_status', 0, 'info', '', '等待退款', '1', '2021-12-10 16:44:59', '1',
        '2023-07-19 10:14:39', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1119, 20, '退款失败', '20', 'pay_refund_status', 0, 'danger', '', '退款失败', '1', '2021-12-10 16:45:10', '1',
        '2023-07-19 10:15:10', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1124, 10, '退款成功', '10', 'pay_refund_status', 0, 'success', '', '退款成功', '1', '2021-12-10 16:46:26', '1',
        '2023-07-19 10:15:00', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1125, 0, '默认', '1', 'bpm_model_category', 0, 'primary', '', '流程分类 - 默认', '1', '2022-01-02 08:41:11',
        '1', '2022-02-16 20:01:42', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1126, 0, 'OA', '2', 'bpm_model_category', 0, 'success', '', '流程分类 - OA', '1', '2022-01-02 08:41:22', '1',
        '2022-02-16 20:01:50', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1127, 0, '进行中', '1', 'bpm_process_instance_status', 0, 'primary', '', '流程实例的状态 - 进行中', '1',
        '2022-01-07 23:47:22', '1', '2022-02-16 20:07:49', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1128, 2, '已完成', '2', 'bpm_process_instance_status', 0, 'success', '', '流程实例的状态 - 已完成', '1',
        '2022-01-07 23:47:49', '1', '2022-02-16 20:07:54', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1129, 1, '处理中', '1', 'bpm_process_instance_result', 0, 'primary', '', '流程实例的结果 - 处理中', '1',
        '2022-01-07 23:48:32', '1', '2022-02-16 09:53:26', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1130, 2, '通过', '2', 'bpm_process_instance_result', 0, 'success', '', '流程实例的结果 - 通过', '1',
        '2022-01-07 23:48:45', '1', '2022-02-16 09:53:31', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1131, 3, '不通过', '3', 'bpm_process_instance_result', 0, 'danger', '', '流程实例的结果 - 不通过', '1',
        '2022-01-07 23:48:55', '1', '2022-02-16 09:53:38', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1132, 4, '已取消', '4', 'bpm_process_instance_result', 0, 'info', '', '流程实例的结果 - 撤销', '1',
        '2022-01-07 23:49:06', '1', '2022-02-16 09:53:42', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1133, 10, '流程表单', '10', 'bpm_model_form_type', 0, '', '', '流程的表单类型 - 流程表单', '103',
        '2022-01-11 23:51:30', '103', '2022-01-11 23:51:30', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1134, 20, '业务表单', '20', 'bpm_model_form_type', 0, '', '', '流程的表单类型 - 业务表单', '103',
        '2022-01-11 23:51:47', '103', '2022-01-11 23:51:47', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1135, 10, '角色', '10', 'bpm_task_assign_rule_type', 0, 'info', '', '任务分配规则的类型 - 角色', '103',
        '2022-01-12 23:21:22', '1', '2022-02-16 20:06:14', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1136, 20, '部门的成员', '20', 'bpm_task_assign_rule_type', 0, 'primary', '', '任务分配规则的类型 - 部门的成员',
        '103', '2022-01-12 23:21:47', '1', '2022-02-16 20:05:28', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1137, 21, '部门的负责人', '21', 'bpm_task_assign_rule_type', 0, 'primary', '',
        '任务分配规则的类型 - 部门的负责人', '103', '2022-01-12 23:33:36', '1', '2022-02-16 20:05:31', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1138, 30, '用户', '30', 'bpm_task_assign_rule_type', 0, 'info', '', '任务分配规则的类型 - 用户', '103',
        '2022-01-12 23:34:02', '1', '2022-02-16 20:05:50', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1139, 40, '用户组', '40', 'bpm_task_assign_rule_type', 0, 'warning', '', '任务分配规则的类型 - 用户组', '103',
        '2022-01-12 23:34:21', '1', '2022-02-16 20:05:57', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1140, 50, '自定义脚本', '50', 'bpm_task_assign_rule_type', 0, 'danger', '', '任务分配规则的类型 - 自定义脚本',
        '103', '2022-01-12 23:34:43', '1', '2022-02-16 20:06:01', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1141, 22, '岗位', '22', 'bpm_task_assign_rule_type', 0, 'success', '', '任务分配规则的类型 - 岗位', '103',
        '2022-01-14 18:41:55', '1', '2022-02-16 20:05:39', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1142, 10, '流程发起人', '10', 'bpm_task_assign_script', 0, '', '', '任务分配自定义脚本 - 流程发起人', '103',
        '2022-01-15 00:10:57', '103', '2022-01-15 21:24:10', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1143, 20, '流程发起人的一级领导', '20', 'bpm_task_assign_script', 0, '', '',
        '任务分配自定义脚本 - 流程发起人的一级领导', '103', '2022-01-15 21:24:31', '103', '2022-01-15 21:24:31', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1144, 21, '流程发起人的二级领导', '21', 'bpm_task_assign_script', 0, '', '',
        '任务分配自定义脚本 - 流程发起人的二级领导', '103', '2022-01-15 21:24:46', '103', '2022-01-15 21:24:57', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1145, 1, '管理后台', '1', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 管理后台', '1',
        '2022-02-02 13:15:06', '1', '2022-03-10 16:32:59', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1146, 2, '用户 APP', '2', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 用户 APP', '1',
        '2022-02-02 13:15:19', '1', '2022-03-10 16:33:03', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1150, 1, '数据库', '1', 'infra_file_storage', 0, 'default', '', null, '1', '2022-03-15 00:25:28', '1',
        '2022-03-15 00:25:28', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1151, 10, '本地磁盘', '10', 'infra_file_storage', 0, 'default', '', null, '1', '2022-03-15 00:25:41', '1',
        '2022-03-15 00:25:56', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1152, 11, 'FTP 服务器', '11', 'infra_file_storage', 0, 'default', '', null, '1', '2022-03-15 00:26:06', '1',
        '2022-03-15 00:26:10', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1153, 12, 'SFTP 服务器', '12', 'infra_file_storage', 0, 'default', '', null, '1', '2022-03-15 00:26:22', '1',
        '2022-03-15 00:26:22', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1154, 20, 'S3 对象存储', '20', 'infra_file_storage', 0, 'default', '', null, '1', '2022-03-15 00:26:31', '1',
        '2022-03-15 00:26:45', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1155, 103, '短信登录', '103', 'system_login_type', 0, 'default', '', null, '1', '2022-05-09 23:57:58', '1',
        '2022-05-09 23:58:09', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1156, 1, 'password', 'password', 'system_oauth2_grant_type', 0, 'default', '', '密码模式', '1',
        '2022-05-12 00:22:05', '1', '2022-05-11 16:26:01', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1157, 2, 'authorization_code', 'authorization_code', 'system_oauth2_grant_type', 0, 'primary', '', '授权码模式',
        '1', '2022-05-12 00:22:59', '1', '2022-05-11 16:26:02', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1158, 3, 'implicit', 'implicit', 'system_oauth2_grant_type', 0, 'success', '', '简化模式', '1',
        '2022-05-12 00:23:40', '1', '2022-05-11 16:26:05', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1159, 4, 'client_credentials', 'client_credentials', 'system_oauth2_grant_type', 0, 'default', '', '客户端模式',
        '1', '2022-05-12 00:23:51', '1', '2022-05-11 16:26:08', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1160, 5, 'refresh_token', 'refresh_token', 'system_oauth2_grant_type', 0, 'info', '', '刷新模式', '1',
        '2022-05-12 00:24:02', '1', '2022-05-11 16:26:11', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1162, 1, '销售中', '1', 'product_spu_status', 0, 'success', '', '商品 SPU 状态 - 销售中', '1',
        '2022-10-24 21:19:47', '1', '2022-10-24 21:20:38', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1163, 0, '仓库中', '0', 'product_spu_status', 0, 'info', '', '商品 SPU 状态 - 仓库中', '1',
        '2022-10-24 21:20:54', '1', '2022-10-24 21:21:22', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1164, 0, '回收站', '-1', 'product_spu_status', 0, 'default', '', '商品 SPU 状态 - 回收站', '1',
        '2022-10-24 21:21:11', '1', '2022-10-24 21:21:11', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1165, 1, '满减', '1', 'promotion_discount_type', 0, 'success', '', '优惠类型 - 满减', '1',
        '2022-11-01 12:46:41', '1', '2022-11-01 12:50:11', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1166, 2, '折扣', '2', 'promotion_discount_type', 0, 'primary', '', '优惠类型 - 折扣', '1',
        '2022-11-01 12:46:51', '1', '2022-11-01 12:50:08', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1167, 1, '固定日期', '1', 'promotion_coupon_template_validity_type', 0, 'default', '',
        '优惠劵模板的有限期类型 - 固定日期', '1', '2022-11-02 00:07:34', '1', '2022-11-04 00:07:49', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1168, 2, '领取之后', '2', 'promotion_coupon_template_validity_type', 0, 'default', '',
        '优惠劵模板的有限期类型 - 领取之后', '1', '2022-11-02 00:07:54', '1', '2022-11-04 00:07:52', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1169, 1, '全部商品参与', '1', 'promotion_product_scope', 0, 'default', '', '营销的商品范围 - 全部商品参与', '1',
        '2022-11-02 00:28:22', '1', '2022-11-02 00:28:22', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1170, 2, '指定商品参与', '2', 'promotion_product_scope', 0, 'default', '', '营销的商品范围 - 指定商品参与', '1',
        '2022-11-02 00:28:34', '1', '2022-11-02 00:28:40', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1171, 1, '已领取', '1', 'promotion_coupon_status', 0, 'primary', '', '优惠劵的状态 - 已领取', '1',
        '2022-11-04 00:15:08', '1', '2022-11-04 19:16:04', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1172, 2, '已使用', '2', 'promotion_coupon_status', 0, 'success', '', '优惠劵的状态 - 已使用', '1',
        '2022-11-04 00:15:21', '1', '2022-11-04 19:16:08', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1173, 3, '已过期', '3', 'promotion_coupon_status', 0, 'info', '', '优惠劵的状态 - 已过期', '1',
        '2022-11-04 00:15:43', '1', '2022-11-04 19:16:12', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1174, 1, '直接领取', '1', 'promotion_coupon_take_type', 0, 'primary', '', '优惠劵的领取方式 - 直接领取', '1',
        '2022-11-04 19:13:00', '1', '2022-11-04 19:13:25', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1175, 2, '指定发放', '2', 'promotion_coupon_take_type', 0, 'success', '', '优惠劵的领取方式 - 指定发放', '1',
        '2022-11-04 19:13:13', '1', '2022-11-04 19:14:48', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1176, 10, '未开始', '10', 'promotion_activity_status', 0, 'primary', '', '促销活动的状态枚举 - 未开始', '1',
        '2022-11-04 22:54:49', '1', '2022-11-04 22:55:53', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1177, 20, '进行中', '20', 'promotion_activity_status', 0, 'success', '', '促销活动的状态枚举 - 进行中', '1',
        '2022-11-04 22:55:06', '1', '2022-11-04 22:55:20', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1178, 30, '已结束', '30', 'promotion_activity_status', 0, 'info', '', '促销活动的状态枚举 - 已结束', '1',
        '2022-11-04 22:55:41', '1', '2022-11-04 22:55:41', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1179, 40, '已关闭', '40', 'promotion_activity_status', 0, 'warning', '', '促销活动的状态枚举 - 已关闭', '1',
        '2022-11-04 22:56:10', '1', '2022-11-04 22:56:18', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1180, 10, '满 N 元', '10', 'promotion_condition_type', 0, 'primary', '', '营销的条件类型 - 满 N 元', '1',
        '2022-11-04 22:59:45', '1', '2022-11-04 22:59:45', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1181, 20, '满 N 件', '20', 'promotion_condition_type', 0, 'success', '', '营销的条件类型 - 满 N 件', '1',
        '2022-11-04 23:00:02', '1', '2022-11-04 23:00:02', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1182, 10, '申请售后', '10', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 申请售后', '1',
        '2022-11-19 20:53:33', '1', '2022-11-19 20:54:42', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1183, 20, '商品待退货', '20', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 商品待退货', '1',
        '2022-11-19 20:54:36', '1', '2022-11-19 20:58:58', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1184, 30, '商家待收货', '30', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 商家待收货', '1',
        '2022-11-19 20:56:56', '1', '2022-11-19 20:59:20', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1185, 40, '等待退款', '40', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 等待退款', '1',
        '2022-11-19 20:59:54', '1', '2022-11-19 21:00:01', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1186, 50, '退款成功', '50', 'trade_after_sale_status', 0, 'default', '', '交易售后状态 - 退款成功', '1',
        '2022-11-19 21:00:33', '1', '2022-11-19 21:00:33', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1187, 61, '买家取消', '61', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 买家取消', '1',
        '2022-11-19 21:01:29', '1', '2022-11-19 21:01:29', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1188, 62, '商家拒绝', '62', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 商家拒绝', '1',
        '2022-11-19 21:02:17', '1', '2022-11-19 21:02:17', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1189, 63, '商家拒收货', '63', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 商家拒收货', '1',
        '2022-11-19 21:02:37', '1', '2022-11-19 21:03:07', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1190, 10, '售中退款', '10', 'trade_after_sale_type', 0, 'success', '', '交易售后的类型 - 售中退款', '1',
        '2022-11-19 21:05:05', '1', '2022-11-19 21:38:23', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1191, 20, '售后退款', '20', 'trade_after_sale_type', 0, 'primary', '', '交易售后的类型 - 售后退款', '1',
        '2022-11-19 21:05:32', '1', '2022-11-19 21:38:32', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1192, 10, '仅退款', '10', 'trade_after_sale_way', 0, 'primary', '', '交易售后的方式 - 仅退款', '1',
        '2022-11-19 21:39:19', '1', '2022-11-19 21:39:19', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1193, 20, '退货退款', '20', 'trade_after_sale_way', 0, 'success', '', '交易售后的方式 - 退货退款', '1',
        '2022-11-19 21:39:38', '1', '2022-11-19 21:39:49', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1194, 10, '微信小程序', '10', 'terminal', 0, 'default', '', '终端 - 微信小程序', '1', '2022-12-10 10:51:11',
        '1', '2022-12-10 10:51:57', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1195, 20, 'H5 网页', '20', 'terminal', 0, 'default', '', '终端 - H5 网页', '1', '2022-12-10 10:51:30', '1',
        '2022-12-10 10:51:59', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1196, 11, '微信公众号', '11', 'terminal', 0, 'default', '', '终端 - 微信公众号', '1', '2022-12-10 10:54:16',
        '1', '2022-12-10 10:52:01', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1197, 31, '苹果 App', '31', 'terminal', 0, 'default', '', '终端 - 苹果 App', '1', '2022-12-10 10:54:42', '1',
        '2022-12-10 10:52:18', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1198, 32, '安卓 App', '32', 'terminal', 0, 'default', '', '终端 - 安卓 App', '1', '2022-12-10 10:55:02', '1',
        '2022-12-10 10:59:17', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1199, 0, '普通订单', '0', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 普通订单', '1',
        '2022-12-10 16:34:14', '1', '2022-12-10 16:34:14', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1200, 1, '秒杀订单', '1', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 秒杀订单', '1',
        '2022-12-10 16:34:26', '1', '2022-12-10 16:34:26', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1201, 2, '拼团订单', '2', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 拼团订单', '1',
        '2022-12-10 16:34:36', '1', '2022-12-10 16:34:36', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1202, 3, '砍价订单', '3', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 砍价订单', '1',
        '2022-12-10 16:34:48', '1', '2022-12-10 16:34:48', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1203, 0, '待支付', '0', 'trade_order_status', 0, 'default', '', '交易订单状态 - 待支付', '1',
        '2022-12-10 16:49:29', '1', '2022-12-10 16:49:29', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1204, 10, '待发货', '10', 'trade_order_status', 0, 'primary', '', '交易订单状态 - 待发货', '1',
        '2022-12-10 16:49:53', '1', '2022-12-10 16:51:17', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1205, 20, '已发货', '20', 'trade_order_status', 0, 'primary', '', '交易订单状态 - 已发货', '1',
        '2022-12-10 16:50:13', '1', '2022-12-10 16:51:31', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1206, 30, '已完成', '30', 'trade_order_status', 0, 'success', '', '交易订单状态 - 已完成', '1',
        '2022-12-10 16:50:30', '1', '2022-12-10 16:51:06', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1207, 40, '已取消', '40', 'trade_order_status', 0, 'danger', '', '交易订单状态 - 已取消', '1',
        '2022-12-10 16:50:50', '1', '2022-12-10 16:51:00', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1208, 0, '未售后', '0', 'trade_order_item_after_sale_status', 0, 'info', '', '交易订单项的售后状态 - 未售后',
        '1', '2022-12-10 20:58:42', '1', '2022-12-10 20:59:29', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1209, 1, '售后中', '1', 'trade_order_item_after_sale_status', 0, 'primary', '', '交易订单项的售后状态 - 售后中',
        '1', '2022-12-10 20:59:21', '1', '2022-12-10 20:59:21', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1210, 2, '已退款', '2', 'trade_order_item_after_sale_status', 0, 'success', '', '交易订单项的售后状态 - 已退款',
        '1', '2022-12-10 20:59:46', '1', '2022-12-10 20:59:46', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1211, 1, '完全匹配', '1', 'mp_auto_reply_request_match', 0, 'primary', '',
        '公众号自动回复的请求关键字匹配模式 - 完全匹配', '1', '2023-01-16 23:30:39', '1', '2023-01-16 23:31:00', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1212, 2, '半匹配', '2', 'mp_auto_reply_request_match', 0, 'success', '',
        '公众号自动回复的请求关键字匹配模式 - 半匹配', '1', '2023-01-16 23:30:55', '1', '2023-01-16 23:31:10', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1213, 1, '文本', 'text', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 文本', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 22:17:39', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1214, 2, '图片', 'image', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 图片', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 14:19:47', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1215, 3, '语音', 'voice', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 语音', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 14:20:08', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1216, 4, '视频', 'video', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 视频', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 14:21:08', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1217, 5, '小视频', 'shortvideo', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 小视频', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 14:19:59', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1218, 6, '图文', 'news', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 图文', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 14:22:54', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1219, 7, '音乐', 'music', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 音乐', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 14:22:54', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1220, 8, '地理位置', 'location', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 地理位置', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 14:23:51', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1221, 9, '链接', 'link', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 链接', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 14:24:49', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1222, 10, '事件', 'event', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 事件', '1',
        '2023-01-17 22:17:32', '1', '2023-01-17 14:24:49', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1223, 0, '初始化', '0', 'system_mail_send_status', 0, 'primary', '', '邮件发送状态 - 初始化
', '1', '2023-01-26 09:53:49', '1', '2023-01-26 16:36:14', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1224, 10, '发送成功', '10', 'system_mail_send_status', 0, 'success', '', '邮件发送状态 - 发送成功', '1',
        '2023-01-26 09:54:28', '1', '2023-01-26 16:36:22', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1225, 20, '发送失败', '20', 'system_mail_send_status', 0, 'danger', '', '邮件发送状态 - 发送失败', '1',
        '2023-01-26 09:54:50', '1', '2023-01-26 16:36:26', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1226, 30, '不发送', '30', 'system_mail_send_status', 0, 'info', '', '邮件发送状态 -  不发送', '1',
        '2023-01-26 09:55:06', '1', '2023-01-26 16:36:36', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1227, 1, '通知公告', '1', 'system_notify_template_type', 0, 'primary', '', '站内信模版的类型 - 通知公告', '1',
        '2023-01-28 10:35:59', '1', '2023-01-28 10:35:59', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1228, 2, '系统消息', '2', 'system_notify_template_type', 0, 'success', '', '站内信模版的类型 - 系统消息', '1',
        '2023-01-28 10:36:20', '1', '2023-01-28 10:36:25', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1229, 0, '模拟支付', 'mock', 'pay_channel_code', 0, 'default', '', '模拟支付', '1', '2023-02-12 21:50:22', '1',
        '2023-07-10 10:11:02', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1230, 13, '支付宝条码支付', 'alipay_bar', 'pay_channel_code', 0, 'primary', '', '支付宝条码支付', '1',
        '2023-02-18 23:32:24', '1', '2023-07-19 20:09:23', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1231, 10, 'Vue2 Element UI 标准模版', '10', 'infra_codegen_front_type', 0, '', '', '', '1',
        '2023-04-13 00:03:55', '1', '2023-04-13 00:03:55', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1232, 20, 'Vue3 Element Plus 标准模版', '20', 'infra_codegen_front_type', 0, '', '', '', '1',
        '2023-04-13 00:04:08', '1', '2023-04-13 00:04:08', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1233, 21, 'Vue3 Element Plus Schema 模版', '21', 'infra_codegen_front_type', 0, '', '', '', '1',
        '2023-04-13 00:04:26', '1', '2023-04-13 00:04:26', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1234, 30, 'Vue3 vben 模版', '30', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:26', '1',
        '2023-04-13 00:04:26', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1235, 1, '个', '1', 'product_unit', 0, '', '', '', '1', '2023-05-23 14:38:38', '1', '2023-05-23 14:38:38',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1236, 1, '件', '2', 'product_unit', 0, '', '', '', '1', '2023-05-23 14:38:38', '1', '2023-05-23 14:38:38',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1237, 1, '盒', '3', 'product_unit', 0, '', '', '', '1', '2023-05-23 14:38:38', '1', '2023-05-23 14:38:38',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1238, 1, '袋', '4', 'product_unit', 0, '', '', '', '1', '2023-05-23 14:38:38', '1', '2023-05-23 14:38:38',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1239, 1, '箱', '5', 'product_unit', 0, '', '', '', '1', '2023-05-23 14:38:38', '1', '2023-05-23 14:38:38',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1240, 1, '套', '6', 'product_unit', 0, '', '', '', '1', '2023-05-23 14:38:38', '1', '2023-05-23 14:38:38',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1241, 1, '包', '7', 'product_unit', 0, '', '', '', '1', '2023-05-23 14:38:38', '1', '2023-05-23 14:38:38',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1242, 1, '双', '8', 'product_unit', 0, '', '', '', '1', '2023-05-23 14:38:38', '1', '2023-05-23 14:38:38',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1243, 1, '卷', '9', 'product_unit', 0, '', '', '', '1', '2023-05-23 14:38:38', '1', '2023-05-23 14:38:38',
        false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1244, 0, '按件', '1', 'trade_delivery_express_charge_mode', 0, '', '', '', '1', '2023-05-21 22:46:40', '1',
        '2023-05-21 22:46:40', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1245, 1, '按重量', '2', 'trade_delivery_express_charge_mode', 0, '', '', '', '1', '2023-05-21 22:46:58', '1',
        '2023-05-21 22:46:58', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1246, 2, '按体积', '3', 'trade_delivery_express_charge_mode', 0, '', '', '', '1', '2023-05-21 22:47:18', '1',
        '2023-05-21 22:47:18', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1335, 1, '购物', '1', 'member_point_biz_type', 0, '', '', '', '1', '2023-06-10 12:15:27', '1',
        '2023-06-28 13:48:28', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1336, 2, '签到', '2', 'member_point_biz_type', 0, '', '', '', '1', '2023-06-10 12:15:48', '1',
        '2023-06-28 13:48:31', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1337, 1, '订单创建', '1', 'member_point_status', 0, '', '', '', '1', '2023-06-10 12:16:42', '1',
        '2023-06-28 13:48:34', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1338, 2, '冻结期', '2', 'member_point_status', 0, '', '', '', '1', '2023-06-10 12:16:58', '1',
        '2023-06-28 13:48:36', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1339, 3, '完成', '3', 'member_point_status', 0, '', '', '', '1', '2023-06-10 12:17:07', '1',
        '2023-06-28 13:48:38', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1340, 4, '失效(订单退款)', '4', 'member_point_status', 0, '', '', '', '1', '2023-06-10 12:17:21', '1',
        '2023-06-28 13:48:42', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1341, 20, '已退款', '20', 'pay_order_status', 0, 'danger', '', '已退款', '1', '2023-07-19 18:05:37', '1',
        '2023-07-19 18:05:37', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1342, 21, '请求成功，但是结果失败', '21', 'pay_notify_status', 0, 'warning', '', '请求成功，但是结果失败', '1',
        '2023-07-19 18:10:47', '1', '2023-07-19 18:11:38', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1343, 22, '请求失败', '22', 'pay_notify_status', 0, 'warning', '', null, '1', '2023-07-19 18:11:05', '1',
        '2023-07-19 18:11:27', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1344, 4, '微信扫码支付', 'wx_native', 'pay_channel_code', 0, 'success', '', '微信扫码支付', '1',
        '2023-07-19 20:07:47', '1', '2023-07-19 20:09:03', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1345, 5, '微信条码支付', 'wx_bar', 'pay_channel_code', 0, 'success', '', '微信条码支付
', '1', '2023-07-19 20:08:06', '1', '2023-07-19 20:09:08', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1346, 1, '支付单', '1', 'pay_notify_type', 0, 'primary', '', '支付单', '1', '2023-07-20 12:23:17', '1',
        '2023-07-20 12:23:17', false);
INSERT INTO interview.system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark,
                                        creator, create_time, updater, update_time, deleted)
VALUES (1347, 2, '退款单', '2', 'pay_notify_type', 0, 'danger', '', null, '1', '2023-07-20 12:23:26', '1',
        '2023-07-20 12:23:26', false);

INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (1, '用户性别', 'system_user_sex', 0, null, 'admin', '2021-01-05 17:03:48', '1', '2022-05-16 20:29:32', false,
        null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (6, '参数类型', 'infra_config_type', 0, null, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:36:54', false,
        null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (7, '通知类型', 'system_notice_type', 0, null, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:35:26', false,
        null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (9, '操作类型', 'system_operate_type', 0, null, 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 09:32:21',
        false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (10, '系统状态', 'common_status', 0, null, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:21:28', false,
        null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (11, 'Boolean 是否类型', 'infra_boolean_string', 0, 'boolean 转是否', '', '2021-01-19 03:20:08', '',
        '2022-02-01 16:37:10', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (104, '登陆结果', 'system_login_result', 0, '登陆结果', '', '2021-01-18 06:17:11', '', '2022-02-01 16:36:00',
        false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (105, 'Redis 超时类型', 'infra_redis_timeout_type', 0, 'RedisKeyDefine.TimeoutTypeEnum', '',
        '2021-01-26 00:52:50', '', '2022-02-01 16:50:29', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (106, '代码生成模板类型', 'infra_codegen_template_type', 0, null, '', '2021-02-05 07:08:06', '1',
        '2022-05-16 20:26:50', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (107, '定时任务状态', 'infra_job_status', 0, null, '', '2021-02-07 07:44:16', '', '2022-02-01 16:51:11', false,
        null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (108, '定时任务日志状态', 'infra_job_log_status', 0, null, '', '2021-02-08 10:03:51', '', '2022-02-01 16:50:43',
        false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (109, '用户类型', 'user_type', 0, null, '', '2021-02-26 00:15:51', '', '2021-02-26 00:15:51', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (110, 'API 异常数据的处理状态', 'infra_api_error_log_process_status', 0, null, '', '2021-02-26 07:07:01', '',
        '2022-02-01 16:50:53', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (111, '短信渠道编码', 'system_sms_channel_code', 0, null, '1', '2021-04-05 01:04:50', '1', '2022-02-16 02:09:08',
        false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (112, '短信模板的类型', 'system_sms_template_type', 0, null, '1', '2021-04-05 21:50:43', '1',
        '2022-02-01 16:35:06', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (113, '短信发送状态', 'system_sms_send_status', 0, null, '1', '2021-04-11 20:18:03', '1', '2022-02-01 16:35:09',
        false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (114, '短信接收状态', 'system_sms_receive_status', 0, null, '1', '2021-04-11 20:27:14', '1',
        '2022-02-01 16:35:14', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (115, '错误码的类型', 'system_error_code_type', 0, null, '1', '2021-04-21 00:06:30', '1', '2022-02-01 16:36:49',
        false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (116, '登陆日志的类型', 'system_login_type', 0, '登陆日志的类型', '1', '2021-10-06 00:50:46', '1',
        '2022-02-01 16:35:56', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (117, 'OA 请假类型', 'bpm_oa_leave_type', 0, null, '1', '2021-09-21 22:34:33', '1', '2022-01-22 10:41:37', false,
        null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (130, '支付渠道编码类型', 'pay_channel_code', 0, '支付渠道的编码', '1', '2021-12-03 10:35:08', '1',
        '2023-07-10 10:11:39', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (131, '支付回调状态', 'pay_notify_status', 0, '支付回调状态（包括退款回调）', '1', '2021-12-03 10:53:29', '1',
        '2023-07-19 18:09:43', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (132, '支付订单状态', 'pay_order_status', 0, '支付订单状态', '1', '2021-12-03 11:17:50', '1',
        '2021-12-03 11:17:50', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (134, '退款订单状态', 'pay_refund_status', 0, '退款订单状态', '1', '2021-12-10 16:42:50', '1',
        '2023-07-19 10:13:17', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (138, '流程分类', 'bpm_model_category', 0, '流程分类', '1', '2022-01-02 08:40:45', '1', '2022-01-02 08:40:45',
        false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (139, '流程实例的状态', 'bpm_process_instance_status', 0, '流程实例的状态', '1', '2022-01-07 23:46:42', '1',
        '2022-01-07 23:46:42', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (140, '流程实例的结果', 'bpm_process_instance_result', 0, '流程实例的结果', '1', '2022-01-07 23:48:10', '1',
        '2022-01-07 23:48:10', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (141, '流程的表单类型', 'bpm_model_form_type', 0, '流程的表单类型', '103', '2022-01-11 23:50:45', '103',
        '2022-01-11 23:50:45', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (142, '任务分配规则的类型', 'bpm_task_assign_rule_type', 0, '任务分配规则的类型', '103', '2022-01-12 23:21:04',
        '103', '2022-01-12 15:46:10', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (143, '任务分配自定义脚本', 'bpm_task_assign_script', 0, '任务分配自定义脚本', '103', '2022-01-15 00:10:35',
        '103', '2022-01-15 00:10:35', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (144, '代码生成的场景枚举', 'infra_codegen_scene', 0, '代码生成的场景枚举', '1', '2022-02-02 13:14:45', '1',
        '2022-03-10 16:33:46', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (145, '角色类型', 'system_role_type', 0, '角色类型', '1', '2022-02-16 13:01:46', '1', '2022-02-16 13:01:46',
        false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (146, '文件存储器', 'infra_file_storage', 0, '文件存储器', '1', '2022-03-15 00:24:38', '1',
        '2022-03-15 00:24:38', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (147, 'OAuth 2.0 授权类型', 'system_oauth2_grant_type', 0, 'OAuth 2.0 授权类型（模式）', '1',
        '2022-05-12 00:20:52', '1', '2022-05-11 16:25:49', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (149, '商品 SPU 状态', 'product_spu_status', 0, '商品 SPU 状态', '1', '2022-10-24 21:19:04', '1',
        '2022-10-24 21:19:08', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (150, '优惠类型', 'promotion_discount_type', 0, '优惠类型', '1', '2022-11-01 12:46:06', '1',
        '2022-11-01 12:46:06', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (151, '优惠劵模板的有限期类型', 'promotion_coupon_template_validity_type', 0, '优惠劵模板的有限期类型', '1',
        '2022-11-02 00:06:20', '1', '2022-11-04 00:08:26', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (152, '营销的商品范围', 'promotion_product_scope', 0, '营销的商品范围', '1', '2022-11-02 00:28:01', '1',
        '2022-11-02 00:28:01', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (153, '优惠劵的状态', 'promotion_coupon_status', 0, '优惠劵的状态', '1', '2022-11-04 00:14:49', '1',
        '2022-11-04 00:14:49', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (154, '优惠劵的领取方式', 'promotion_coupon_take_type', 0, '优惠劵的领取方式', '1', '2022-11-04 19:12:27', '1',
        '2022-11-04 19:12:27', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (155, '促销活动的状态', 'promotion_activity_status', 0, '促销活动的状态', '1', '2022-11-04 22:54:23', '1',
        '2022-11-04 22:54:23', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (156, '营销的条件类型', 'promotion_condition_type', 0, '营销的条件类型', '1', '2022-11-04 22:59:23', '1',
        '2022-11-04 22:59:23', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (157, '交易售后状态', 'trade_after_sale_status', 0, '交易售后状态', '1', '2022-11-19 20:52:56', '1',
        '2022-11-19 20:52:56', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (158, '交易售后的类型', 'trade_after_sale_type', 0, '交易售后的类型', '1', '2022-11-19 21:04:09', '1',
        '2022-11-19 21:04:09', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (159, '交易售后的方式', 'trade_after_sale_way', 0, '交易售后的方式', '1', '2022-11-19 21:39:04', '1',
        '2022-11-19 21:39:04', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (160, '终端', 'terminal', 0, '终端', '1', '2022-12-10 10:50:50', '1', '2022-12-10 10:53:11', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (161, '交易订单的类型', 'trade_order_type', 0, '交易订单的类型', '1', '2022-12-10 16:33:54', '1',
        '2022-12-10 16:33:54', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (162, '交易订单的状态', 'trade_order_status', 0, '交易订单的状态', '1', '2022-12-10 16:48:44', '1',
        '2022-12-10 16:48:44', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (163, '交易订单项的售后状态', 'trade_order_item_after_sale_status', 0, '交易订单项的售后状态', '1',
        '2022-12-10 20:58:08', '1', '2022-12-10 20:58:08', false, null);
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (164, '公众号自动回复的请求关键字匹配模式', 'mp_auto_reply_request_match', 0,
        '公众号自动回复的请求关键字匹配模式', '1', '2023-01-16 23:29:56', '1', '2023-01-16 23:29:56', false,
        '1970-01-01 00:00:00');
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (165, '公众号的消息类型', 'mp_message_type', 0, '公众号的消息类型', '1', '2023-01-17 22:17:09', '1',
        '2023-01-17 22:17:09', false, '1970-01-01 00:00:00');
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (166, '邮件发送状态', 'system_mail_send_status', 0, '邮件发送状态', '1', '2023-01-26 09:53:13', '1',
        '2023-01-26 09:53:13', false, '1970-01-01 00:00:00');
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (167, '站内信模版的类型', 'system_notify_template_type', 0, '站内信模版的类型', '1', '2023-01-28 10:35:10', '1',
        '2023-01-28 10:35:10', false, '1970-01-01 00:00:00');
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (168, '代码生成的前端类型', 'infra_codegen_front_type', 0, '', '1', '2023-04-12 23:57:52', '1',
        '2023-04-12 23:57:52', false, '1970-01-01 00:00:00');
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (169, '商品的单位', 'product_unit', 0, '商品的单位', '1', '2023-05-24 21:23:59', '1', '2023-05-24 21:23:59',
        false, '1970-01-01 00:00:00');
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (170, '快递计费方式', 'trade_delivery_express_charge_mode', 0, '用于商城交易模块配送管理', '1',
        '2023-05-21 22:45:03', '1', '2023-05-21 22:45:03', false, '1970-01-01 00:00:00');
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (171, '积分业务类型', 'member_point_biz_type', 0, '', '1', '2023-06-10 12:15:00', '1', '2023-06-28 13:48:20',
        false, '1970-01-01 00:00:00');
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (172, '积分订单状态', 'member_point_status', 0, '', '1', '2023-06-10 12:16:27', '1', '2023-06-28 13:48:17',
        false, '1970-01-01 00:00:00');
INSERT INTO interview.system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time,
                                        deleted, deleted_time)
VALUES (173, '支付通知类型', 'pay_notify_type', 0, null, '1', '2023-07-20 12:23:03', '1', '2023-07-20 12:23:03', false,
        '1970-01-01 00:00:00');

INSERT INTO interview.system_mail_account (id, mail, username, password, host, port, ssl_enable, creator, create_time,
                                           updater, update_time, deleted)
VALUES (1, '7684413@qq.com', '7684413@qq.com', '123457', '127.0.0.1', 8080, false, '1', '2023-01-25 17:39:52', '1',
        '2023-04-12 23:04:49', false);
INSERT INTO interview.system_mail_account (id, mail, username, password, host, port, ssl_enable, creator, create_time,
                                           updater, update_time, deleted)
VALUES (2, 'ydym_test@163.com', 'ydym_test@163.com', 'WBZTEINMIFVRYSOE', 'smtp.163.com', 465, true, '1',
        '2023-01-26 01:26:03', '1', '2023-04-12 22:39:38', false);
INSERT INTO interview.system_mail_account (id, mail, username, password, host, port, ssl_enable, creator, create_time,
                                           updater, update_time, deleted)
VALUES (3, '76854114@qq.com', '3335', '11234', 'yunai1.cn', 466, false, '1', '2023-01-27 15:06:38', '1',
        '2023-01-27 07:08:36', true);
INSERT INTO interview.system_mail_account (id, mail, username, password, host, port, ssl_enable, creator, create_time,
                                           updater, update_time, deleted)
VALUES (4, '7685413x@qq.com', '2', '3', '4', 5, true, '1', '2023-04-12 23:05:06', '1', '2023-04-12 15:05:11', true);

INSERT INTO interview.system_mail_template (id, name, code, account_id, nickname, title, content, params, status,
                                            remark, creator, create_time, updater, update_time, deleted)
VALUES (13, '后台用户短信登录', 'admin-sms-login', 1, '奥特曼', '你猜我猜', '<p>您的验证码是{code}，名字是{name}</p>',
        '["code","name"]', 0, '3', '1', '2021-10-11 08:10:00', '1', '2023-01-26 23:22:05', false);
INSERT INTO interview.system_mail_template (id, name, code, account_id, nickname, title, content, params, status,
                                            remark, creator, create_time, updater, update_time, deleted)
VALUES (14, '测试模版', 'test_01', 2, '芋艿', '一个标题',
        '<p>你是 {key01} 吗？</p><p><br></p><p>是的话，赶紧 {key02} 一下！</p>', '["key01","key02"]', 0, null, '1',
        '2023-01-26 01:27:40', '1', '2023-01-27 10:32:16', false);
INSERT INTO interview.system_mail_template (id, name, code, account_id, nickname, title, content, params, status,
                                            remark, creator, create_time, updater, update_time, deleted)
VALUES (15, '3', '2', 2, '7', '4', '<p>45</p>', '[]', 1, '80', '1', '2023-01-27 15:50:35', '1', '2023-01-27 16:34:49',
        false);

INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1, '系统管理', '', 1, 10, 0, '/system', 'system', null, null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2, '基础设施', '', 1, 20, 0, '/infra', 'monitor', null, null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (5, 'OA 示例', '', 1, 40, 1185, 'oa', 'people', null, null, 0, true, true, true, 'admin', '2021-09-20 16:26:19',
        '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (100, '用户管理', 'system:user:list', 2, 1, 1, 'user', 'user', 'system/user/index', 'SystemUser', 0, true, true,
        true, 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:31:59', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (101, '角色管理', '', 2, 2, 1, 'role', 'peoples', 'system/role/index', 'SystemRole', 0, true, true, true,
        'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:33:59', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (102, '菜单管理', '', 2, 3, 1, 'menu', 'tree-table', 'system/menu/index', 'SystemMenu', 0, true, true, true,
        'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:34:32', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (103, '部门管理', '', 2, 4, 1, 'dept', 'tree', 'system/dept/index', 'SystemDept', 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2023-04-08 08:35:32', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (104, '岗位管理', '', 2, 5, 1, 'post', 'post', 'system/post/index', 'SystemPost', 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2023-04-08 08:36:21', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (105, '字典管理', '', 2, 6, 1, 'dict', 'dict', 'system/dict/index', 'SystemDictType', 0, true, true, true,
        'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:36:45', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (106, '配置管理', '', 2, 6, 2, 'config', 'edit', 'infra/config/index', 'InfraConfig', 0, true, true, true,
        'admin', '2021-01-05 17:03:48', '1', '2023-04-08 10:31:17', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (107, '通知公告', '', 2, 8, 1, 'notice', 'message', 'system/notice/index', 'SystemNotice', 0, true, true, true,
        'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:45:06', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (108, '审计日志', '', 1, 9, 1, 'log', 'log', '', null, 0, true, true, true, 'admin', '2021-01-05 17:03:48', '1',
        '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (109, '令牌管理', '', 2, 2, 1261, 'token', 'online', 'system/oauth2/token/index', 'SystemTokenClient', 0, true,
        true, true, 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:47:41', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (110, '定时任务', '', 2, 12, 2, 'job', 'job', 'infra/job/index', 'InfraJob', 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2023-04-08 10:36:49', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (111, 'MySQL 监控', '', 2, 9, 2, 'druid', 'druid', 'infra/druid/index', 'InfraDruid', 0, true, true, true,
        'admin', '2021-01-05 17:03:48', '1', '2023-04-08 09:09:30', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (112, 'Java 监控', '', 2, 11, 2, 'admin-server', 'server', 'infra/server/index', 'InfraAdminServer', 0, true,
        true, true, 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 10:34:08', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (113, 'Redis 监控', '', 2, 10, 2, 'redis', 'redis', 'infra/redis/index', 'InfraRedis', 0, true, true, true,
        'admin', '2021-01-05 17:03:48', '1', '2023-04-08 10:33:30', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (114, '表单构建', 'infra:build:list', 2, 2, 2, 'build', 'build', 'infra/build/index', 'InfraBuild', 0, true,
        true, true, 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 09:06:12', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (115, '代码生成', 'infra:codegen:query', 2, 1, 2, 'codegen', 'code', 'infra/codegen/index', 'InfraCodegen', 0,
        true, true, true, 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 09:02:24', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (116, '系统接口', 'infra:swagger:list', 2, 3, 2, 'swagger', 'swagger', 'infra/swagger/index', 'InfraSwagger', 0,
        true, true, true, 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 09:11:28', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (500, '操作日志', '', 2, 1, 108, 'operate-log', 'form', 'system/operatelog/index', 'SystemOperateLog', 0, true,
        true, true, 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:47:00', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (501, '登录日志', '', 2, 2, 108, 'login-log', 'logininfor', 'system/loginlog/index', 'SystemLoginLog', 0, true,
        true, true, 'admin', '2021-01-05 17:03:48', '1', '2023-04-08 08:46:18', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1001, '用户查询', 'system:user:query', 3, 1, 100, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1002, '用户新增', 'system:user:create', 3, 2, 100, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1003, '用户修改', 'system:user:update', 3, 3, 100, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1004, '用户删除', 'system:user:delete', 3, 4, 100, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1005, '用户导出', 'system:user:export', 3, 5, 100, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1006, '用户导入', 'system:user:import', 3, 6, 100, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1007, '重置密码', 'system:user:update-password', 3, 7, 100, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1008, '角色查询', 'system:role:query', 3, 1, 101, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1009, '角色新增', 'system:role:create', 3, 2, 101, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1010, '角色修改', 'system:role:update', 3, 3, 101, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1011, '角色删除', 'system:role:delete', 3, 4, 101, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1012, '角色导出', 'system:role:export', 3, 5, 101, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1013, '菜单查询', 'system:menu:query', 3, 1, 102, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1014, '菜单新增', 'system:menu:create', 3, 2, 102, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1015, '菜单修改', 'system:menu:update', 3, 3, 102, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1016, '菜单删除', 'system:menu:delete', 3, 4, 102, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1017, '部门查询', 'system:dept:query', 3, 1, 103, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1018, '部门新增', 'system:dept:create', 3, 2, 103, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1019, '部门修改', 'system:dept:update', 3, 3, 103, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1020, '部门删除', 'system:dept:delete', 3, 4, 103, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1021, '岗位查询', 'system:post:query', 3, 1, 104, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1022, '岗位新增', 'system:post:create', 3, 2, 104, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1023, '岗位修改', 'system:post:update', 3, 3, 104, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1024, '岗位删除', 'system:post:delete', 3, 4, 104, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1025, '岗位导出', 'system:post:export', 3, 5, 104, '', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1026, '字典查询', 'system:dict:query', 3, 1, 105, '#', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1027, '字典新增', 'system:dict:create', 3, 2, 105, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1028, '字典修改', 'system:dict:update', 3, 3, 105, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1029, '字典删除', 'system:dict:delete', 3, 4, 105, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1030, '字典导出', 'system:dict:export', 3, 5, 105, '#', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1031, '配置查询', 'infra:config:query', 3, 1, 106, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1032, '配置新增', 'infra:config:create', 3, 2, 106, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1033, '配置修改', 'infra:config:update', 3, 3, 106, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1034, '配置删除', 'infra:config:delete', 3, 4, 106, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1035, '配置导出', 'infra:config:export', 3, 5, 106, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1036, '公告查询', 'system:notice:query', 3, 1, 107, '#', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1037, '公告新增', 'system:notice:create', 3, 2, 107, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1038, '公告修改', 'system:notice:update', 3, 3, 107, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1039, '公告删除', 'system:notice:delete', 3, 4, 107, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1040, '操作查询', 'system:operate-log:query', 3, 1, 500, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1042, '日志导出', 'system:operate-log:export', 3, 2, 500, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1043, '登录查询', 'system:login-log:query', 3, 1, 501, '#', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1045, '日志导出', 'system:login-log:export', 3, 3, 501, '#', '#', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1046, '令牌列表', 'system:oauth2-token:page', 3, 1, 109, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-05-09 23:54:42', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1048, '令牌删除', 'system:oauth2-token:delete', 3, 2, 109, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-05-09 23:54:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1050, '任务新增', 'infra:job:create', 3, 2, 110, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1051, '任务修改', 'infra:job:update', 3, 3, 110, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1052, '任务删除', 'infra:job:delete', 3, 4, 110, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1053, '状态修改', 'infra:job:update', 3, 5, 110, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1054, '任务导出', 'infra:job:export', 3, 7, 110, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1056, '生成修改', 'infra:codegen:update', 3, 2, 115, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1057, '生成删除', 'infra:codegen:delete', 3, 3, 115, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1058, '导入代码', 'infra:codegen:create', 3, 2, 115, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1059, '预览代码', 'infra:codegen:preview', 3, 4, 115, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1060, '生成代码', 'infra:codegen:download', 3, 5, 115, '', '', '', null, 0, true, true, true, 'admin',
        '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1063, '设置角色菜单权限', 'system:permission:assign-role-menu', 3, 6, 101, '', '', '', null, 0, true, true,
        true, '', '2021-01-06 17:53:44', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1064, '设置角色数据权限', 'system:permission:assign-role-data-scope', 3, 7, 101, '', '', '', null, 0, true,
        true, true, '', '2021-01-06 17:56:31', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1065, '设置用户角色', 'system:permission:assign-user-role', 3, 8, 101, '', '', '', null, 0, true, true, true,
        '', '2021-01-07 10:23:28', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1066, '获得 Redis 监控信息', 'infra:redis:get-monitor-info', 3, 1, 113, '', '', '', null, 0, true, true, true,
        '', '2021-01-26 01:02:31', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1067, '获得 Redis Key 列表', 'infra:redis:get-key-list', 3, 2, 113, '', '', '', null, 0, true, true, true, '',
        '2021-01-26 01:02:52', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1070, '代码生成示例', 'infra:test-demo:query', 2, 1, 2, 'test-demo', 'validCode', 'infra/testDemo/index', null,
        0, true, true, true, '', '2021-02-06 12:42:49', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1071, '测试示例表创建', 'infra:test-demo:create', 3, 1, 1070, '', '', '', null, 0, true, true, true, '',
        '2021-02-06 12:42:49', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1072, '测试示例表更新', 'infra:test-demo:update', 3, 2, 1070, '', '', '', null, 0, true, true, true, '',
        '2021-02-06 12:42:49', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1073, '测试示例表删除', 'infra:test-demo:delete', 3, 3, 1070, '', '', '', null, 0, true, true, true, '',
        '2021-02-06 12:42:49', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1074, '测试示例表导出', 'infra:test-demo:export', 3, 4, 1070, '', '', '', null, 0, true, true, true, '',
        '2021-02-06 12:42:49', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1075, '任务触发', 'infra:job:trigger', 3, 8, 110, '', '', '', null, 0, true, true, true, '',
        '2021-02-07 13:03:10', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1076, '数据库文档', '', 2, 4, 2, 'db-doc', 'table', 'infra/dbDoc/index', 'InfraDBDoc', 0, true, true, true, '',
        '2021-02-08 01:41:47', '1', '2023-04-08 09:13:38', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1077, '监控平台', '', 2, 13, 2, 'skywalking', 'eye-open', 'infra/skywalking/index', 'InfraSkyWalking', 0, true,
        true, true, '', '2021-02-08 20:41:31', '1', '2023-04-08 10:39:06', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1078, '访问日志', '', 2, 1, 1083, 'api-access-log', 'log', 'infra/apiAccessLog/index', 'InfraApiAccessLog', 0,
        true, true, true, '', '2021-02-26 01:32:59', '1', '2023-04-08 10:31:34', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1082, '日志导出', 'infra:api-access-log:export', 3, 2, 1078, '', '', '', null, 0, true, true, true, '',
        '2021-02-26 01:32:59', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1083, 'API 日志', '', 2, 8, 2, 'log', 'log', null, null, 0, true, true, true, '', '2021-02-26 02:18:24', '1',
        '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1084, '错误日志', 'infra:api-error-log:query', 2, 2, 1083, 'api-error-log', 'log', 'infra/apiErrorLog/index',
        'InfraApiErrorLog', 0, true, true, true, '', '2021-02-26 07:53:20', '1', '2023-04-08 10:32:25', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1085, '日志处理', 'infra:api-error-log:update-status', 3, 2, 1084, '', '', '', null, 0, true, true, true, '',
        '2021-02-26 07:53:20', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1086, '日志导出', 'infra:api-error-log:export', 3, 3, 1084, '', '', '', null, 0, true, true, true, '',
        '2021-02-26 07:53:20', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1087, '任务查询', 'infra:job:query', 3, 1, 110, '', '', '', null, 0, true, true, true, '1',
        '2021-03-10 01:26:19', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1088, '日志查询', 'infra:api-access-log:query', 3, 1, 1078, '', '', '', null, 0, true, true, true, '1',
        '2021-03-10 01:28:04', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1089, '日志查询', 'infra:api-error-log:query', 3, 1, 1084, '', '', '', null, 0, true, true, true, '1',
        '2021-03-10 01:29:09', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1090, '文件列表', '', 2, 5, 1243, 'file', 'upload', 'infra/file/index', 'InfraFile', 0, true, true, true, '',
        '2021-03-12 20:16:20', '1', '2023-04-08 09:21:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1091, '文件查询', 'infra:file:query', 3, 1, 1090, '', '', '', null, 0, true, true, true, '',
        '2021-03-12 20:16:20', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1092, '文件删除', 'infra:file:delete', 3, 4, 1090, '', '', '', null, 0, true, true, true, '',
        '2021-03-12 20:16:20', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1093, '短信管理', '', 1, 11, 1, 'sms', 'validCode', null, null, 0, true, true, true, '1', '2021-04-05 01:10:16',
        '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1094, '短信渠道', '', 2, 0, 1093, 'sms-channel', 'phone', 'system/sms/channel/index', 'SystemSmsChannel', 0,
        true, true, true, '', '2021-04-01 11:07:15', '1', '2023-04-08 08:50:41', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1095, '短信渠道查询', 'system:sms-channel:query', 3, 1, 1094, '', '', '', null, 0, true, true, true, '',
        '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1096, '短信渠道创建', 'system:sms-channel:create', 3, 2, 1094, '', '', '', null, 0, true, true, true, '',
        '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1097, '短信渠道更新', 'system:sms-channel:update', 3, 3, 1094, '', '', '', null, 0, true, true, true, '',
        '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1098, '短信渠道删除', 'system:sms-channel:delete', 3, 4, 1094, '', '', '', null, 0, true, true, true, '',
        '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1100, '短信模板', '', 2, 1, 1093, 'sms-template', 'phone', 'system/sms/template/index', 'SystemSmsTemplate', 0,
        true, true, true, '', '2021-04-01 17:35:17', '1', '2023-04-08 08:50:50', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1101, '短信模板查询', 'system:sms-template:query', 3, 1, 1100, '', '', '', null, 0, true, true, true, '',
        '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1102, '短信模板创建', 'system:sms-template:create', 3, 2, 1100, '', '', '', null, 0, true, true, true, '',
        '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1103, '短信模板更新', 'system:sms-template:update', 3, 3, 1100, '', '', '', null, 0, true, true, true, '',
        '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1104, '短信模板删除', 'system:sms-template:delete', 3, 4, 1100, '', '', '', null, 0, true, true, true, '',
        '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1105, '短信模板导出', 'system:sms-template:export', 3, 5, 1100, '', '', '', null, 0, true, true, true, '',
        '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1106, '发送测试短信', 'system:sms-template:send-sms', 3, 6, 1100, '', '', '', null, 0, true, true, true, '1',
        '2021-04-11 00:26:40', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1107, '短信日志', '', 2, 2, 1093, 'sms-log', 'phone', 'system/sms/log/index', 'SystemSmsLog', 0, true, true,
        true, '', '2021-04-11 08:37:05', '1', '2023-04-08 08:50:58', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1108, '短信日志查询', 'system:sms-log:query', 3, 1, 1107, '', '', '', null, 0, true, true, true, '',
        '2021-04-11 08:37:05', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1109, '短信日志导出', 'system:sms-log:export', 3, 5, 1107, '', '', '', null, 0, true, true, true, '',
        '2021-04-11 08:37:05', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1110, '错误码管理', '', 2, 12, 1, 'error-code', 'code', 'system/errorCode/index', 'SystemErrorCode', 0, true,
        true, true, '', '2021-04-13 21:46:42', '1', '2023-04-08 09:01:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1111, '错误码查询', 'system:error-code:query', 3, 1, 1110, '', '', '', null, 0, true, true, true, '',
        '2021-04-13 21:46:42', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1112, '错误码创建', 'system:error-code:create', 3, 2, 1110, '', '', '', null, 0, true, true, true, '',
        '2021-04-13 21:46:42', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1113, '错误码更新', 'system:error-code:update', 3, 3, 1110, '', '', '', null, 0, true, true, true, '',
        '2021-04-13 21:46:42', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1114, '错误码删除', 'system:error-code:delete', 3, 4, 1110, '', '', '', null, 0, true, true, true, '',
        '2021-04-13 21:46:42', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1115, '错误码导出', 'system:error-code:export', 3, 5, 1110, '', '', '', null, 0, true, true, true, '',
        '2021-04-13 21:46:42', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1117, '支付管理', '', 1, 30, 0, '/pay', 'money', null, null, 0, true, true, true, '1', '2021-12-25 16:43:41',
        '1', '2022-12-10 16:33:19', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1118, '请假查询', '', 2, 0, 5, 'leave', 'user', 'bpm/oa/leave/index', 'BpmOALeave', 0, true, true, true, '',
        '2021-09-20 08:51:03', '1', '2023-04-08 11:30:40', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1119, '请假申请查询', 'bpm:oa-leave:query', 3, 1, 1118, '', '', '', null, 0, true, true, true, '',
        '2021-09-20 08:51:03', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1120, '请假申请创建', 'bpm:oa-leave:create', 3, 2, 1118, '', '', '', null, 0, true, true, true, '',
        '2021-09-20 08:51:03', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1126, '应用信息', '', 2, 1, 1117, 'app', 'table', 'pay/app/index', 'PayApp', 0, true, true, true, '',
        '2021-11-10 01:13:30', '1', '2023-07-20 12:13:32', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1127, '支付应用信息查询', 'pay:app:query', 3, 1, 1126, '', '', '', null, 0, true, true, true, '',
        '2021-11-10 01:13:31', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1128, '支付应用信息创建', 'pay:app:create', 3, 2, 1126, '', '', '', null, 0, true, true, true, '',
        '2021-11-10 01:13:31', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1129, '支付应用信息更新', 'pay:app:update', 3, 3, 1126, '', '', '', null, 0, true, true, true, '',
        '2021-11-10 01:13:31', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1130, '支付应用信息删除', 'pay:app:delete', 3, 4, 1126, '', '', '', null, 0, true, true, true, '',
        '2021-11-10 01:13:31', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1132, '秘钥解析', 'pay:channel:parsing', 3, 6, 1129, '', '', '', null, 0, true, true, true, '1',
        '2021-11-08 15:15:47', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1133, '支付商户信息查询', 'pay:merchant:query', 3, 1, 1132, '', '', '', null, 0, true, true, true, '',
        '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1134, '支付商户信息创建', 'pay:merchant:create', 3, 2, 1132, '', '', '', null, 0, true, true, true, '',
        '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1135, '支付商户信息更新', 'pay:merchant:update', 3, 3, 1132, '', '', '', null, 0, true, true, true, '',
        '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1136, '支付商户信息删除', 'pay:merchant:delete', 3, 4, 1132, '', '', '', null, 0, true, true, true, '',
        '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1137, '支付商户信息导出', 'pay:merchant:export', 3, 5, 1132, '', '', '', null, 0, true, true, true, '',
        '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1138, '租户列表', '', 2, 0, 1224, 'list', 'peoples', 'system/tenant/index', 'SystemTenant', 0, true, true, true,
        '', '2021-12-14 12:31:43', '1', '2023-04-08 08:29:08', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1139, '租户查询', 'system:tenant:query', 3, 1, 1138, '', '', '', null, 0, true, true, true, '',
        '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1140, '租户创建', 'system:tenant:create', 3, 2, 1138, '', '', '', null, 0, true, true, true, '',
        '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1141, '租户更新', 'system:tenant:update', 3, 3, 1138, '', '', '', null, 0, true, true, true, '',
        '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1142, '租户删除', 'system:tenant:delete', 3, 4, 1138, '', '', '', null, 0, true, true, true, '',
        '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1143, '租户导出', 'system:tenant:export', 3, 5, 1138, '', '', '', null, 0, true, true, true, '',
        '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1150, '秘钥解析', '', 3, 6, 1129, '', '', '', null, 0, true, true, true, '1', '2021-11-08 15:15:47', '1',
        '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1161, '退款订单', '', 2, 3, 1117, 'refund', 'order', 'pay/refund/index', 'PayRefund', 0, true, true, true, '',
        '2021-12-25 08:29:07', '1', '2023-04-08 10:46:02', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1162, '退款订单查询', 'pay:refund:query', 3, 1, 1161, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:29:07', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1163, '退款订单创建', 'pay:refund:create', 3, 2, 1161, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:29:07', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1164, '退款订单更新', 'pay:refund:update', 3, 3, 1161, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:29:07', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1165, '退款订单删除', 'pay:refund:delete', 3, 4, 1161, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:29:07', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1166, '退款订单导出', 'pay:refund:export', 3, 5, 1161, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:29:07', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1173, '支付订单', '', 2, 2, 1117, 'order', 'pay', 'pay/order/index', 'PayOrder', 0, true, true, true, '',
        '2021-12-25 08:49:43', '1', '2023-04-08 10:43:37', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1174, '支付订单查询', 'pay:order:query', 3, 1, 1173, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:49:43', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1175, '支付订单创建', 'pay:order:create', 3, 2, 1173, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:49:43', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1176, '支付订单更新', 'pay:order:update', 3, 3, 1173, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:49:43', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1177, '支付订单删除', 'pay:order:delete', 3, 4, 1173, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:49:43', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1178, '支付订单导出', 'pay:order:export', 3, 5, 1173, '', '', '', null, 0, true, true, true, '',
        '2021-12-25 08:49:43', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1185, '工作流程', '', 1, 50, 0, '/bpm', 'tool', null, null, 0, true, true, true, '1', '2021-12-30 20:26:36',
        '103', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1186, '流程管理', '', 1, 10, 1185, 'manager', 'nested', null, null, 0, true, true, true, '1',
        '2021-12-30 20:28:30', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1187, '流程表单', '', 2, 0, 1186, 'form', 'form', 'bpm/form/index', 'BpmForm', 0, true, true, true, '',
        '2021-12-30 12:38:22', '1', '2023-04-08 10:50:37', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1188, '表单查询', 'bpm:form:query', 3, 1, 1187, '', '', '', null, 0, true, true, true, '',
        '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1189, '表单创建', 'bpm:form:create', 3, 2, 1187, '', '', '', null, 0, true, true, true, '',
        '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1190, '表单更新', 'bpm:form:update', 3, 3, 1187, '', '', '', null, 0, true, true, true, '',
        '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1191, '表单删除', 'bpm:form:delete', 3, 4, 1187, '', '', '', null, 0, true, true, true, '',
        '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1192, '表单导出', 'bpm:form:export', 3, 5, 1187, '', '', '', null, 0, true, true, true, '',
        '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1193, '流程模型', '', 2, 5, 1186, 'model', 'guide', 'bpm/model/index', 'BpmModel', 0, true, true, true, '1',
        '2021-12-31 23:24:58', '1', '2023-04-08 10:53:38', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1194, '模型查询', 'bpm:model:query', 3, 1, 1193, '', '', '', null, 0, true, true, true, '1',
        '2022-01-03 19:01:10', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1195, '模型创建', 'bpm:model:create', 3, 2, 1193, '', '', '', null, 0, true, true, true, '1',
        '2022-01-03 19:01:24', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1196, '模型导入', 'bpm:model:import', 3, 3, 1193, '', '', '', null, 0, true, true, true, '1',
        '2022-01-03 19:01:35', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1197, '模型更新', 'bpm:model:update', 3, 4, 1193, '', '', '', null, 0, true, true, true, '1',
        '2022-01-03 19:02:28', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1198, '模型删除', 'bpm:model:delete', 3, 5, 1193, '', '', '', null, 0, true, true, true, '1',
        '2022-01-03 19:02:43', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1199, '模型发布', 'bpm:model:deploy', 3, 6, 1193, '', '', '', null, 0, true, true, true, '1',
        '2022-01-03 19:03:24', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1200, '任务管理', '', 1, 20, 1185, 'task', 'cascader', null, null, 0, true, true, true, '1',
        '2022-01-07 23:51:48', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1201, '我的流程', '', 2, 0, 1200, 'my', 'people', 'bpm/processInstance/index', 'BpmProcessInstance', 0, true,
        true, true, '', '2022-01-07 15:53:44', '1', '2023-04-08 11:16:55', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1202, '流程实例的查询', 'bpm:process-instance:query', 3, 1, 1201, '', '', '', null, 0, true, true, true, '',
        '2022-01-07 15:53:44', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1207, '待办任务', '', 2, 10, 1200, 'todo', 'eye-open', 'bpm/task/todo/index', 'BpmTodoTask', 0, true, true,
        true, '1', '2022-01-08 10:33:37', '1', '2023-04-08 11:29:08', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1208, '已办任务', '', 2, 20, 1200, 'done', 'eye', 'bpm/task/done/index', 'BpmDoneTask', 0, true, true, true,
        '1', '2022-01-08 10:34:13', '1', '2023-04-08 11:29:00', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1209, '用户分组', '', 2, 2, 1186, 'user-group', 'people', 'bpm/group/index', 'BpmUserGroup', 0, true, true,
        true, '', '2022-01-14 02:14:20', '1', '2023-04-08 10:51:06', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1210, '用户组查询', 'bpm:user-group:query', 3, 1, 1209, '', '', '', null, 0, true, true, true, '',
        '2022-01-14 02:14:20', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1211, '用户组创建', 'bpm:user-group:create', 3, 2, 1209, '', '', '', null, 0, true, true, true, '',
        '2022-01-14 02:14:20', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1212, '用户组更新', 'bpm:user-group:update', 3, 3, 1209, '', '', '', null, 0, true, true, true, '',
        '2022-01-14 02:14:20', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1213, '用户组删除', 'bpm:user-group:delete', 3, 4, 1209, '', '', '', null, 0, true, true, true, '',
        '2022-01-14 02:14:20', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1215, '流程定义查询', 'bpm:process-definition:query', 3, 10, 1193, '', '', '', null, 0, true, true, true, '1',
        '2022-01-23 00:21:43', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1216, '流程任务分配规则查询', 'bpm:task-assign-rule:query', 3, 20, 1193, '', '', '', null, 0, true, true, true,
        '1', '2022-01-23 00:26:53', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1217, '流程任务分配规则创建', 'bpm:task-assign-rule:create', 3, 21, 1193, '', '', '', null, 0, true, true, true,
        '1', '2022-01-23 00:28:15', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1218, '流程任务分配规则更新', 'bpm:task-assign-rule:update', 3, 22, 1193, '', '', '', null, 0, true, true, true,
        '1', '2022-01-23 00:28:41', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1219, '流程实例的创建', 'bpm:process-instance:create', 3, 2, 1201, '', '', '', null, 0, true, true, true, '1',
        '2022-01-23 00:36:15', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1220, '流程实例的取消', 'bpm:process-instance:cancel', 3, 3, 1201, '', '', '', null, 0, true, true, true, '1',
        '2022-01-23 00:36:33', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1221, '流程任务的查询', 'bpm:task:query', 3, 1, 1207, '', '', '', null, 0, true, true, true, '1',
        '2022-01-23 00:38:52', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1222, '流程任务的更新', 'bpm:task:update', 3, 2, 1207, '', '', '', null, 0, true, true, true, '1',
        '2022-01-23 00:39:24', '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1224, '租户管理', '', 2, 0, 1, 'tenant', 'peoples', null, null, 0, true, true, true, '1', '2022-02-20 01:41:13',
        '1', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1225, '租户套餐', '', 2, 0, 1224, 'package', 'eye', 'system/tenantPackage/index', 'SystemTenantPackage', 0,
        true, true, true, '', '2022-02-19 17:44:06', '1', '2023-04-08 08:17:08', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1226, '租户套餐查询', 'system:tenant-package:query', 3, 1, 1225, '', '', '', null, 0, true, true, true, '',
        '2022-02-19 17:44:06', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1227, '租户套餐创建', 'system:tenant-package:create', 3, 2, 1225, '', '', '', null, 0, true, true, true, '',
        '2022-02-19 17:44:06', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1228, '租户套餐更新', 'system:tenant-package:update', 3, 3, 1225, '', '', '', null, 0, true, true, true, '',
        '2022-02-19 17:44:06', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1229, '租户套餐删除', 'system:tenant-package:delete', 3, 4, 1225, '', '', '', null, 0, true, true, true, '',
        '2022-02-19 17:44:06', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1237, '文件配置', '', 2, 0, 1243, 'file-config', 'config', 'infra/fileConfig/index', 'InfraFileConfig', 0, true,
        true, true, '', '2022-03-15 14:35:28', '1', '2023-04-08 09:16:05', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1238, '文件配置查询', 'infra:file-config:query', 3, 1, 1237, '', '', '', null, 0, true, true, true, '',
        '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1239, '文件配置创建', 'infra:file-config:create', 3, 2, 1237, '', '', '', null, 0, true, true, true, '',
        '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1240, '文件配置更新', 'infra:file-config:update', 3, 3, 1237, '', '', '', null, 0, true, true, true, '',
        '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1241, '文件配置删除', 'infra:file-config:delete', 3, 4, 1237, '', '', '', null, 0, true, true, true, '',
        '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1242, '文件配置导出', 'infra:file-config:export', 3, 5, 1237, '', '', '', null, 0, true, true, true, '',
        '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1243, '文件管理', '', 2, 5, 2, 'file', 'download', null, '', 0, true, true, true, '1', '2022-03-16 23:47:40',
        '1', '2023-02-10 13:47:46', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1247, '敏感词管理', '', 2, 13, 1, 'sensitive-word', 'education', 'system/sensitiveWord/index',
        'SystemSensitiveWord', 0, true, true, true, '', '2022-04-07 16:55:03', '1', '2023-04-08 09:00:40', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1248, '敏感词查询', 'system:sensitive-word:query', 3, 1, 1247, '', '', '', null, 0, true, true, true, '',
        '2022-04-07 16:55:03', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1249, '敏感词创建', 'system:sensitive-word:create', 3, 2, 1247, '', '', '', null, 0, true, true, true, '',
        '2022-04-07 16:55:03', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1250, '敏感词更新', 'system:sensitive-word:update', 3, 3, 1247, '', '', '', null, 0, true, true, true, '',
        '2022-04-07 16:55:03', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1251, '敏感词删除', 'system:sensitive-word:delete', 3, 4, 1247, '', '', '', null, 0, true, true, true, '',
        '2022-04-07 16:55:03', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1252, '敏感词导出', 'system:sensitive-word:export', 3, 5, 1247, '', '', '', null, 0, true, true, true, '',
        '2022-04-07 16:55:03', '', '2022-04-20 17:03:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1254, '作者动态', '', 1, 0, 0, 'https://www.iocoder.cn', 'people', null, null, 0, true, true, true, '1',
        '2022-04-23 01:03:15', '1', '2023-02-10 00:06:52', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1255, '数据源配置', '', 2, 1, 2, 'data-source-config', 'rate', 'infra/dataSourceConfig/index',
        'InfraDataSourceConfig', 0, true, true, true, '', '2022-04-27 14:37:32', '1', '2023-04-08 09:05:21', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1256, '数据源配置查询', 'infra:data-source-config:query', 3, 1, 1255, '', '', '', null, 0, true, true, true, '',
        '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1257, '数据源配置创建', 'infra:data-source-config:create', 3, 2, 1255, '', '', '', null, 0, true, true, true,
        '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1258, '数据源配置更新', 'infra:data-source-config:update', 3, 3, 1255, '', '', '', null, 0, true, true, true,
        '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1259, '数据源配置删除', 'infra:data-source-config:delete', 3, 4, 1255, '', '', '', null, 0, true, true, true,
        '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1260, '数据源配置导出', 'infra:data-source-config:export', 3, 5, 1255, '', '', '', null, 0, true, true, true,
        '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1261, 'OAuth 2.0', '', 1, 10, 1, 'oauth2', 'people', null, null, 0, true, true, true, '1',
        '2022-05-09 23:38:17', '1', '2022-05-11 23:51:46', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1263, '应用管理', '', 2, 0, 1261, 'oauth2/application', 'tool', 'system/oauth2/client/index',
        'SystemOAuth2Client', 0, true, true, true, '', '2022-05-10 16:26:33', '1', '2023-04-08 08:47:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1264, '客户端查询', 'system:oauth2-client:query', 3, 1, 1263, '', '', '', null, 0, true, true, true, '',
        '2022-05-10 16:26:33', '1', '2022-05-11 00:31:06', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1265, '客户端创建', 'system:oauth2-client:create', 3, 2, 1263, '', '', '', null, 0, true, true, true, '',
        '2022-05-10 16:26:33', '1', '2022-05-11 00:31:23', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1266, '客户端更新', 'system:oauth2-client:update', 3, 3, 1263, '', '', '', null, 0, true, true, true, '',
        '2022-05-10 16:26:33', '1', '2022-05-11 00:31:28', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1267, '客户端删除', 'system:oauth2-client:delete', 3, 4, 1263, '', '', '', null, 0, true, true, true, '',
        '2022-05-10 16:26:33', '1', '2022-05-11 00:31:33', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1281, '报表管理', '', 1, 40, 0, '/report', 'chart', null, null, 0, true, true, true, '1', '2022-07-10 20:22:15',
        '1', '2023-02-07 17:16:40', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (1282, '报表设计器', '', 2, 1, 1281, 'jimu-report', 'example', 'report/jmreport/index', 'GoView', 0, true, true,
        true, '1', '2022-07-10 20:26:36', '1', '2023-04-08 10:47:59', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2000, '商品中心', '', 1, 60, 0, '/product', 'merchant', null, null, 0, true, true, true, '',
        '2022-07-29 15:53:53', '1', '2022-07-30 22:26:19', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2002, '商品分类', '', 2, 2, 2000, 'category', 'dict', 'mall/product/category/index', 'ProductCategory', 0, true,
        true, true, '', '2022-07-29 15:53:53', '1', '2023-04-08 11:34:59', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2003, '分类查询', 'product:category:query', 3, 1, 2002, '', '', '', null, 0, true, true, true, '',
        '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2004, '分类创建', 'product:category:create', 3, 2, 2002, '', '', '', null, 0, true, true, true, '',
        '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2005, '分类更新', 'product:category:update', 3, 3, 2002, '', '', '', null, 0, true, true, true, '',
        '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2006, '分类删除', 'product:category:delete', 3, 4, 2002, '', '', '', null, 0, true, true, true, '',
        '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2008, '商品品牌', '', 2, 3, 2000, 'brand', 'dashboard', 'mall/product/brand/index', 'ProductBrand', 0, true,
        true, true, '', '2022-07-30 13:52:44', '1', '2023-04-08 11:35:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2009, '品牌查询', 'product:brand:query', 3, 1, 2008, '', '', '', null, 0, true, true, true, '',
        '2022-07-30 13:52:44', '', '2022-07-30 13:52:44', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2010, '品牌创建', 'product:brand:create', 3, 2, 2008, '', '', '', null, 0, true, true, true, '',
        '2022-07-30 13:52:44', '', '2022-07-30 13:52:44', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2011, '品牌更新', 'product:brand:update', 3, 3, 2008, '', '', '', null, 0, true, true, true, '',
        '2022-07-30 13:52:44', '', '2022-07-30 13:52:44', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2012, '品牌删除', 'product:brand:delete', 3, 4, 2008, '', '', '', null, 0, true, true, true, '',
        '2022-07-30 13:52:44', '', '2022-07-30 13:52:44', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2014, '商品列表', '', 2, 1, 2000, 'spu', 'list', 'mall/product/spu/index', 'ProductSpu', 0, true, true, true,
        '', '2022-07-30 14:22:58', '1', '2023-04-08 11:34:47', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2015, '商品查询', 'product:spu:query', 3, 1, 2014, '', '', '', null, 0, true, true, true, '',
        '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2016, '商品创建', 'product:spu:create', 3, 2, 2014, '', '', '', null, 0, true, true, true, '',
        '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2017, '商品更新', 'product:spu:update', 3, 3, 2014, '', '', '', null, 0, true, true, true, '',
        '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2018, '商品删除', 'product:spu:delete', 3, 4, 2014, '', '', '', null, 0, true, true, true, '',
        '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2019, '商品属性', '', 2, 3, 2000, 'property', 'eye', 'mall/product/property/index', 'ProductProperty', 0, true,
        true, true, '', '2022-08-01 14:55:35', '1', '2023-04-08 11:35:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2020, '规格查询', 'product:property:query', 3, 1, 2019, '', '', '', null, 0, true, true, true, '',
        '2022-08-01 14:55:35', '', '2022-12-12 20:26:24', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2021, '规格创建', 'product:property:create', 3, 2, 2019, '', '', '', null, 0, true, true, true, '',
        '2022-08-01 14:55:35', '', '2022-12-12 20:26:30', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2022, '规格更新', 'product:property:update', 3, 3, 2019, '', '', '', null, 0, true, true, true, '',
        '2022-08-01 14:55:35', '', '2022-12-12 20:26:33', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2023, '规格删除', 'product:property:delete', 3, 4, 2019, '', '', '', null, 0, true, true, true, '',
        '2022-08-01 14:55:35', '', '2022-12-12 20:26:37', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2025, 'Banner管理', '', 2, 100, 2000, 'banner', '', 'mall/market/banner/index', null, 0, true, true, true, '',
        '2022-08-01 14:56:14', '1', '2022-10-24 22:29:39', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2026, 'Banner查询', 'market:banner:query', 3, 1, 2025, '', '', '', null, 0, true, true, true, '',
        '2022-08-01 14:56:14', '', '2022-08-01 14:56:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2027, 'Banner创建', 'market:banner:create', 3, 2, 2025, '', '', '', null, 0, true, true, true, '',
        '2022-08-01 14:56:14', '', '2022-08-01 14:56:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2028, 'Banner更新', 'market:banner:update', 3, 3, 2025, '', '', '', null, 0, true, true, true, '',
        '2022-08-01 14:56:14', '', '2022-08-01 14:56:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2029, 'Banner删除', 'market:banner:delete', 3, 4, 2025, '', '', '', null, 0, true, true, true, '',
        '2022-08-01 14:56:14', '', '2022-08-01 14:56:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2030, '营销中心', '', 1, 70, 0, '/promotion', 'rate', null, null, 0, true, true, true, '1',
        '2022-10-31 21:25:09', '1', '2022-10-31 21:25:09', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2032, '优惠劵', '', 2, 2, 2030, 'coupon-template', 'textarea', 'mall/promotion/couponTemplate/index',
        'PromotionCouponTemplate', 0, true, true, true, '', '2022-10-31 22:27:14', '1', '2023-04-08 11:44:23', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2033, '优惠劵模板查询', 'promotion:coupon-template:query', 3, 1, 2032, '', '', '', null, 0, true, true, true,
        '', '2022-10-31 22:27:14', '', '2022-10-31 22:27:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2034, '优惠劵模板创建', 'promotion:coupon-template:create', 3, 2, 2032, '', '', '', null, 0, true, true, true,
        '', '2022-10-31 22:27:14', '', '2022-10-31 22:27:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2035, '优惠劵模板更新', 'promotion:coupon-template:update', 3, 3, 2032, '', '', '', null, 0, true, true, true,
        '', '2022-10-31 22:27:14', '', '2022-10-31 22:27:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2036, '优惠劵模板删除', 'promotion:coupon-template:delete', 3, 4, 2032, '', '', '', null, 0, true, true, true,
        '', '2022-10-31 22:27:14', '', '2022-10-31 22:27:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2038, '会员优惠劵', '', 2, 2, 2030, 'coupon', '', 'mall/promotion/coupon/index', 'PromotionCoupon', 0, false,
        true, true, '', '2022-11-03 23:21:31', '1', '2023-04-08 11:44:17', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2039, '优惠劵查询', 'promotion:coupon:query', 3, 1, 2038, '', '', '', null, 0, true, true, true, '',
        '2022-11-03 23:21:31', '', '2022-11-03 23:21:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2040, '优惠劵删除', 'promotion:coupon:delete', 3, 4, 2038, '', '', '', null, 0, true, true, true, '',
        '2022-11-03 23:21:31', '', '2022-11-03 23:21:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2041, '满减送活动', '', 2, 10, 2030, 'reward-activity', 'radio', 'mall/promotion/rewardActivity/index',
        'PromotionRewardActivity', 0, true, true, true, '', '2022-11-04 23:47:49', '1', '2023-04-08 11:45:35', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2042, '满减送活动查询', 'promotion:reward-activity:query', 3, 1, 2041, '', '', '', null, 0, true, true, true,
        '', '2022-11-04 23:47:49', '', '2022-11-04 23:47:49', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2043, '满减送活动创建', 'promotion:reward-activity:create', 3, 2, 2041, '', '', '', null, 0, true, true, true,
        '', '2022-11-04 23:47:49', '', '2022-11-04 23:47:49', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2044, '满减送活动更新', 'promotion:reward-activity:update', 3, 3, 2041, '', '', '', null, 0, true, true, true,
        '', '2022-11-04 23:47:50', '', '2022-11-04 23:47:50', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2045, '满减送活动删除', 'promotion:reward-activity:delete', 3, 4, 2041, '', '', '', null, 0, true, true, true,
        '', '2022-11-04 23:47:50', '', '2022-11-04 23:47:50', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2046, '满减送活动关闭', 'promotion:reward-activity:close', 3, 5, 2041, '', '', '', null, 0, true, true, true,
        '1', '2022-11-05 10:42:53', '1', '2022-11-05 10:42:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2047, '限时折扣活动', '', 2, 7, 2030, 'discount-activity', 'time', 'mall/promotion/discountActivity/index',
        'PromotionDiscountActivity', 0, true, true, true, '', '2022-11-05 17:12:15', '1', '2023-04-08 11:45:44', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2048, '限时折扣活动查询', 'promotion:discount-activity:query', 3, 1, 2047, '', '', '', null, 0, true, true,
        true, '', '2022-11-05 17:12:15', '', '2022-11-05 17:12:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2049, '限时折扣活动创建', 'promotion:discount-activity:create', 3, 2, 2047, '', '', '', null, 0, true, true,
        true, '', '2022-11-05 17:12:15', '', '2022-11-05 17:12:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2050, '限时折扣活动更新', 'promotion:discount-activity:update', 3, 3, 2047, '', '', '', null, 0, true, true,
        true, '', '2022-11-05 17:12:16', '', '2022-11-05 17:12:16', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2051, '限时折扣活动删除', 'promotion:discount-activity:delete', 3, 4, 2047, '', '', '', null, 0, true, true,
        true, '', '2022-11-05 17:12:16', '', '2022-11-05 17:12:16', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2052, '限时折扣活动关闭', 'promotion:discount-activity:close', 3, 5, 2047, '', '', '', null, 0, true, true,
        true, '', '2022-11-05 17:12:16', '', '2022-11-05 17:12:16', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2059, '秒杀商品', '', 2, 2, 2209, 'activity', 'ep:basketball', 'mall/promotion/seckill/activity/index',
        'PromotionSeckillActivity', 0, true, true, true, '', '2022-11-06 22:24:49', '1', '2023-06-24 18:57:25', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2060, '秒杀活动查询', 'promotion:seckill-activity:query', 3, 1, 2059, '', '', '', null, 0, true, true, true, '',
        '2022-11-06 22:24:49', '', '2022-11-06 22:24:49', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2061, '秒杀活动创建', 'promotion:seckill-activity:create', 3, 2, 2059, '', '', '', null, 0, true, true, true,
        '', '2022-11-06 22:24:49', '', '2022-11-06 22:24:49', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2062, '秒杀活动更新', 'promotion:seckill-activity:update', 3, 3, 2059, '', '', '', null, 0, true, true, true,
        '', '2022-11-06 22:24:49', '', '2022-11-06 22:24:49', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2063, '秒杀活动删除', 'promotion:seckill-activity:delete', 3, 4, 2059, '', '', '', null, 0, true, true, true,
        '', '2022-11-06 22:24:49', '', '2022-11-06 22:24:49', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2064, '秒杀活动导出', 'promotion:seckill-activity:export', 3, 5, 2059, '', '', '', null, 0, true, true, true,
        '', '2022-11-06 22:24:49', '', '2022-11-06 22:24:49', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2066, '秒杀时段', '', 2, 1, 2209, 'config', 'ep:baseball', 'mall/promotion/seckill/config/index',
        'PromotionSeckillConfig', 0, true, true, true, '', '2022-11-15 19:46:50', '1', '2023-06-24 18:57:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2067, '秒杀时段查询', 'promotion:seckill-config:query', 3, 1, 2066, '', '', '', '', 0, true, true, true, '',
        '2022-11-15 19:46:51', '1', '2023-06-24 17:50:25', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2068, '秒杀时段创建', 'promotion:seckill-config:create', 3, 2, 2066, '', '', '', '', 0, true, true, true, '',
        '2022-11-15 19:46:51', '1', '2023-06-24 17:48:39', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2069, '秒杀时段更新', 'promotion:seckill-config:update', 3, 3, 2066, '', '', '', '', 0, true, true, true, '',
        '2022-11-15 19:46:51', '1', '2023-06-24 17:50:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2070, '秒杀时段删除', 'promotion:seckill-config:delete', 3, 4, 2066, '', '', '', '', 0, true, true, true, '',
        '2022-11-15 19:46:51', '1', '2023-06-24 17:50:32', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2072, '订单中心', '', 1, 65, 0, '/trade', 'order', null, null, 0, true, true, true, '1', '2022-11-19 18:57:19',
        '1', '2022-12-10 16:32:57', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2073, '售后退款', '', 2, 1, 2072, 'trade/after-sale', 'education', 'mall/trade/afterSale/index',
        'TradeAfterSale', 0, true, true, true, '', '2022-11-19 20:15:32', '1', '2023-04-08 11:43:19', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2074, '售后查询', 'trade:after-sale:query', 3, 1, 2073, '', '', '', null, 0, true, true, true, '',
        '2022-11-19 20:15:33', '1', '2022-12-10 21:04:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2075, '秒杀活动关闭', 'promotion:sekill-activity:close', 3, 6, 2059, '', '', '', null, 0, true, true, true, '1',
        '2022-11-28 20:20:15', '1', '2022-11-28 20:20:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2076, '订单列表', '', 2, 0, 2072, 'trade/order', 'list', 'mall/trade/order/index', 'TradeOrder', 0, true, true,
        true, '1', '2022-12-10 21:05:44', '1', '2023-04-08 11:42:23', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2083, '地区管理', '', 2, 14, 1, 'area', 'row', 'system/area/index', 'SystemArea', 0, true, true, true, '1',
        '2022-12-23 17:35:05', '1', '2023-04-08 09:01:37', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2084, '公众号管理', '', 1, 100, 0, '/mp', 'wechat', null, null, 0, true, true, true, '1', '2023-01-01 20:11:04',
        '1', '2023-01-15 11:28:57', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2085, '账号管理', '', 2, 1, 2084, 'account', 'phone', 'mp/account/index', 'MpAccount', 0, true, true, true, '1',
        '2023-01-01 20:13:31', '1', '2023-02-09 23:56:39', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2086, '新增账号', 'mp:account:create', 3, 1, 2085, '', '', '', null, 0, true, true, true, '1',
        '2023-01-01 20:21:40', '1', '2023-01-07 17:32:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2087, '修改账号', 'mp:account:update', 3, 2, 2085, '', '', '', null, 0, true, true, true, '1',
        '2023-01-07 17:32:46', '1', '2023-01-07 17:32:46', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2088, '查询账号', 'mp:account:query', 3, 0, 2085, '', '', '', null, 0, true, true, true, '1',
        '2023-01-07 17:33:07', '1', '2023-01-07 17:33:07', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2089, '删除账号', 'mp:account:delete', 3, 3, 2085, '', '', '', null, 0, true, true, true, '1',
        '2023-01-07 17:33:21', '1', '2023-01-07 17:33:21', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2090, '生成二维码', 'mp:account:qr-code', 3, 4, 2085, '', '', '', null, 0, true, true, true, '1',
        '2023-01-07 17:33:58', '1', '2023-01-07 17:33:58', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2091, '清空 API 配额', 'mp:account:clear-quota', 3, 5, 2085, '', '', '', null, 0, true, true, true, '1',
        '2023-01-07 18:20:32', '1', '2023-01-07 18:20:59', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2092, '数据统计', 'mp:statistics:query', 2, 2, 2084, 'statistics', 'chart', 'mp/statistics/index',
        'MpStatistics', 0, true, true, true, '1', '2023-01-07 20:17:36', '1', '2023-02-09 23:58:34', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2093, '标签管理', '', 2, 3, 2084, 'tag', 'rate', 'mp/tag/index', 'MpTag', 0, true, true, true, '1',
        '2023-01-08 11:37:32', '1', '2023-02-09 23:58:47', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2094, '查询标签', 'mp:tag:query', 3, 0, 2093, '', '', '', null, 0, true, true, true, '1', '2023-01-08 11:59:03',
        '1', '2023-01-08 11:59:03', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2095, '新增标签', 'mp:tag:create', 3, 1, 2093, '', '', '', null, 0, true, true, true, '1',
        '2023-01-08 11:59:23', '1', '2023-01-08 11:59:23', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2096, '修改标签', 'mp:tag:update', 3, 2, 2093, '', '', '', null, 0, true, true, true, '1',
        '2023-01-08 11:59:41', '1', '2023-01-08 11:59:41', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2097, '删除标签', 'mp:tag:delete', 3, 3, 2093, '', '', '', null, 0, true, true, true, '1',
        '2023-01-08 12:00:04', '1', '2023-01-08 12:00:13', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2098, '同步标签', 'mp:tag:sync', 3, 4, 2093, '', '', '', null, 0, true, true, true, '1', '2023-01-08 12:00:29',
        '1', '2023-01-08 12:00:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2099, '粉丝管理', '', 2, 4, 2084, 'user', 'people', 'mp/user/index', 'MpUser', 0, true, true, true, '1',
        '2023-01-08 16:51:20', '1', '2023-02-09 23:58:21', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2100, '查询粉丝', 'mp:user:query', 3, 0, 2099, '', '', '', null, 0, true, true, true, '1',
        '2023-01-08 17:16:59', '1', '2023-01-08 17:17:23', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2101, '修改粉丝', 'mp:user:update', 3, 1, 2099, '', '', '', null, 0, true, true, true, '1',
        '2023-01-08 17:17:11', '1', '2023-01-08 17:17:11', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2102, '同步粉丝', 'mp:user:sync', 3, 2, 2099, '', '', '', null, 0, true, true, true, '1', '2023-01-08 17:17:40',
        '1', '2023-01-08 17:17:40', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2103, '消息管理', '', 2, 5, 2084, 'message', 'email', 'mp/message/index', 'MpMessage', 0, true, true, true, '1',
        '2023-01-08 18:44:19', '1', '2023-02-09 23:58:02', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2104, '图文发表记录', '', 2, 10, 2084, 'free-publish', 'education', 'mp/freePublish/index', 'MpFreePublish', 0,
        true, true, true, '1', '2023-01-13 00:30:50', '1', '2023-02-09 23:57:22', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2105, '查询发布列表', 'mp:free-publish:query', 3, 1, 2104, '', '', '', null, 0, true, true, true, '1',
        '2023-01-13 07:19:17', '1', '2023-01-13 07:19:17', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2106, '发布草稿', 'mp:free-publish:submit', 3, 2, 2104, '', '', '', null, 0, true, true, true, '1',
        '2023-01-13 07:19:46', '1', '2023-01-13 07:19:46', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2107, '删除发布记录', 'mp:free-publish:delete', 3, 3, 2104, '', '', '', null, 0, true, true, true, '1',
        '2023-01-13 07:20:01', '1', '2023-01-13 07:20:01', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2108, '图文草稿箱', '', 2, 9, 2084, 'draft', 'edit', 'mp/draft/index', 'MpDraft', 0, true, true, true, '1',
        '2023-01-13 07:40:21', '1', '2023-02-09 23:56:58', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2109, '新建草稿', 'mp:draft:create', 3, 1, 2108, '', '', '', null, 0, true, true, true, '1',
        '2023-01-13 23:15:30', '1', '2023-01-13 23:15:44', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2110, '修改草稿', 'mp:draft:update', 3, 2, 2108, '', '', '', null, 0, true, true, true, '1',
        '2023-01-14 10:08:47', '1', '2023-01-14 10:08:47', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2111, '查询草稿', 'mp:draft:query', 3, 0, 2108, '', '', '', null, 0, true, true, true, '1',
        '2023-01-14 10:09:01', '1', '2023-01-14 10:09:01', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2112, '删除草稿', 'mp:draft:delete', 3, 3, 2108, '', '', '', null, 0, true, true, true, '1',
        '2023-01-14 10:09:19', '1', '2023-01-14 10:09:19', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2113, '素材管理', '', 2, 8, 2084, 'material', 'skill', 'mp/material/index', 'MpMaterial', 0, true, true, true,
        '1', '2023-01-14 14:12:07', '1', '2023-02-09 23:57:36', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2114, '上传临时素材', 'mp:material:upload-temporary', 3, 1, 2113, '', '', '', null, 0, true, true, true, '1',
        '2023-01-14 15:33:55', '1', '2023-01-14 15:33:55', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2115, '上传永久素材', 'mp:material:upload-permanent', 3, 2, 2113, '', '', '', null, 0, true, true, true, '1',
        '2023-01-14 15:34:14', '1', '2023-01-14 15:34:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2116, '删除素材', 'mp:material:delete', 3, 3, 2113, '', '', '', null, 0, true, true, true, '1',
        '2023-01-14 15:35:37', '1', '2023-01-14 15:35:37', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2117, '上传图文图片', 'mp:material:upload-news-image', 3, 4, 2113, '', '', '', null, 0, true, true, true, '1',
        '2023-01-14 15:36:31', '1', '2023-01-14 15:36:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2118, '查询素材', 'mp:material:query', 3, 5, 2113, '', '', '', null, 0, true, true, true, '1',
        '2023-01-14 15:39:22', '1', '2023-01-14 15:39:22', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2119, '菜单管理', '', 2, 6, 2084, 'menu', 'button', 'mp/menu/index', 'MpMenu', 0, true, true, true, '1',
        '2023-01-14 17:43:54', '1', '2023-02-09 23:57:50', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2120, '自动回复', '', 2, 7, 2084, 'auto-reply', 'eye', 'mp/autoReply/index', 'MpAutoReply', 0, true, true, true,
        '1', '2023-01-15 22:13:09', '1', '2023-02-09 23:56:28', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2121, '查询回复', 'mp:auto-reply:query', 3, 0, 2120, '', '', '', null, 0, true, true, true, '1',
        '2023-01-16 22:28:41', '1', '2023-01-16 22:28:41', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2122, '新增回复', 'mp:auto-reply:create', 3, 1, 2120, '', '', '', null, 0, true, true, true, '1',
        '2023-01-16 22:28:54', '1', '2023-01-16 22:28:54', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2123, '修改回复', 'mp:auto-reply:update', 3, 2, 2120, '', '', '', null, 0, true, true, true, '1',
        '2023-01-16 22:29:05', '1', '2023-01-16 22:29:05', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2124, '删除回复', 'mp:auto-reply:delete', 3, 3, 2120, '', '', '', null, 0, true, true, true, '1',
        '2023-01-16 22:29:34', '1', '2023-01-16 22:29:34', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2125, '查询菜单', 'mp:menu:query', 3, 0, 2119, '', '', '', null, 0, true, true, true, '1',
        '2023-01-17 23:05:41', '1', '2023-01-17 23:05:41', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2126, '保存菜单', 'mp:menu:save', 3, 1, 2119, '', '', '', null, 0, true, true, true, '1', '2023-01-17 23:06:01',
        '1', '2023-01-17 23:06:01', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2127, '删除菜单', 'mp:menu:delete', 3, 2, 2119, '', '', '', null, 0, true, true, true, '1',
        '2023-01-17 23:06:16', '1', '2023-01-17 23:06:16', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2128, '查询消息', 'mp:message:query', 3, 0, 2103, '', '', '', null, 0, true, true, true, '1',
        '2023-01-17 23:07:14', '1', '2023-01-17 23:07:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2129, '发送消息', 'mp:message:send', 3, 1, 2103, '', '', '', null, 0, true, true, true, '1',
        '2023-01-17 23:07:26', '1', '2023-01-17 23:07:26', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2130, '邮箱管理', '', 2, 11, 1, 'mail', 'email', null, null, 0, true, true, true, '1', '2023-01-25 17:27:44',
        '1', '2023-01-25 17:27:44', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2131, '邮箱账号', '', 2, 0, 2130, 'mail-account', 'user', 'system/mail/account/index', 'SystemMailAccount', 0,
        true, true, true, '', '2023-01-25 09:33:48', '1', '2023-04-08 08:53:43', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2132, '账号查询', 'system:mail-account:query', 3, 1, 2131, '', '', '', null, 0, true, true, true, '',
        '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2133, '账号创建', 'system:mail-account:create', 3, 2, 2131, '', '', '', null, 0, true, true, true, '',
        '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2134, '账号更新', 'system:mail-account:update', 3, 3, 2131, '', '', '', null, 0, true, true, true, '',
        '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2135, '账号删除', 'system:mail-account:delete', 3, 4, 2131, '', '', '', null, 0, true, true, true, '',
        '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2136, '邮件模版', '', 2, 0, 2130, 'mail-template', 'education', 'system/mail/template/index',
        'SystemMailTemplate', 0, true, true, true, '', '2023-01-25 12:05:31', '1', '2023-04-08 08:53:34', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2137, '模版查询', 'system:mail-template:query', 3, 1, 2136, '', '', '', null, 0, true, true, true, '',
        '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2138, '模版创建', 'system:mail-template:create', 3, 2, 2136, '', '', '', null, 0, true, true, true, '',
        '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2139, '模版更新', 'system:mail-template:update', 3, 3, 2136, '', '', '', null, 0, true, true, true, '',
        '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2140, '模版删除', 'system:mail-template:delete', 3, 4, 2136, '', '', '', null, 0, true, true, true, '',
        '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2141, '邮件记录', '', 2, 0, 2130, 'mail-log', 'log', 'system/mail/log/index', 'SystemMailLog', 0, true, true,
        true, '', '2023-01-26 02:16:50', '1', '2023-04-08 08:53:49', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2142, '日志查询', 'system:mail-log:query', 3, 1, 2141, '', '', '', null, 0, true, true, true, '',
        '2023-01-26 02:16:50', '', '2023-01-26 02:16:50', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2143, '发送测试邮件', 'system:mail-template:send-mail', 3, 5, 2136, '', '', '', null, 0, true, true, true, '1',
        '2023-01-26 23:29:15', '1', '2023-01-26 23:29:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2144, '站内信管理', '', 1, 11, 1, 'notify', 'message', null, null, 0, true, true, true, '1',
        '2023-01-28 10:25:18', '1', '2023-01-28 10:25:46', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2145, '模板管理', '', 2, 0, 2144, 'notify-template', 'education', 'system/notify/template/index',
        'SystemNotifyTemplate', 0, true, true, true, '', '2023-01-28 02:26:42', '1', '2023-04-08 08:54:39', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2146, '站内信模板查询', 'system:notify-template:query', 3, 1, 2145, '', '', '', null, 0, true, true, true, '',
        '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2147, '站内信模板创建', 'system:notify-template:create', 3, 2, 2145, '', '', '', null, 0, true, true, true, '',
        '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2148, '站内信模板更新', 'system:notify-template:update', 3, 3, 2145, '', '', '', null, 0, true, true, true, '',
        '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2149, '站内信模板删除', 'system:notify-template:delete', 3, 4, 2145, '', '', '', null, 0, true, true, true, '',
        '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2150, '发送测试站内信', 'system:notify-template:send-notify', 3, 5, 2145, '', '', '', null, 0, true, true, true,
        '1', '2023-01-28 10:54:43', '1', '2023-01-28 10:54:43', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2151, '消息记录', '', 2, 0, 2144, 'notify-message', 'edit', 'system/notify/message/index',
        'SystemNotifyMessage', 0, true, true, true, '', '2023-01-28 04:28:22', '1', '2023-04-08 08:54:11', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2152, '站内信消息查询', 'system:notify-message:query', 3, 1, 2151, '', '', '', null, 0, true, true, true, '',
        '2023-01-28 04:28:22', '', '2023-01-28 04:28:22', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2153, '大屏设计器', '', 2, 2, 1281, 'go-view', 'dashboard', 'report/goview/index', 'JimuReport', 0, true, true,
        true, '1', '2023-02-07 00:03:19', '1', '2023-04-08 10:48:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2154, '创建项目', 'report:go-view-project:create', 3, 1, 2153, '', '', '', null, 0, true, true, true, '1',
        '2023-02-07 19:25:14', '1', '2023-02-07 19:25:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2155, '更新项目', 'report:go-view-project:delete', 3, 2, 2153, '', '', '', null, 0, true, true, true, '1',
        '2023-02-07 19:25:34', '1', '2023-02-07 19:25:34', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2156, '查询项目', 'report:go-view-project:query', 3, 0, 2153, '', '', '', null, 0, true, true, true, '1',
        '2023-02-07 19:25:53', '1', '2023-02-07 19:25:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2157, '使用 SQL 查询数据', 'report:go-view-data:get-by-sql', 3, 3, 2153, '', '', '', null, 0, true, true, true,
        '1', '2023-02-07 19:26:15', '1', '2023-02-07 19:26:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2158, '使用 HTTP 查询数据', 'report:go-view-data:get-by-http', 3, 4, 2153, '', '', '', null, 0, true, true,
        true, '1', '2023-02-07 19:26:35', '1', '2023-02-07 19:26:35', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2159, 'Boot 开发文档', '', 1, 1, 0, 'https://doc.iocoder.cn/', 'education', null, null, 0, true, true, true,
        '1', '2023-02-10 22:46:28', '1', '2023-02-10 22:46:28', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2160, 'Cloud 开发文档', '', 1, 2, 0, 'https://cloud.iocoder.cn', 'documentation', null, null, 0, true, true,
        true, '1', '2023-02-10 22:47:07', '1', '2023-02-10 22:47:07', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2161, '接入示例', '', 2, 99, 1117, 'demo-order', 'drag', 'pay/demo/index', null, 0, true, true, true, '',
        '2023-02-11 14:21:42', '1', '2023-02-11 22:26:35', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2162, '商品导出', 'product:spu:export', 3, 5, 2014, '', '', '', null, 0, true, true, true, '',
        '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2164, '配送管理', '', 1, 2, 2072, 'delivery', '', '', '', 0, true, true, true, '1', '2023-05-18 09:18:02', '1',
        '2023-05-24 23:24:13', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2165, '快递发货', '', 1, 0, 2164, 'express', '', '', '', 0, true, true, true, '1', '2023-05-18 09:22:06', '1',
        '2023-05-18 09:22:06', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2166, '门店自提', '', 1, 1, 2164, 'pick-up-store', '', '', '', 0, true, true, true, '1', '2023-05-18 09:23:14',
        '1', '2023-05-18 09:23:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2167, '快递公司', '', 2, 0, 2165, 'express', '', 'mall/trade/delivery/express/index', 'Express', 0, true, true,
        true, '1', '2023-05-18 09:27:21', '1', '2023-05-18 22:11:14', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2168, '快递公司查询', 'trade:delivery:express:query', 3, 1, 2167, '', '', '', null, 0, true, true, true, '',
        '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2169, '快递公司创建', 'trade:delivery:express:create', 3, 2, 2167, '', '', '', null, 0, true, true, true, '',
        '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2170, '快递公司更新', 'trade:delivery:express:update', 3, 3, 2167, '', '', '', null, 0, true, true, true, '',
        '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2171, '快递公司删除', 'trade:delivery:express:delete', 3, 4, 2167, '', '', '', null, 0, true, true, true, '',
        '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2172, '快递公司导出', 'trade:delivery:express:export', 3, 5, 2167, '', '', '', null, 0, true, true, true, '',
        '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2173, '运费模版', 'trade:delivery:express-template:query', 2, 1, 2165, 'express-template', '',
        'mall/trade/delivery/expressTemplate/index', 'ExpressTemplate', 0, true, true, true, '1', '2023-05-20 06:48:10',
        '1', '2023-05-20 06:48:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2174, '快递运费模板查询', 'trade:delivery:express-template:query', 3, 1, 2173, '', '', '', null, 0, true, true,
        true, '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2175, '快递运费模板创建', 'trade:delivery:express-template:create', 3, 2, 2173, '', '', '', null, 0, true, true,
        true, '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2176, '快递运费模板更新', 'trade:delivery:express-template:update', 3, 3, 2173, '', '', '', null, 0, true, true,
        true, '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2177, '快递运费模板删除', 'trade:delivery:express-template:delete', 3, 4, 2173, '', '', '', null, 0, true, true,
        true, '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2178, '快递运费模板导出', 'trade:delivery:express-template:export', 3, 5, 2173, '', '', '', null, 0, true, true,
        true, '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2179, '门店管理', '', 2, 1, 2166, 'pick-up-store', '', 'mall/trade/delivery/pickUpStore/index', 'PickUpStore',
        0, true, true, true, '1', '2023-05-25 10:50:00', '1', '2023-05-25 10:50:00', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2180, '自提门店查询', 'trade:delivery:pick-up-store:query', 3, 1, 2179, '', '', '', null, 0, true, true, true,
        '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2181, '自提门店创建', 'trade:delivery:pick-up-store:create', 3, 2, 2179, '', '', '', null, 0, true, true, true,
        '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2182, '自提门店更新', 'trade:delivery:pick-up-store:update', 3, 3, 2179, '', '', '', null, 0, true, true, true,
        '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2183, '自提门店删除', 'trade:delivery:pick-up-store:delete', 3, 4, 2179, '', '', '', null, 0, true, true, true,
        '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2184, '自提门店导出', 'trade:delivery:pick-up-store:export', 3, 5, 2179, '', '', '', null, 0, true, true, true,
        '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2209, '秒杀活动', '', 2, 3, 2030, 'seckill', 'ep:place', '', '', 0, true, true, true, '1',
        '2023-06-24 17:39:13', '1', '2023-06-24 18:55:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2262, '会员中心', '', 1, 55, 0, '/member', 'date-range', null, null, 0, true, true, true, '1',
        '2023-06-10 00:42:03', '1', '2023-06-28 22:52:34', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2275, '积分配置', '', 2, 0, 2299, 'config', '', 'member/point/config/index', 'PointConfig', 0, true, true, true,
        '', '2023-06-10 02:07:44', '1', '2023-06-27 22:50:59', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2276, '积分设置查询', 'point:config:query', 3, 1, 2275, '', '', '', null, 0, true, true, true, '',
        '2023-06-10 02:07:44', '', '2023-06-10 02:07:44', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2277, '积分设置创建', 'point:config:save', 3, 2, 2275, '', '', '', '', 0, true, true, true, '',
        '2023-06-10 02:07:44', '1', '2023-06-27 20:32:31', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2281, '签到配置', '', 2, 2, 2300, 'sign-in-config', '', 'member/signin/config/index', 'SignInConfig', 0, true,
        true, true, '', '2023-06-10 03:26:12', '1', '2023-07-02 15:04:15', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2282, '积分签到规则查询', 'point:sign-in-config:query', 3, 1, 2281, '', '', '', null, 0, true, true, true, '',
        '2023-06-10 03:26:12', '', '2023-06-10 03:26:12', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2283, '积分签到规则创建', 'point:sign-in-config:create', 3, 2, 2281, '', '', '', null, 0, true, true, true, '',
        '2023-06-10 03:26:12', '', '2023-06-10 03:26:12', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2284, '积分签到规则更新', 'point:sign-in-config:update', 3, 3, 2281, '', '', '', null, 0, true, true, true, '',
        '2023-06-10 03:26:12', '', '2023-06-10 03:26:12', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2285, '积分签到规则删除', 'point:sign-in-config:delete', 3, 4, 2281, '', '', '', null, 0, true, true, true, '',
        '2023-06-10 03:26:12', '', '2023-06-10 03:26:12', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2287, '积分记录', '', 2, 1, 2299, 'record', '', 'member/point/record/index', 'PointRecord', 0, true, true, true,
        '', '2023-06-10 04:18:50', '1', '2023-06-27 22:51:07', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2288, '用户积分记录查询', 'point:record:query', 3, 1, 2287, '', '', '', null, 0, true, true, true, '',
        '2023-06-10 04:18:50', '', '2023-06-10 04:18:50', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2293, '签到记录', '', 2, 3, 2300, 'sign-in-record', '', 'member/signin/record/index', 'SignInRecord', 0, true,
        true, true, '', '2023-06-10 04:48:22', '1', '2023-07-02 15:04:10', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2294, '用户签到积分查询', 'point:sign-in-record:query', 3, 1, 2293, '', '', '', null, 0, true, true, true, '',
        '2023-06-10 04:48:22', '', '2023-06-10 04:48:22', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2297, '用户签到积分删除', 'point:sign-in-record:delete', 3, 4, 2293, '', '', '', null, 0, true, true, true, '',
        '2023-06-10 04:48:22', '', '2023-06-10 04:48:22', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2299, '会员积分', '', 1, 1, 2262, 'point', '', '', '', 0, true, true, true, '1', '2023-06-27 22:48:51', '1',
        '2023-06-27 22:48:51', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2300, '会员签到', '', 1, 2, 2262, 'signin', '', '', '', 0, true, true, true, '1', '2023-06-27 22:49:53', '1',
        '2023-06-27 22:49:53', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2301, '回调通知', '', 2, 4, 1117, 'notify', 'example', 'pay/notify/index', 'PayNotify', 0, true, true, true, '',
        '2023-07-20 04:41:32', '1', '2023-07-20 13:45:08', false);
INSERT INTO interview.system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name,
                                   status, visible, keep_alive, always_show, creator, create_time, updater, update_time,
                                   deleted)
VALUES (2302, '支付通知查询', 'pay:notify:query', 3, 1, 2301, '', '', '', null, 0, true, true, true, '',
        '2023-07-20 04:41:32', '', '2023-07-20 04:41:32', false);

INSERT INTO interview.system_notice (id, title, content, type, status, creator, create_time, updater, update_time,
                                     deleted, tenant_id)
VALUES (1, '芋道的公众', '<p>新版本内容133</p>', 1, 0, 'admin', '2021-01-05 17:03:48', '1', '2022-05-04 21:00:20',
        false, 1);
INSERT INTO interview.system_notice (id, title, content, type, status, creator, create_time, updater, update_time,
                                     deleted, tenant_id)
VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护',
        '<p><img src="http://test.yudao.iocoder.cn/b7cb3cf49b4b3258bf7309a09dd2f4e5.jpg">维护内容</p>', 2, 1, 'admin',
        '2021-01-05 17:03:48', '1', '2022-05-11 12:34:24', false, 1);
INSERT INTO interview.system_notice (id, title, content, type, status, creator, create_time, updater, update_time,
                                     deleted, tenant_id)
VALUES (4, '我是测试标题', '<p>哈哈哈哈123</p>', 1, 0, '110', '2022-02-22 01:01:25', '110', '2022-02-22 01:01:46',
        false, 121);

INSERT INTO interview.system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname,
                                             template_content, template_type, template_params, read_status, read_time,
                                             creator, create_time, updater, update_time, deleted, tenant_id)
VALUES (2, 1, 2, 1, 'test', '123', '我是 1，我开始 2 了', 1, '{"name":"1","what":"2"}', true, '2023-02-10 00:47:04', '1',
        '2023-01-28 11:44:08', '1', '2023-02-10 00:47:04', false, 1);
INSERT INTO interview.system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname,
                                             template_content, template_type, template_params, read_status, read_time,
                                             creator, create_time, updater, update_time, deleted, tenant_id)
VALUES (3, 1, 2, 1, 'test', '123', '我是 1，我开始 2 了', 1, '{"name":"1","what":"2"}', true, '2023-02-10 00:47:04', '1',
        '2023-01-28 11:45:04', '1', '2023-02-10 00:47:04', false, 1);
INSERT INTO interview.system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname,
                                             template_content, template_type, template_params, read_status, read_time,
                                             creator, create_time, updater, update_time, deleted, tenant_id)
VALUES (4, 103, 2, 2, 'register', '系统消息', '你好，欢迎 哈哈 加入大家庭！', 2, '{"name":"哈哈"}', false, null, '1',
        '2023-01-28 21:02:20', '1', '2023-01-28 21:02:20', false, 1);
INSERT INTO interview.system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname,
                                             template_content, template_type, template_params, read_status, read_time,
                                             creator, create_time, updater, update_time, deleted, tenant_id)
VALUES (5, 1, 2, 1, 'test', '123', '我是 芋艿，我开始 写代码 了', 1, '{"name":"芋艿","what":"写代码"}', true,
        '2023-02-10 00:47:04', '1', '2023-01-28 22:21:42', '1', '2023-02-10 00:47:04', false, 1);
INSERT INTO interview.system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname,
                                             template_content, template_type, template_params, read_status, read_time,
                                             creator, create_time, updater, update_time, deleted, tenant_id)
VALUES (6, 1, 2, 1, 'test', '123', '我是 芋艿，我开始 写代码 了', 1, '{"name":"芋艿","what":"写代码"}', true,
        '2023-01-29 10:52:06', '1', '2023-01-28 22:22:07', '1', '2023-01-29 10:52:06', false, 1);
INSERT INTO interview.system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname,
                                             template_content, template_type, template_params, read_status, read_time,
                                             creator, create_time, updater, update_time, deleted, tenant_id)
VALUES (7, 1, 2, 1, 'test', '123', '我是 2，我开始 3 了', 1, '{"name":"2","what":"3"}', true, '2023-01-29 10:52:06', '1',
        '2023-01-28 23:45:21', '1', '2023-01-29 10:52:06', false, 1);
INSERT INTO interview.system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname,
                                             template_content, template_type, template_params, read_status, read_time,
                                             creator, create_time, updater, update_time, deleted, tenant_id)
VALUES (8, 1, 2, 2, 'register', '系统消息', '你好，欢迎 123 加入大家庭！', 2, '{"name":"123"}', true,
        '2023-01-29 10:52:06', '1', '2023-01-28 23:50:21', '1', '2023-01-29 10:52:06', false, 1);

INSERT INTO interview.system_oauth2_client (id, client_id, secret, name, logo, description, status,
                                            access_token_validity_seconds, refresh_token_validity_seconds,
                                            redirect_uris, authorized_grant_types, scopes, auto_approve_scopes,
                                            authorities, resource_ids, additional_information, creator, create_time,
                                            updater, update_time, deleted)
VALUES (1, 'default', 'admin123', '芋道源码', 'http://test.yudao.iocoder.cn/a5e2e244368878a366b516805a4aabf1.png',
        '我是描述', 0, 1800, 43200, '["https://www.iocoder.cn","https://doc.iocoder.cn"]',
        '["password","authorization_code","implicit","refresh_token"]', '["user.read","user.write"]', '[]',
        '["user.read","user.write"]', '[]', '{}', '1', '2022-05-11 21:47:12', '1', '2022-07-05 16:23:52', false);
INSERT INTO interview.system_oauth2_client (id, client_id, secret, name, logo, description, status,
                                            access_token_validity_seconds, refresh_token_validity_seconds,
                                            redirect_uris, authorized_grant_types, scopes, auto_approve_scopes,
                                            authorities, resource_ids, additional_information, creator, create_time,
                                            updater, update_time, deleted)
VALUES (40, 'test', 'test2', 'biubiu', 'http://test.yudao.iocoder.cn/277a899d573723f1fcdfb57340f00379.png', null, 0,
        1800, 43200, '["https://www.iocoder.cn"]', '["password","authorization_code","implicit"]',
        '["user_info","projects"]', '["user_info"]', '[]', '[]', '{}', '1', '2022-05-12 00:28:20', '1',
        '2022-06-19 00:26:13', false);
INSERT INTO interview.system_oauth2_client (id, client_id, secret, name, logo, description, status,
                                            access_token_validity_seconds, refresh_token_validity_seconds,
                                            redirect_uris, authorized_grant_types, scopes, auto_approve_scopes,
                                            authorities, resource_ids, additional_information, creator, create_time,
                                            updater, update_time, deleted)
VALUES (41, 'yudao-sso-demo-by-code', 'test', '基于授权码模式，如何实现 SSO 单点登录？',
        'http://test.yudao.iocoder.cn/fe4ed36596adad5120036ef61a6d0153654544d44af8dd4ad3ffe8f759933d6f.png', null, 0,
        1800, 43200, '["http://127.0.0.1:18080"]', '["authorization_code","refresh_token"]',
        '["user.read","user.write"]', '[]', '[]', '[]', null, '1', '2022-09-29 13:28:31', '1', '2022-09-29 13:28:31',
        false);
INSERT INTO interview.system_oauth2_client (id, client_id, secret, name, logo, description, status,
                                            access_token_validity_seconds, refresh_token_validity_seconds,
                                            redirect_uris, authorized_grant_types, scopes, auto_approve_scopes,
                                            authorities, resource_ids, additional_information, creator, create_time,
                                            updater, update_time, deleted)
VALUES (42, 'yudao-sso-demo-by-password', 'test', '基于密码模式，如何实现 SSO 单点登录？',
        'http://test.yudao.iocoder.cn/604bdc695e13b3b22745be704d1f2aa8ee05c5f26f9fead6d1ca49005afbc857.jpeg', null, 0,
        1800, 43200, '["http://127.0.0.1:18080"]', '["password","refresh_token"]', '["user.read","user.write"]', '[]',
        '[]', '[]', null, '1', '2022-10-04 17:40:16', '1', '2022-10-04 20:31:21', false);

INSERT INTO interview.system_post (id, code, name, sort, status, remark, creator, create_time, updater, update_time,
                                   deleted, tenant_id)
VALUES (1, 'ceo', '董事长', 1, 0, '', 'admin', '2021-01-06 17:03:48', '1', '2023-02-11 15:19:04', false, 1);
INSERT INTO interview.system_post (id, code, name, sort, status, remark, creator, create_time, updater, update_time,
                                   deleted, tenant_id)
VALUES (2, 'se', '项目经理', 2, 0, '', 'admin', '2021-01-05 17:03:48', '1', '2021-12-12 10:47:47', false, 1);
INSERT INTO interview.system_post (id, code, name, sort, status, remark, creator, create_time, updater, update_time,
                                   deleted, tenant_id)
VALUES (4, 'user', '普通员工', 4, 0, '111', 'admin', '2021-01-05 17:03:48', '1', '2023-02-11 15:19:00', false, 1);

INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (1, '超级管理员', 'super_admin', 1, 1, '', 0, 1, '超级管理员', 'admin', '2021-01-05 17:03:48', '',
        '2022-02-22 05:08:21', false, 1);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (2, '普通角色', 'common', 2, 2, '', 0, 1, '普通角色', 'admin', '2021-01-05 17:03:48', '', '2022-02-22 05:08:20',
        false, 1);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (101, '测试账号', 'test', 0, 1, '[]', 0, 2, '132', '', '2021-01-06 13:49:35', '1', '2022-09-25 12:09:38', false,
        1);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (109, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-02-22 00:56:14', '1',
        '2022-02-22 00:56:14', false, 121);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (110, '测试角色', 'test', 0, 1, '[]', 0, 2, '嘿嘿', '110', '2022-02-23 00:14:34', '110', '2022-02-23 13:14:58',
        false, 121);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (111, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-03-07 21:37:58', '1',
        '2022-03-07 21:37:58', false, 122);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (113, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-05-17 10:07:10', '1',
        '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (114, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-12-30 11:32:03', '1',
        '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (115, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-12-30 11:33:42', '1',
        '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (116, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-12-30 11:33:48', '1',
        '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (118, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-12-30 11:47:52', '1',
        '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (136, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2023-03-05 21:23:32', '1',
        '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (137, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2023-03-05 21:42:27', '1',
        '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator,
                                   create_time, updater, update_time, deleted, tenant_id)
VALUES (138, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2023-03-05 21:59:02', '1',
        '2023-03-05 21:59:02', false, 149);

INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (263, 109, 1, '1', '2022-02-22 00:56:14', '1', '2022-02-22 00:56:14', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (434, 2, 1, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (454, 2, 1093, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (455, 2, 1094, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (460, 2, 1100, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (467, 2, 1107, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (470, 2, 1110, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (476, 2, 1117, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (477, 2, 100, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (478, 2, 101, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (479, 2, 102, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (480, 2, 1126, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (481, 2, 103, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (483, 2, 104, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (485, 2, 105, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (488, 2, 107, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (490, 2, 108, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (492, 2, 109, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (498, 2, 1138, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (523, 2, 1224, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (524, 2, 1225, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (541, 2, 500, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (543, 2, 501, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (675, 2, 2, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (689, 2, 1077, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (690, 2, 1078, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (692, 2, 1083, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (693, 2, 1084, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (699, 2, 1090, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (703, 2, 106, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (704, 2, 110, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (705, 2, 111, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (706, 2, 112, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (707, 2, 113, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1296, 110, 1, '110', '2022-02-23 00:23:55', '110', '2022-02-23 00:23:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1489, 1, 1, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1490, 1, 2, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1494, 1, 1077, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1495, 1, 1078, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1496, 1, 1083, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1497, 1, 1084, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1498, 1, 1090, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1499, 1, 1093, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1500, 1, 1094, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1501, 1, 1100, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1502, 1, 1107, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1503, 1, 1110, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1505, 1, 1117, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1506, 1, 100, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1507, 1, 101, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1508, 1, 102, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1509, 1, 1126, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1510, 1, 103, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1511, 1, 104, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1512, 1, 105, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1513, 1, 106, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1514, 1, 107, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1515, 1, 108, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1516, 1, 109, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1517, 1, 110, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1518, 1, 111, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1519, 1, 112, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1520, 1, 113, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1522, 1, 1138, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1525, 1, 1224, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1526, 1, 1225, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1527, 1, 500, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1528, 1, 501, '1', '2022-02-23 20:03:57', '1', '2022-02-23 20:03:57', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1578, 111, 1, '1', '2022-03-07 21:37:58', '1', '2022-03-07 21:37:58', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1604, 101, 1216, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1605, 101, 1217, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1606, 101, 1218, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1607, 101, 1219, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1608, 101, 1220, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1609, 101, 1221, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1610, 101, 5, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1611, 101, 1222, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1612, 101, 1118, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1613, 101, 1119, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1614, 101, 1120, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1615, 101, 1185, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1616, 101, 1186, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1617, 101, 1187, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1618, 101, 1188, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1619, 101, 1189, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1620, 101, 1190, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1621, 101, 1191, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1622, 101, 1192, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1623, 101, 1193, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1624, 101, 1194, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1625, 101, 1195, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1626, 101, 1196, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1627, 101, 1197, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1628, 101, 1198, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1629, 101, 1199, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1630, 101, 1200, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1631, 101, 1201, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1632, 101, 1202, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1633, 101, 1207, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1634, 101, 1208, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1635, 101, 1209, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1636, 101, 1210, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1637, 101, 1211, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1638, 101, 1212, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1639, 101, 1213, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1640, 101, 1215, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1641, 101, 2, '1', '2022-04-01 22:21:24', '1', '2022-04-01 22:21:24', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1642, 101, 1031, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1643, 101, 1032, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1644, 101, 1033, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1645, 101, 1034, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1646, 101, 1035, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1647, 101, 1050, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1648, 101, 1051, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1649, 101, 1052, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1650, 101, 1053, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1651, 101, 1054, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1652, 101, 1056, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1653, 101, 1057, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1654, 101, 1058, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1655, 101, 1059, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1656, 101, 1060, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1657, 101, 1066, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1658, 101, 1067, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1659, 101, 1070, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1660, 101, 1071, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1661, 101, 1072, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1662, 101, 1073, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1663, 101, 1074, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1664, 101, 1075, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1665, 101, 1076, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1666, 101, 1077, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1667, 101, 1078, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1668, 101, 1082, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1669, 101, 1083, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1670, 101, 1084, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1671, 101, 1085, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1672, 101, 1086, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1673, 101, 1087, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1674, 101, 1088, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1675, 101, 1089, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1679, 101, 1237, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1680, 101, 1238, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1681, 101, 1239, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1682, 101, 1240, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1683, 101, 1241, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1684, 101, 1242, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1685, 101, 1243, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1687, 101, 106, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1688, 101, 110, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1689, 101, 111, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1690, 101, 112, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1691, 101, 113, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1692, 101, 114, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1693, 101, 115, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1694, 101, 116, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1712, 113, 1024, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1713, 113, 1025, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1714, 113, 1, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1715, 113, 102, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1716, 113, 103, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1717, 113, 104, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1718, 113, 1013, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1719, 113, 1014, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1720, 113, 1015, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1721, 113, 1016, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1722, 113, 1017, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1723, 113, 1018, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1724, 113, 1019, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1725, 113, 1020, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1726, 113, 1021, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1727, 113, 1022, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1728, 113, 1023, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1729, 109, 100, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1730, 109, 101, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1731, 109, 1063, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1732, 109, 1064, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1733, 109, 1001, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1734, 109, 1065, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1735, 109, 1002, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1736, 109, 1003, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1737, 109, 1004, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1738, 109, 1005, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1739, 109, 1006, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1740, 109, 1007, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1741, 109, 1008, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1742, 109, 1009, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1743, 109, 1010, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1744, 109, 1011, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1745, 109, 1012, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1746, 111, 100, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1747, 111, 101, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1748, 111, 1063, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1749, 111, 1064, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1750, 111, 1001, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1751, 111, 1065, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1752, 111, 1002, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1753, 111, 1003, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1754, 111, 1004, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1755, 111, 1005, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1756, 111, 1006, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1757, 111, 1007, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1758, 111, 1008, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1759, 111, 1009, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1760, 111, 1010, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1761, 111, 1011, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1762, 111, 1012, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1763, 109, 100, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1764, 109, 101, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1765, 109, 1063, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1766, 109, 1064, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1767, 109, 1001, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1768, 109, 1065, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1769, 109, 1002, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1770, 109, 1003, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1771, 109, 1004, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1772, 109, 1005, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1773, 109, 1006, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1774, 109, 1007, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1775, 109, 1008, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1776, 109, 1009, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1777, 109, 1010, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1778, 109, 1011, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1779, 109, 1012, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1780, 111, 100, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1781, 111, 101, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1782, 111, 1063, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1783, 111, 1064, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1784, 111, 1001, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1785, 111, 1065, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1786, 111, 1002, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1787, 111, 1003, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1788, 111, 1004, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1789, 111, 1005, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1790, 111, 1006, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1791, 111, 1007, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1792, 111, 1008, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1793, 111, 1009, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1794, 111, 1010, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1795, 111, 1011, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1796, 111, 1012, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1797, 109, 100, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1798, 109, 101, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1799, 109, 1063, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1800, 109, 1064, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1801, 109, 1001, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1802, 109, 1065, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1803, 109, 1002, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1804, 109, 1003, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1805, 109, 1004, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1806, 109, 1005, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1807, 109, 1006, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1808, 109, 1007, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1809, 109, 1008, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1810, 109, 1009, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1811, 109, 1010, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1812, 109, 1011, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1813, 109, 1012, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1814, 111, 100, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1815, 111, 101, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1816, 111, 1063, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1817, 111, 1064, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1818, 111, 1001, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1819, 111, 1065, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1820, 111, 1002, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1821, 111, 1003, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1822, 111, 1004, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1823, 111, 1005, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1824, 111, 1006, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1825, 111, 1007, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1826, 111, 1008, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1827, 111, 1009, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1828, 111, 1010, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1829, 111, 1011, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1830, 111, 1012, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1831, 109, 103, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1832, 109, 1017, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1833, 109, 1018, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1834, 109, 1019, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1835, 109, 1020, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1836, 111, 103, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1837, 111, 1017, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1838, 111, 1018, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1839, 111, 1019, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1840, 111, 1020, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1841, 109, 1036, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1842, 109, 1037, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1843, 109, 1038, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1844, 109, 1039, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1845, 109, 107, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 121);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1846, 111, 1036, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1847, 111, 1037, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1848, 111, 1038, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1849, 111, 1039, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1850, 111, 107, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', false, 122);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1851, 114, 1, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1852, 114, 1036, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1853, 114, 1037, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1854, 114, 1038, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1855, 114, 1039, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1856, 114, 100, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1857, 114, 101, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1858, 114, 1063, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1859, 114, 103, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1860, 114, 1064, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1861, 114, 1001, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1862, 114, 1065, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1863, 114, 1002, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1864, 114, 1003, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1865, 114, 107, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1866, 114, 1004, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1867, 114, 1005, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1868, 114, 1006, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1869, 114, 1007, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1870, 114, 1008, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1871, 114, 1009, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1872, 114, 1010, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1873, 114, 1011, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1874, 114, 1012, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1875, 114, 1017, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1876, 114, 1018, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1877, 114, 1019, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1878, 114, 1020, '1', '2022-12-30 11:32:03', '1', '2022-12-30 11:32:03', false, 125);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1879, 115, 1, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1880, 115, 1036, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1881, 115, 1037, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1882, 115, 1038, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1883, 115, 1039, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1884, 115, 100, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1885, 115, 101, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1886, 115, 1063, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1887, 115, 103, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1888, 115, 1064, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1889, 115, 1001, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1890, 115, 1065, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1891, 115, 1002, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1892, 115, 1003, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1893, 115, 107, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1894, 115, 1004, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1895, 115, 1005, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1896, 115, 1006, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1897, 115, 1007, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1898, 115, 1008, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1899, 115, 1009, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1900, 115, 1010, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1901, 115, 1011, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1902, 115, 1012, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1903, 115, 1017, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1904, 115, 1018, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1905, 115, 1019, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1906, 115, 1020, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1907, 116, 1, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1908, 116, 1036, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1909, 116, 1037, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1910, 116, 1038, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1911, 116, 1039, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1912, 116, 100, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1913, 116, 101, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1914, 116, 1063, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1915, 116, 103, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1916, 116, 1064, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1917, 116, 1001, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1918, 116, 1065, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1919, 116, 1002, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1920, 116, 1003, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1921, 116, 107, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1922, 116, 1004, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1923, 116, 1005, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1924, 116, 1006, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1925, 116, 1007, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1926, 116, 1008, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1927, 116, 1009, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1928, 116, 1010, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1929, 116, 1011, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1930, 116, 1012, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1931, 116, 1017, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1932, 116, 1018, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1933, 116, 1019, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1934, 116, 1020, '1', '2022-12-30 11:33:48', '1', '2022-12-30 11:33:48', false, 127);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1963, 118, 1, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1964, 118, 1036, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1965, 118, 1037, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1966, 118, 1038, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1967, 118, 1039, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1968, 118, 100, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1969, 118, 101, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1970, 118, 1063, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1971, 118, 103, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1972, 118, 1064, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1973, 118, 1001, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1974, 118, 1065, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1975, 118, 1002, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1976, 118, 1003, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1977, 118, 107, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1978, 118, 1004, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1979, 118, 1005, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1980, 118, 1006, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1981, 118, 1007, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1982, 118, 1008, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1983, 118, 1009, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1984, 118, 1010, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1985, 118, 1011, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1986, 118, 1012, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1987, 118, 1017, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1988, 118, 1018, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1989, 118, 1019, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1990, 118, 1020, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1991, 2, 1024, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1992, 2, 1025, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1993, 2, 1026, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1994, 2, 1027, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1995, 2, 1028, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1996, 2, 1029, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1997, 2, 1030, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1998, 2, 1031, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1999, 2, 1032, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2000, 2, 1033, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2001, 2, 1034, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2002, 2, 1035, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2003, 2, 1036, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2004, 2, 1037, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2005, 2, 1038, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2006, 2, 1039, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2007, 2, 1040, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2008, 2, 1042, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2009, 2, 1043, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2010, 2, 1045, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2011, 2, 1046, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2012, 2, 1048, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2013, 2, 1050, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2014, 2, 1051, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2015, 2, 1052, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2016, 2, 1053, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2017, 2, 1054, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2018, 2, 1056, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2019, 2, 1057, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2020, 2, 1058, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2021, 2, 2083, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2022, 2, 1059, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2023, 2, 1060, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2024, 2, 1063, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2025, 2, 1064, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2026, 2, 1065, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2027, 2, 1066, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2028, 2, 1067, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2029, 2, 1070, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2030, 2, 1071, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2031, 2, 1072, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2032, 2, 1073, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2033, 2, 1074, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2034, 2, 1075, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2035, 2, 1076, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2036, 2, 1082, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2037, 2, 1085, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2038, 2, 1086, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2039, 2, 1087, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2040, 2, 1088, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2041, 2, 1089, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2042, 2, 1091, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2043, 2, 1092, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2044, 2, 1095, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2045, 2, 1096, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2046, 2, 1097, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2047, 2, 1098, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2048, 2, 1101, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2049, 2, 1102, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2050, 2, 1103, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2051, 2, 1104, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2052, 2, 1105, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2053, 2, 1106, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2054, 2, 1108, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2055, 2, 1109, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2056, 2, 1111, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2057, 2, 1112, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2058, 2, 1113, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2059, 2, 1114, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2060, 2, 1115, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2061, 2, 1127, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2062, 2, 1128, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2063, 2, 1129, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2064, 2, 1130, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2066, 2, 1132, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2067, 2, 1133, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2068, 2, 1134, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2069, 2, 1135, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2070, 2, 1136, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2071, 2, 1137, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2072, 2, 114, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2073, 2, 1139, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2074, 2, 115, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2075, 2, 1140, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2076, 2, 116, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2077, 2, 1141, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2078, 2, 1142, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2079, 2, 1143, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2080, 2, 1150, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2081, 2, 1161, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2082, 2, 1162, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2083, 2, 1163, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2084, 2, 1164, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2085, 2, 1165, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2086, 2, 1166, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2087, 2, 1173, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2088, 2, 1174, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2089, 2, 1175, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2090, 2, 1176, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2091, 2, 1177, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2092, 2, 1178, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2099, 2, 1226, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2100, 2, 1227, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2101, 2, 1228, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2102, 2, 1229, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2103, 2, 1237, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2104, 2, 1238, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2105, 2, 1239, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2106, 2, 1240, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2107, 2, 1241, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2108, 2, 1242, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2109, 2, 1243, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2110, 2, 1247, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2111, 2, 1248, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2112, 2, 1249, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2113, 2, 1250, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2114, 2, 1251, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2115, 2, 1252, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2116, 2, 1254, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2117, 2, 1255, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2118, 2, 1256, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2119, 2, 1257, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2120, 2, 1258, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2121, 2, 1259, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2122, 2, 1260, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2123, 2, 1261, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2124, 2, 1263, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2125, 2, 1264, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2126, 2, 1265, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2127, 2, 1266, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2128, 2, 1267, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2129, 2, 1001, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2130, 2, 1002, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2131, 2, 1003, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2132, 2, 1004, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2133, 2, 1005, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2134, 2, 1006, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2135, 2, 1007, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2136, 2, 1008, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2137, 2, 1009, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2138, 2, 1010, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2139, 2, 1011, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2140, 2, 1012, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2141, 2, 1013, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2142, 2, 1014, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2143, 2, 1015, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2144, 2, 1016, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2145, 2, 1017, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2146, 2, 1018, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2147, 2, 1019, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2148, 2, 1020, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2149, 2, 1021, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2150, 2, 1022, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2151, 2, 1023, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2152, 2, 1281, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2153, 2, 1282, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2154, 2, 2000, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2155, 2, 2002, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2156, 2, 2003, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2157, 2, 2004, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2158, 2, 2005, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2159, 2, 2006, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2160, 2, 2008, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2161, 2, 2009, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2162, 2, 2010, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2163, 2, 2011, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2164, 2, 2012, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2170, 2, 2019, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2171, 2, 2020, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2172, 2, 2021, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2173, 2, 2022, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2174, 2, 2023, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2175, 2, 2025, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2177, 2, 2027, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2178, 2, 2028, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2179, 2, 2029, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2180, 2, 2014, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2181, 2, 2015, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2182, 2, 2016, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2183, 2, 2017, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2184, 2, 2018, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2188, 101, 1024, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2189, 101, 1, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2190, 101, 1025, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2191, 101, 1026, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2192, 101, 1027, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2193, 101, 1028, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2194, 101, 1029, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2195, 101, 1030, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2196, 101, 1036, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2197, 101, 1037, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2198, 101, 1038, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2199, 101, 1039, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2200, 101, 1040, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2201, 101, 1042, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2202, 101, 1043, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2203, 101, 1045, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2204, 101, 1046, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2205, 101, 1048, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2206, 101, 2083, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2207, 101, 1063, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2208, 101, 1064, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2209, 101, 1065, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2210, 101, 1093, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2211, 101, 1094, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2212, 101, 1095, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2213, 101, 1096, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2214, 101, 1097, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2215, 101, 1098, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2216, 101, 1100, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2217, 101, 1101, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2218, 101, 1102, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2219, 101, 1103, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2220, 101, 1104, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2221, 101, 1105, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2222, 101, 1106, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2223, 101, 2130, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2224, 101, 1107, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2225, 101, 2131, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2226, 101, 1108, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2227, 101, 2132, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2228, 101, 1109, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2229, 101, 2133, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2230, 101, 2134, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2231, 101, 1110, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2232, 101, 2135, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2233, 101, 1111, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2234, 101, 2136, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2235, 101, 1112, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2236, 101, 2137, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2237, 101, 1113, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2238, 101, 2138, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2239, 101, 1114, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2240, 101, 2139, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2241, 101, 1115, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2242, 101, 2140, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2243, 101, 2141, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2244, 101, 2142, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2245, 101, 2143, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2246, 101, 2144, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2247, 101, 2145, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2248, 101, 2146, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2249, 101, 2147, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2250, 101, 100, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2251, 101, 2148, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2252, 101, 101, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2253, 101, 2149, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2254, 101, 102, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2255, 101, 2150, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2256, 101, 103, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2257, 101, 2151, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2258, 101, 104, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2259, 101, 2152, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2260, 101, 105, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2261, 101, 107, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2262, 101, 108, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2263, 101, 109, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2264, 101, 1138, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2265, 101, 1139, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2266, 101, 1140, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2267, 101, 1141, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2268, 101, 1142, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2269, 101, 1143, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2270, 101, 1224, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2271, 101, 1225, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2272, 101, 1226, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2273, 101, 1227, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2274, 101, 1228, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2275, 101, 1229, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2276, 101, 1247, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2277, 101, 1248, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2278, 101, 1249, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2279, 101, 1250, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2280, 101, 1251, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2281, 101, 1252, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2282, 101, 1261, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2283, 101, 1263, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2284, 101, 1264, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2285, 101, 1265, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2286, 101, 1266, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2287, 101, 1267, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2288, 101, 1001, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2289, 101, 1002, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2290, 101, 1003, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2291, 101, 1004, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2292, 101, 1005, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2293, 101, 1006, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2294, 101, 1007, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2295, 101, 1008, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2296, 101, 1009, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2297, 101, 1010, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2298, 101, 1011, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2299, 101, 1012, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2300, 101, 500, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2301, 101, 1013, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2302, 101, 501, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2303, 101, 1014, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2304, 101, 1015, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2305, 101, 1016, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2306, 101, 1017, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2307, 101, 1018, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2308, 101, 1019, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2309, 101, 1020, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2310, 101, 1021, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2311, 101, 1022, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2312, 101, 1023, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', false, 1);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2789, 136, 1, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2790, 136, 1036, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2791, 136, 1037, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2792, 136, 1038, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2793, 136, 1039, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2794, 136, 100, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2795, 136, 101, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2796, 136, 1063, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2797, 136, 103, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2798, 136, 1064, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2799, 136, 1001, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2800, 136, 1065, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2801, 136, 1002, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2802, 136, 1003, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2803, 136, 107, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2804, 136, 1004, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2805, 136, 1005, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2806, 136, 1006, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2807, 136, 1007, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2808, 136, 1008, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2809, 136, 1009, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2810, 136, 1010, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2811, 136, 1011, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2812, 136, 1012, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2813, 136, 1017, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2814, 136, 1018, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2815, 136, 1019, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2816, 136, 1020, '1', '2023-03-05 21:23:32', '1', '2023-03-05 21:23:32', false, 147);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2817, 137, 1, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2818, 137, 1036, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2819, 137, 1037, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2820, 137, 1038, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2821, 137, 1039, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2822, 137, 100, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2823, 137, 101, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2824, 137, 1063, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2825, 137, 103, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2826, 137, 1064, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2827, 137, 1001, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2828, 137, 1065, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2829, 137, 1002, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2830, 137, 1003, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2831, 137, 107, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2832, 137, 1004, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2833, 137, 1005, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2834, 137, 1006, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2835, 137, 1007, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2836, 137, 1008, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2837, 137, 1009, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2838, 137, 1010, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2839, 137, 1011, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2840, 137, 1012, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2841, 137, 1017, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2842, 137, 1018, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2843, 137, 1019, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2844, 137, 1020, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2845, 138, 1, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2846, 138, 1036, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2847, 138, 1037, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2848, 138, 1038, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2849, 138, 1039, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2850, 138, 100, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2851, 138, 101, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2852, 138, 1063, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2853, 138, 103, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2854, 138, 1064, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2855, 138, 1001, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2856, 138, 1065, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2857, 138, 1002, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2858, 138, 1003, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2859, 138, 107, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2860, 138, 1004, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2861, 138, 1005, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2862, 138, 1006, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2863, 138, 1007, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2864, 138, 1008, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2865, 138, 1009, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2866, 138, 1010, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2867, 138, 1011, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2868, 138, 1012, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2869, 138, 1017, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2870, 138, 1018, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2871, 138, 1019, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);
INSERT INTO interview.system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2872, 138, 1020, '1', '2023-03-05 21:59:02', '1', '2023-03-05 21:59:02', false, 149);

INSERT INTO interview.system_sensitive_word (id, name, description, tags, status, creator, create_time, updater,
                                             update_time, deleted)
VALUES (3, '土豆', '好呀', '蔬菜,短信', 0, '1', '2022-04-08 21:07:12', '1', '2022-04-09 10:28:14', false);
INSERT INTO interview.system_sensitive_word (id, name, description, tags, status, creator, create_time, updater,
                                             update_time, deleted)
VALUES (4, 'XXX', null, '短信', 0, '1', '2022-04-08 21:27:49', '1', '2022-06-19 00:36:50', false);
INSERT INTO interview.system_sensitive_word (id, name, description, tags, status, creator, create_time, updater,
                                             update_time, deleted)
VALUES (5, '白痴', null, '测试', 0, '1', '2022-12-31 19:08:25', '1', '2022-12-31 19:08:25', false);

INSERT INTO interview.system_sms_channel (id, signature, code, status, remark, api_key, api_secret, callback_url,
                                          creator, create_time, updater, update_time, deleted)
VALUES (2, 'Ballcat', 'ALIYUN', 0, '啦啦啦', 'LTAI5tCnKso2uG3kJ5gRav88', 'fGJ5SNXL7P1NHNRmJ7DJaMJGPyE55C', null, '',
        '2021-03-31 11:53:10', '1', '2021-04-14 00:08:37', false);
INSERT INTO interview.system_sms_channel (id, signature, code, status, remark, api_key, api_secret, callback_url,
                                          creator, create_time, updater, update_time, deleted)
VALUES (4, '测试渠道', 'DEBUG_DING_TALK', 0, '123', '696b5d8ead48071237e4aa5861ff08dbadb2b4ded1c688a7b7c9afc615579859',
        'SEC5c4e5ff888bc8a9923ae47f59e7ccd30af1f14d93c55b4e2c9cb094e35aeed67', null, '1', '2021-04-13 00:23:14', '1',
        '2022-03-27 20:29:49', false);
INSERT INTO interview.system_sms_channel (id, signature, code, status, remark, api_key, api_secret, callback_url,
                                          creator, create_time, updater, update_time, deleted)
VALUES (6, '测试演示', 'DEBUG_DING_TALK', 0, null, '696b5d8ead48071237e4aa5861ff08dbadb2b4ded1c688a7b7c9afc615579859',
        'SEC5c4e5ff888bc8a9923ae47f59e7ccd30af1f14d93c55b4e2c9cb094e35aeed67', null, '1', '2022-04-10 23:07:59', '1',
        '2022-06-19 00:33:54', false);

INSERT INTO interview.system_sms_template (id, type, status, code, name, content, params, remark, api_template_id,
                                           channel_id, channel_code, creator, create_time, updater, update_time,
                                           deleted)
VALUES (2, 1, 0, 'test_01', '测试验证码短信', '正在进行登录操作{operation}，您的验证码是{code}', '["operation","code"]',
        null, '4383920', 6, 'DEBUG_DING_TALK', '', '2021-03-31 10:49:38', '1', '2022-12-10 21:26:20', false);
INSERT INTO interview.system_sms_template (id, type, status, code, name, content, params, remark, api_template_id,
                                           channel_id, channel_code, creator, create_time, updater, update_time,
                                           deleted)
VALUES (3, 1, 0, 'test_02', '公告通知', '您的验证码{code}，该验证码5分钟内有效，请勿泄漏于他人！', '["code"]', null,
        'SMS_207945135', 2, 'ALIYUN', '', '2021-03-31 11:56:30', '1', '2021-04-10 01:22:02', false);
INSERT INTO interview.system_sms_template (id, type, status, code, name, content, params, remark, api_template_id,
                                           channel_id, channel_code, creator, create_time, updater, update_time,
                                           deleted)
VALUES (6, 3, 0, 'test-01', '测试模板', '哈哈哈 {name}', '["name"]', 'f哈哈哈', '4383920', 6, 'DEBUG_DING_TALK', '1',
        '2021-04-10 01:07:21', '1', '2022-12-10 21:26:09', false);
INSERT INTO interview.system_sms_template (id, type, status, code, name, content, params, remark, api_template_id,
                                           channel_id, channel_code, creator, create_time, updater, update_time,
                                           deleted)
VALUES (7, 3, 0, 'test-04', '测试下', '老鸡{name}，牛逼{code}', '["name","code"]', null, 'suibian', 4, 'DEBUG_DING_TALK',
        '1', '2021-04-13 00:29:53', '1', '2021-04-14 00:30:38', false);
INSERT INTO interview.system_sms_template (id, type, status, code, name, content, params, remark, api_template_id,
                                           channel_id, channel_code, creator, create_time, updater, update_time,
                                           deleted)
VALUES (8, 1, 0, 'user-sms-login', '前台用户短信登录', '您的验证码是{code}', '["code"]', null, '4372216', 6,
        'DEBUG_DING_TALK', '1', '2021-10-11 08:10:00', '1', '2022-12-10 21:25:59', false);
INSERT INTO interview.system_sms_template (id, type, status, code, name, content, params, remark, api_template_id,
                                           channel_id, channel_code, creator, create_time, updater, update_time,
                                           deleted)
VALUES (9, 2, 0, 'bpm_task_assigned', '【工作流】任务被分配',
        '您收到了一条新的待办任务：{processInstanceName}-{taskName}，申请人：{startUserNickname}，处理链接：{detailUrl}',
        '["processInstanceName","taskName","startUserNickname","detailUrl"]', null, 'suibian', 4, 'DEBUG_DING_TALK',
        '1', '2022-01-21 22:31:19', '1', '2022-01-22 00:03:36', false);
INSERT INTO interview.system_sms_template (id, type, status, code, name, content, params, remark, api_template_id,
                                           channel_id, channel_code, creator, create_time, updater, update_time,
                                           deleted)
VALUES (10, 2, 0, 'bpm_process_instance_reject', '【工作流】流程被不通过',
        '您的流程被审批不通过：{processInstanceName}，原因：{reason}，查看链接：{detailUrl}',
        '["processInstanceName","reason","detailUrl"]', null, 'suibian', 4, 'DEBUG_DING_TALK', '1',
        '2022-01-22 00:03:31', '1', '2022-05-01 12:33:14', false);
INSERT INTO interview.system_sms_template (id, type, status, code, name, content, params, remark, api_template_id,
                                           channel_id, channel_code, creator, create_time, updater, update_time,
                                           deleted)
VALUES (11, 2, 0, 'bpm_process_instance_approve', '【工作流】流程被通过',
        '您的流程被审批通过：{processInstanceName}，查看链接：{detailUrl}', '["processInstanceName","detailUrl"]', null,
        'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-22 00:04:31', '1', '2022-03-27 20:32:21', false);
INSERT INTO interview.system_sms_template (id, type, status, code, name, content, params, remark, api_template_id,
                                           channel_id, channel_code, creator, create_time, updater, update_time,
                                           deleted)
VALUES (12, 2, 0, 'demo', '演示模板', '我就是测试一下下', '[]', null, 'biubiubiu', 6, 'DEBUG_DING_TALK', '1',
        '2022-04-10 23:22:49', '1', '2023-03-24 23:45:07', false);

INSERT INTO interview.system_tenant (id, name, contact_user_id, contact_name, contact_mobile, status, domain,
                                     package_id, expire_time, account_count, creator, create_time, updater, update_time,
                                     deleted)
VALUES (1, '芋道源码', null, '芋艿', '17321315478', 0, 'https://www.iocoder.cn', 0, '2099-02-19 17:14:16', 9999, '1',
        '2021-01-05 17:03:47', '1', '2022-02-23 12:15:11', false);
INSERT INTO interview.system_tenant (id, name, contact_user_id, contact_name, contact_mobile, status, domain,
                                     package_id, expire_time, account_count, creator, create_time, updater, update_time,
                                     deleted)
VALUES (121, '小租户', 110, '小王2', '15601691300', 0, 'http://www.iocoder.cn', 111, '2024-03-11 00:00:00', 20, '1',
        '2022-02-22 00:56:14', '1', '2022-05-17 10:03:59', false);
INSERT INTO interview.system_tenant (id, name, contact_user_id, contact_name, contact_mobile, status, domain,
                                     package_id, expire_time, account_count, creator, create_time, updater, update_time,
                                     deleted)
VALUES (122, '测试租户', 113, '芋道', '15601691300', 0, 'https://www.iocoder.cn', 111, '2022-04-30 00:00:00', 50, '1',
        '2022-03-07 21:37:58', '1', '2023-04-15 09:17:54', false);

INSERT INTO interview.system_tenant_package (id, name, status, remark, menu_ids, creator, create_time, updater,
                                             update_time, deleted)
VALUES (111, '普通套餐', 0, '小功能',
        '[1,1036,1037,1038,1039,100,101,1063,103,1064,1001,1065,1002,1003,107,1004,1005,1006,1007,1008,1009,1010,1011,1012,1017,1018,1019,1020]',
        '1', '2022-02-22 00:54:00', '1', '2022-09-21 22:48:12', false);

INSERT INTO interview.system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (112, 1, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', false, 1);
INSERT INTO interview.system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (113, 100, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', false, 1);
INSERT INTO interview.system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (114, 114, 3, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', false, 1);
INSERT INTO interview.system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (115, 104, 1, '1', '2022-05-16 19:36:28', '1', '2022-05-16 19:36:28', false, 1);
INSERT INTO interview.system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (116, 117, 2, '1', '2022-07-09 17:40:26', '1', '2022-07-09 17:40:26', false, 1);
INSERT INTO interview.system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (117, 118, 1, '1', '2022-07-09 17:44:44', '1', '2022-07-09 17:44:44', false, 1);

INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (1, 1, 1, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:17', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (2, 2, 2, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:13', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (4, 100, 101, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:13', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (5, 100, 1, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:12', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (6, 100, 2, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:11', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (10, 103, 1, '1', '2022-01-11 13:19:45', '1', '2022-01-11 13:19:45', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (11, 107, 106, '1', '2022-02-20 22:59:33', '1', '2022-02-20 22:59:33', false, 118);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (12, 108, 107, '1', '2022-02-20 23:00:50', '1', '2022-02-20 23:00:50', false, 119);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (13, 109, 108, '1', '2022-02-20 23:11:50', '1', '2022-02-20 23:11:50', false, 120);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (14, 110, 109, '1', '2022-02-22 00:56:14', '1', '2022-02-22 00:56:14', false, 121);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (15, 111, 110, '110', '2022-02-23 13:14:38', '110', '2022-02-23 13:14:38', false, 121);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (16, 113, 111, '1', '2022-03-07 21:37:58', '1', '2022-03-07 21:37:58', false, 122);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (17, 114, 101, '1', '2022-03-19 21:51:13', '1', '2022-03-19 21:51:13', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (18, 1, 2, '1', '2022-05-12 20:39:29', '1', '2022-05-12 20:39:29', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (19, 116, 113, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (20, 104, 101, '1', '2022-05-28 15:43:57', '1', '2022-05-28 15:43:57', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (22, 115, 2, '1', '2022-07-21 22:08:30', '1', '2022-07-21 22:08:30', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (23, 119, 114, '1', '2022-12-30 11:32:04', '1', '2022-12-30 11:32:04', false, 125);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (24, 120, 115, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (25, 121, 116, '1', '2022-12-30 11:33:49', '1', '2022-12-30 11:33:49', false, 127);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (26, 122, 118, '1', '2022-12-30 11:47:53', '1', '2022-12-30 11:47:53', false, 129);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (27, 112, 101, '1', '2023-02-09 23:18:51', '1', '2023-02-09 23:18:51', false, 1);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (28, 123, 136, '1', '2023-03-05 21:23:35', '1', '2023-03-05 21:23:35', false, 147);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (29, 124, 137, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted,
                                        tenant_id)
VALUES (30, 125, 138, '1', '2023-03-05 21:59:03', '1', '2023-03-05 21:59:03', false, 149);

INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (1, 'admin', '$2a$10$mRMIYLDtRHlf6.9ipiqH1.Z.bh/R9dO9d5iHiGYPigi6r5KOoR2Wm', '芋道源码', '管理员', 103, '[1]',
        'aoteman@126.com', '15612345678', 1,
        'http://test.yudao.iocoder.cn/e1fdd7271685ec143a0900681606406621717a666ad0b2798b096df41422b32f.png', 0,
        '127.0.0.1', '2023-07-24 08:41:23', 'admin', '2021-01-05 17:03:47', null, '2023-07-24 08:41:23', false, 1);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (100, 'yudao', '$2a$10$11U48RhyJ5pSBYWSn12AD./ld671.ycSzJHbyrtpeoMeYiw31eo8a', '芋道', '不要吓我', 104, '[1]',
        'yudao@iocoder.cn', '15601691300', 1, '', 1, '127.0.0.1', '2022-07-09 23:03:33', '', '2021-01-07 09:07:17',
        null, '2022-07-09 23:03:33', false, 1);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (103, 'yuanma', '$2a$10$YMpimV4T6BtDhIaA8jSW.u8UTGBeGhc/qwXP4oxoMr4mOw9.qttt6', '源码', null, 106, null,
        'yuanma@iocoder.cn', '15601701300', 0, '', 0, '127.0.0.1', '2022-07-08 01:26:27', '', '2021-01-13 23:50:35',
        null, '2022-07-08 01:26:27', false, 1);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (104, 'test', '$2a$10$GP8zvqHB//TekuzYZSBYAuBQJiNq1.fxQVDYJ.uBCOnWCtDVKE4H6', '测试号', null, 107, '[1,2]',
        '111@qq.com', '15601691200', 1, '', 0, '127.0.0.1', '2022-05-28 15:43:17', '', '2021-01-21 02:13:53', null,
        '2022-07-09 09:00:33', false, 1);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (107, 'admin107', '$2a$10$dYOOBKMO93v/.ReCqzyFg.o67Tqk.bbc2bhrpyBGkIw9aypCtr2pm', '芋艿', null, null, null, '',
        '15601691300', 0, '', 0, '', null, '1', '2022-02-20 22:59:33', '1', '2022-02-27 08:26:51', false, 118);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (108, 'admin108', '$2a$10$y6mfvKoNYL1GXWak8nYwVOH.kCWqjactkzdoIDgiKl93WN3Ejg.Lu', '芋艿', null, null, null, '',
        '15601691300', 0, '', 0, '', null, '1', '2022-02-20 23:00:50', '1', '2022-02-27 08:26:53', false, 119);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (109, 'admin109', '$2a$10$JAqvH0tEc0I7dfDVBI7zyuB4E3j.uH6daIjV53.vUS6PknFkDJkuK', '芋艿', null, null, null, '',
        '15601691300', 0, '', 0, '', null, '1', '2022-02-20 23:11:50', '1', '2022-02-27 08:26:56', false, 120);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (110, 'admin110', '$2a$10$mRMIYLDtRHlf6.9ipiqH1.Z.bh/R9dO9d5iHiGYPigi6r5KOoR2Wm', '小王', null, null, null, '',
        '15601691300', 0, '', 0, '127.0.0.1', '2022-09-25 22:47:33', '1', '2022-02-22 00:56:14', null,
        '2022-09-25 22:47:33', false, 121);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (111, 'test', '$2a$10$mExveopHUx9Q4QiLtAzhDeH3n4/QlNLzEsM4AqgxKrU.ciUZDXZCy', '测试用户', null, null, '[]', '',
        '', 0, '', 0, '', null, '110', '2022-02-23 13:14:33', '110', '2022-02-23 13:14:33', false, 121);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (112, 'newobject', '$2a$10$3alwklxqfq8/hKoW6oUV0OJp0IdQpBDauLy4633SpUjrRsStl6kMa', '新对象', null, 100, '[]', '',
        '', 1, '', 0, '0:0:0:0:0:0:0:1', '2023-02-10 13:48:13', '1', '2022-02-23 19:08:03', null, '2023-02-10 13:48:13',
        false, 1);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (113, 'aoteman', '$2a$10$0acJOIk2D25/oC87nyclE..0lzeu9DtQ/n3geP4fkun/zIVRhHJIO', '芋道', null, null, null, '',
        '15601691300', 0, '', 0, '127.0.0.1', '2022-03-19 18:38:51', '1', '2022-03-07 21:37:58', null,
        '2022-03-19 18:38:51', false, 122);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (114, 'hrmgr', '$2a$10$TR4eybBioGRhBmDBWkqWLO6NIh3mzYa8KBKDDB5woiGYFVlRAi.fu', 'hr 小姐姐', null, null, '[3]',
        '', '', 0, '', 0, '127.0.0.1', '2022-03-19 22:15:43', '1', '2022-03-19 21:50:58', null, '2022-03-19 22:15:43',
        false, 1);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (115, 'aotemane', '$2a$10$/WCwGHu1eq0wOVDd/u8HweJ0gJCHyLS6T7ndCqI8UXZAQom1etk2e', '1', '11', 101, '[]', '', '',
        1, '', 0, '', null, '1', '2022-04-30 02:55:43', '1', '2022-06-22 13:34:58', false, 1);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (116, '15601691302', '$2a$10$L5C4S0U6adBWMvFv1Wwl4.DI/NwYS3WIfLj5Q.Naqr5II8CmqsDZ6', '小豆', null, null, null,
        '', '', 0, '', 0, '', null, '1', '2022-05-17 10:07:10', '1', '2022-05-17 10:07:10', false, 124);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (117, 'admin123', '$2a$10$WI8Gg/lpZQIrOEZMHqka7OdFaD4Nx.B/qY8ZGTTUKrOJwaHFqibaC', '测试号', '1111', 100, '[2]',
        '', '15601691234', 1, '', 0, '', null, '1', '2022-07-09 17:40:26', '1', '2022-07-09 17:40:26', false, 1);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (118, 'goudan', '$2a$10$Lrb71muL.s5/AFjQ2IHkzOFlAFwUToH.zQL7bnghvTDt/QptjGgF6', '狗蛋', null, 103, '[1]', '', '',
        2, '', 0, '', null, '1', '2022-07-09 17:44:43', '1', '2022-12-31 17:29:13', false, 1);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (119, 'admin', '$2a$10$AheSOpxeWQYhEO/gGZhDz.oifdX5zt.kprWNHptPiiStUx4mXmHb.', '12', null, null, null, '', '', 0,
        '', 0, '', null, '1', '2022-12-30 11:32:04', '1', '2022-12-30 11:32:04', false, 125);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (120, 'admin', '$2a$10$D.xFtcgma/NJ3SyYlUj3bORcs0mwOD6Zu.4I7GCI/8/25/QSn4qJC', '12', null, null, null, '', '', 0,
        '', 0, '', null, '1', '2022-12-30 11:33:42', '1', '2022-12-30 11:33:42', false, 126);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (121, 'admin', '$2a$10$R2guBf7TyERjjW9lm0Pd0Osut6vt7NuH2Vx6fkOI5.VgSvJK2Xb82', '12', null, null, null, '', '', 0,
        '', 0, '', null, '1', '2022-12-30 11:33:49', '1', '2022-12-30 11:33:49', false, 127);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (122, 'admin', '$2a$10$pwxqUUza61HBgx3FTjp2d.Mc2UKalikXxP91wUdP4bFe7Hl.lfmeq', '12', null, null, null, '', '', 0,
        '', 0, '', null, '1', '2022-12-30 11:47:52', '1', '2022-12-30 11:47:52', false, 129);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (123, 'tudou', '$2a$10$m33ROHSPa9lshwQIaiVlFeoG1TZjCoQmfvExn4QWS8r5X59AEsTz2', '15601691234', null, null, null,
        '', '', 0, '', 0, '', null, '1', '2023-03-05 21:23:35', '1', '2023-03-05 21:23:35', false, 147);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (124, 'tudou', '$2a$10$1pzAJAEIRf/vYyMy8FTFiOzX40Q/NnozXixun/ExPZwv8A/CQkR4q', '15601691234', null, null, null,
        '', '', 0, '', 0, '', null, '1', '2023-03-05 21:42:27', '1', '2023-03-05 21:42:27', false, 148);
INSERT INTO interview.system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex,
                                    avatar, status, login_ip, login_date, creator, create_time, updater, update_time,
                                    deleted, tenant_id)
VALUES (125, 'admin', '$2a$10$E49momkI6Uf9v6pkfjoRP.dHzK4RjDIK39AWHz9eXRmqUR5sbJpoy', '秃头', null, null, null, '', '',
        0, '', 0, '', null, '1', '2023-03-05 21:59:03', '1', '2023-03-05 21:59:03', false, 149);
