package com.dongvu.interview.model.dto;

import java.util.List;

public class MenuTreeDTO {
    private Long id;
    private String name;
    private List<MenuTreeDTO> children;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<MenuTreeDTO> getChildren() {
        return children;
    }

    public void setChildren(List<MenuTreeDTO> children) {
        this.children = children;
    }

}
