package com.dongvu.interview.exceptions;

public class UserNotFoundException extends RuntimeException {

    /**
	 * 
	 */
	private static final long serialVersionUID = -1990679709118758549L;

	public UserNotFoundException(String message) {
        super(message);
    }
}
