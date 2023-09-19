package com.dongvu.interview.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.dongvu.interview.model.dto.MenuTreeDTO;
import com.dongvu.interview.service.SystemMenuService;

@RestController
@RequestMapping("/menus")
public class SystemMenuController {

    @Autowired
    private SystemMenuService systemMenuService;

    @GetMapping
    public ResponseEntity<List<MenuTreeDTO>> getMenuTreeByUserId(@RequestParam Long userId) {
        List<MenuTreeDTO> menus = systemMenuService.getMenuTreeByUserId(userId);
        return ResponseEntity.ok(menus);
    }
}
