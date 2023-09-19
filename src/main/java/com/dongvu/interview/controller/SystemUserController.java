package com.dongvu.interview.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.dongvu.interview.model.SystemUser;
import com.dongvu.interview.model.dto.SystemUserDTO;
import com.dongvu.interview.service.SystemUserService;

@RestController
@RequestMapping("/v1/users")
public class SystemUserController {
    private final SystemUserService userService;

    @Autowired
    public SystemUserController(SystemUserService userService) {
        this.userService = userService;
    }

    @PostMapping
    public ResponseEntity<Void> createUser(@RequestBody SystemUser user) {
        try {
            userService.create(user);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
        
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<SystemUserDTO> getUserById(@PathVariable long id) {
        SystemUserDTO user = userService.findById(id);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/search")
    public ResponseEntity<List<SystemUser>> searchUsers(@RequestParam("keyword") String search) {
        List<SystemUser> users = userService.searchUsers(search);
        return ResponseEntity.ok(users);
    }

    @GetMapping
    public ResponseEntity<List<SystemUserDTO>> getAllUsers() {
        List<SystemUserDTO> users = userService.findAll();
        return ResponseEntity.ok(users);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Void> updateUser(@PathVariable long id, @RequestBody SystemUser user) {
    	try {
    		if (id == 0) {
    			throw new IllegalArgumentException("Id parameter is required");
			}
            if (user == null) {
                throw new IllegalArgumentException("User parameter cannot be null");
            }
            user.setId(id);
            userService.update(user);
		} catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}

        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable long id) {
        userService.delete(id);
        return ResponseEntity.noContent().build();
    }
}

