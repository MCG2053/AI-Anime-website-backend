package com.anime.website.dto;

import lombok.Data;

@Data
public class SuccessResponse {
    private Boolean success;
    
    public static SuccessResponse of(Boolean success) {
        SuccessResponse response = new SuccessResponse();
        response.setSuccess(success);
        return response;
    }
}
