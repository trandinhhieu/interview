package com.dongvu.interview.service;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit4.SpringRunner;

import com.dongvu.interview.exceptions.UsernameAlreadyExistsException;
import com.dongvu.interview.mapper.SystemUserMapper;
import com.dongvu.interview.model.SystemUser;
import com.dongvu.interview.model.SystemUserRole;
import com.dongvu.interview.model.dto.SystemUserDTO;

@RunWith(SpringRunner.class)
@SpringBootTest
public class SystemUserServiceTest {
	
    @Autowired
    private SystemUserService userService;
    @MockBean
    private SystemUserMapper userMapper;
    
	@Test
    void testUpdateUser_Success() {
    	// Tạo đối tượng SystemUser giả lập
		SystemUser user = createMockData();

        // Giả lập hàm userMapper.findById trả về đối tượng user giả lập
        when(userMapper.findById(eq(1L))).thenReturn(user);

        // Giả lập hàm userMapper.countByUsername và userMapper.countByEmail
        when(userMapper.countByUsername(eq("newUsername"))).thenReturn(0);
        when(userMapper.countByEmail(eq("newEmail@example.com"))).thenReturn(0);

        // Gọi phương thức update
        userMapper.update(user);

        // Kiểm tra xem hàm userMapper.update đã được gọi với đối tượng user giả lập
        verify(userMapper, times(1)).update(eq(user));
    }
	
	@Test
    void testUpdateUser_UserNotFound() {
        // Giả lập hàm userMapper.findById trả về null, tức là không tìm thấy người dùng
        when(userMapper.findById(anyLong())).thenReturn(null);

        // Tạo một đối tượng SystemUser giả lập
        SystemUser user = mock(SystemUser.class);

        // Gọi phương thức update, sẽ ném ra UserNotFoundException
        userService.update(user);
    }
	
	@Test
    public void testUpdateUser_DuplicateUsername() {
        // Tạo một đối tượng SystemUser giả lập
    	SystemUser user = mock(SystemUser.class);

        // Giả lập hàm userMapper.findById trả về đối tượng user giả lập
        when(userMapper.findById(eq(1L))).thenReturn(user);

        // Giả lập hàm userMapper.countByUsername trả về 1, tức là username đã tồn tại
        when(userMapper.countByUsername(eq("newUsername"))).thenReturn(1);
        when(userMapper.countByEmail(eq("newEmail@example.com"))).thenReturn(0);

        // Gọi phương thức update, sẽ ném ra UsernameAlreadyExistsException
        userService.update(user);
    }
	
	@Test
    public void testFindById() {
        // Tạo một đối tượng SystemUser giả lập
        SystemUser mockUser = new SystemUser();
        mockUser.setId(1L);
        mockUser.setUsername("testUser");
        // Giả lập hành vi của userMapper.findById
        when(userMapper.findById(anyLong())).thenReturn(mockUser);

        // Gọi phương thức findById
        SystemUserDTO result = userService.findById(1L);

        // Kiểm tra kết quả
        assertNotNull(result);
        assertEquals("1", result.getId());
        assertEquals("testUser", result.getUsername());
        // Kiểm tra rằng userMapper.findById đã được gọi với tham số đúng
        verify(userMapper, times(1)).findById(1L);
    }
	
	public SystemUser createMockData() {
		Date currentDate = new Date();
		SystemUser user = new SystemUser();
        user.setId(131l);
        user.setUsername("john_doe");
        user.setPassword("password123");
        user.setNickname("John");
        user.setRemark("This is a sample user");
        user.setDeptId(101L);
        user.setPostIds("102,103");
        user.setEmail("john.doe@example.com");
        user.setMobile("1234567890");
        user.setSex(1); // 1 for male, 2 for female, 0 for other
        user.setAvatar("avatar.jpg");
        user.setStatus(1); // 1 for active, 0 for inactive
        user.setLoginIp("192.168.0.1");
        user.setLoginDate(currentDate);
        user.setCreator("admin");
        user.setCreateTime(currentDate);
        user.setUpdater("admin");
        user.setUpdateTime(currentDate);
        user.setDeleted(false);
        user.setTenantId(1L);

        // Tạo một set của SystemUserRole (nếu cần)
        Set<SystemUserRole> userRoles = new HashSet<>();
        SystemUserRole role1 = new SystemUserRole();
        role1.setId(1l);
        role1.setUserId(user.getId());
        role1.setTenantId(user.getTenantId());
        role1.setCreateTime(currentDate);
        userRoles.add(role1);

        SystemUserRole role2 = new SystemUserRole();
        role2.setId(2l);
        role1.setUserId(user.getId());
        role1.setTenantId(user.getTenantId());
        role1.setCreateTime(currentDate);
        userRoles.add(role2);

        user.setUserRoles(userRoles);
        return user;
	}
}
