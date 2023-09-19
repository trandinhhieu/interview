package com.dongvu.interview.service;

import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;

import com.dongvu.interview.mapper.SystemUserMapper;
import com.dongvu.interview.mapper.SystemUserRoleMapper;
import com.dongvu.interview.model.SystemUser;
import com.dongvu.interview.model.SystemUserRole;

import static org.mockito.Mockito.*;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;
@SpringBootTest
public class SystemUserServiceTest2 {
	    @InjectMocks
	    private SystemUserService userService;

	    @Mock
	    private SystemUserMapper userMapper;

	    @Mock
	    private SystemUserRoleMapper userRoleMapper;

	    @Test
	    public void testUpdate_Success() {
	        // Tạo một đối tượng SystemUser giả lập
	        SystemUser existingUser = new SystemUser();
	        existingUser.setId(1L);
	        existingUser.setUsername("existingUsername");
	        existingUser.setEmail("existingEmail@example.com");
	        // Tạo một set của SystemUserRole (nếu cần)
	        Set<SystemUserRole> userRoles = new HashSet<>();
	        SystemUserRole role1 = new SystemUserRole();
	        role1.setId(1L);
	        role1.setUserId(1L);
	        role1.setTenantId(1L);
	        role1.setCreateTime(new Date());
	        userRoles.add(role1);

	        SystemUserRole role2 = new SystemUserRole();
	        role2.setId(2L);
	        role1.setUserId(2L);
	        role1.setTenantId(2L);
	        role1.setCreateTime(new Date());
	        userRoles.add(role2);

	        existingUser.setUserRoles(userRoles);
	        // Các giá trị khác...

	        // Giả lập hàm userMapper.findById trả về đối tượng existingUser
	        when(userMapper.findById(eq(1L))).thenReturn(existingUser);

	        // Giả lập hàm userMapper.countByUsername và userMapper.countByEmail trả về 0
	        when(userMapper.countByUsername(eq("newUsername"))).thenReturn(0);
	        when(userMapper.countByEmail(eq("newEmail@example.com"))).thenReturn(0);

	        // Gọi phương thức update
	        userService.update(existingUser);

	        // Kiểm tra xem hàm userMapper.update đã được gọi với đối tượng existingUser
	        verify(userMapper, times(1)).update(eq(existingUser));

	        // Kiểm tra xem hàm softDeleteRolesByUserId đã được gọi
	        verify(userRoleMapper, times(1)).softDeleteByUserId(eq(1L));

	        // Kiểm tra xem hàm userRoleMapper.insert đã được gọi cho mỗi SystemUserRole trong danh sách user.getUserRoles()
	        for (SystemUserRole userRole : existingUser.getUserRoles()) {
	            verify(userRoleMapper, times(1)).insert(eq(userRole));
	        }
	    }
}
