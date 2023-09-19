package com.dongvu.interview.service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import com.dongvu.interview.mapper.SystemMenuMapper;
import com.dongvu.interview.model.SystemMenu;
import com.dongvu.interview.model.dto.MenuTreeDTO;

@Service
public class SystemMenuService {
    private static final Logger logger = LoggerFactory.getLogger(SystemMenuService.class);
    @Autowired
    private SystemMenuMapper systemMenuMapper;
    @Autowired
    private RedisTemplate<String, List<MenuTreeDTO>> redisTemplate;
    @Autowired
    private HashOperations<String, String, List<MenuTreeDTO>> hashOperations;

    public List<MenuTreeDTO> getMenuTreeByUserId(Long userId) {
        // Attempt to fetch the result from Redis cache
        String cacheKey = "menuTree";
        String userIdStr = String.valueOf(userId);
        List<MenuTreeDTO> cachedMenuTree = hashOperations.get(cacheKey, userIdStr);
        if (cachedMenuTree != null) {
            logger.debug("Get from cached");
            return cachedMenuTree; // Return cached data if available
        }
        // If data is not in cache, retrieve it from the database
        List<MenuTreeDTO> menuTree = buildMenuTree(0L, userId);

        // Store the data in Redis cache with a 1-minute expiration time
        hashOperations.put(cacheKey, userIdStr, menuTree);
        redisTemplate.expire(cacheKey, 1, TimeUnit.MINUTES);

        return menuTree;
    }

    private List<MenuTreeDTO> buildMenuTree(Long parentId, Long userId) {
        List<MenuTreeDTO> menuTree = new ArrayList<>();
        List<SystemMenu> menuList = systemMenuMapper.getMenusByParentIdAndUserId(parentId, userId);

        for (SystemMenu menu : menuList) {
            MenuTreeDTO menuDTO = new MenuTreeDTO();
            menuDTO.setId(menu.getId());
            menuDTO.setName(menu.getName());
            // Recursion to retrieve the submenu list
            menuDTO.setChildren(buildMenuTree(menu.getId(), userId));
            menuTree.add(menuDTO);
        }

        return menuTree;
    }
}
