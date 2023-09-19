package com.dongvu.interview.service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dongvu.interview.Utils.BcryptUtils;
import com.dongvu.interview.Utils.DateUtils;
import com.dongvu.interview.exceptions.EmailAlreadyExistsException;
import com.dongvu.interview.exceptions.UserNotFoundException;
import com.dongvu.interview.exceptions.UsernameAlreadyExistsException;
import com.dongvu.interview.mapper.SystemUserMapper;
import com.dongvu.interview.mapper.SystemUserRoleMapper;
import com.dongvu.interview.model.SystemUser;
import com.dongvu.interview.model.SystemUserRole;
import com.dongvu.interview.model.dto.SystemUserDTO;

@Service
public class SystemUserService {
    private final SystemUserMapper userMapper;
    private final SystemUserRoleMapper userRoleMapper;

    @Autowired
    public SystemUserService(SystemUserMapper userMapper, SystemUserRoleMapper userRoleMapper) {
        this.userMapper = userMapper;
        this.userRoleMapper = userRoleMapper;
    }

    @Transactional
    public void create(SystemUser user) {
        if (user == null) {
            throw new IllegalArgumentException("User parameter cannot be null");
        }
        // Kiểm tra sự tồn tại của username và email
        int usernameCount = userMapper.countByUsername(user.getUsername());
        int emailCount = userMapper.countByEmail(user.getEmail());
        if (usernameCount > 0) {
            throw new UsernameAlreadyExistsException("Username already exists");
        }
        if (emailCount > 0) {
            throw new EmailAlreadyExistsException("Email already exists");
        }
        Date currentDate = new Date();

        // Thiết lập thông tin cho đối tượng SystemUser
        user.setCreateTime(currentDate);
        user.setPassword(BcryptUtils.hashPassword(user.getPassword()));

        // Thêm người dùng vào cơ sở dữ liệu
        userMapper.insert(user);

        // Lặp qua danh sách các vai trò của người dùng và thêm chúng vào cơ sở dữ liệu
        for (SystemUserRole userRole : user.getUserRoles()) {
            userRole.setUserId(user.getId()); // Đặt userId cho mỗi SystemUserRole
            userRole.setTenantId(user.getTenantId());
            userRole.setCreateTime(currentDate);
            userRoleMapper.insert(userRole);
        }
    }

    public SystemUserDTO findById(long id) {
        return convertFromSystemUser(userMapper.findById(id));
    }

    public List<SystemUserDTO> findAll() {
        return userMapper.findAll().stream()
                .map(this::convertFromSystemUser)
                .collect(Collectors.toList());
    }

    public List<SystemUser> searchUsers(String search) {
        return userMapper.findUsersBySearchCriteria(search);
    }

    public void update(SystemUser user) {

        // Kiểm tra xem người dùng đã tồn tại trong cơ sở dữ liệu hay chưa
        SystemUser existingUser = userMapper.findById(user.getId());

        if (existingUser == null) {
            throw new UserNotFoundException("User not found");
        }

        // Kiểm tra sự thay đổi của username và email
        if (!existingUser.getUsername().equals(user.getUsername())) {
            int usernameCount = userMapper.countByUsername(user.getUsername());
            if (usernameCount > 0) {
                throw new UsernameAlreadyExistsException("Username already exists");
            }
        }

        if (!existingUser.getEmail().equals(user.getEmail())) {
            int emailCount = userMapper.countByEmail(user.getEmail());
            if (emailCount > 0) {
                throw new EmailAlreadyExistsException("Email already exists");
            }
        }

        Date currentDate = new Date();
        // Cập nhật thông tin người dùng
        user.setPassword(BcryptUtils.hashPassword(user.getPassword()));
        user.setUpdateTime(currentDate);
        userMapper.update(user);

        // Xóa vai trò người dùng cũ và thêm lại các vai trò mới
        softDeleteRolesByUserId(user.getId());
        if (user.getUserRoles() != null) {
            for (SystemUserRole userRole : user.getUserRoles()) {
                userRole.setUserId(user.getId());
                userRole.setTenantId(user.getTenantId());
                userRole.setCreateTime(currentDate);
                userRoleMapper.insert(userRole);
            }
		}
    }

    public void delete(long id) {
        userMapper.delete(id);
    }

    public SystemUserDTO convertFromSystemUser(SystemUser user) {
        SystemUserDTO userDTO = new SystemUserDTO();
        userDTO.setId(user.getId() != null ? user.getId().toString() : null);
        userDTO.setUsername(user.getUsername());
        userDTO.setPassword(user.getPassword());
        userDTO.setNickname(user.getNickname());
        userDTO.setRemark(user.getRemark());
        userDTO.setDeptId(user.getDeptId() != null ? user.getDeptId().toString() : null);
        userDTO.setPostIds(user.getPostIds());
        userDTO.setEmail(user.getEmail());
        userDTO.setMobile(user.getMobile());
        userDTO.setSex(user.getSex() != null ? user.getSex().toString() : null);
        userDTO.setAvatar(user.getAvatar());
        userDTO.setStatus(user.getStatus() != null ? user.getStatus().toString() : null);
        userDTO.setLoginIp(user.getLoginIp());
        userDTO.setLoginDate(user.getLoginDate() != null ? DateUtils.formatDate(user.getLoginDate()) : null);
        userDTO.setCreator(user.getCreator());
        userDTO.setCreateTime(user.getCreateTime() != null ? DateUtils.formatDate(user.getCreateTime()) : null);
        userDTO.setUpdater(user.getUpdater());
        userDTO.setUpdateTime(user.getUpdateTime() != null ? DateUtils.formatDate(user.getUpdateTime()) : null);
        userDTO.setDeleted(user.getDeleted() != null ? user.getDeleted().toString() : null);
        userDTO.setTenantId(user.getTenantId() != null ? user.getTenantId().toString() : null);
        return userDTO;
    }
    
    public void softDeleteRolesByUserId(Long userId) {
        userRoleMapper.softDeleteByUserId(userId);
    }
}

