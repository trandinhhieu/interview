package com.dongvu.interview.exceptions;

public class EmailAlreadyExistsException extends RuntimeException {
    /**
     * 
     */
    private static final long serialVersionUID = 8000156661017793395L;

    public EmailAlreadyExistsException(String message) {
        super(message);
    }
}
