package com.anime.website.dto;

import lombok.Data;

@Data
public class LoginResponse {
    private String token;
    private UserDTO user;
}
