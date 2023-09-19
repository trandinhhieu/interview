package com.dongvu.interview.Utils;

import org.mindrot.jbcrypt.BCrypt;

public class BcryptUtils {
    private static final int WORKLOAD = 12;

    public static String hashPassword(String plainTextPassword) {
        String salt = BCrypt.gensalt(WORKLOAD);
        return BCrypt.hashpw(plainTextPassword, salt);
    }

}
