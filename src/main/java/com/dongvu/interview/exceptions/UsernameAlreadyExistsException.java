package com.dongvu.interview.exceptions;

public class UsernameAlreadyExistsException extends RuntimeException {
    /**
     * 
     */
    private static final long serialVersionUID = 869714737462492781L;

    public UsernameAlreadyExistsException(String message) {
        super(message);
    }
}
