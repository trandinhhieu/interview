package com.dongvu.interview.Utils;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class DateUtils {
    // Định dạng ngày giờ mặc định (yyyy/MM/dd HH:mm:ss)
    public static final String DEFAULT_FORMAT = "yyyy/MM/dd HH:mm:ss";

    public static String getCurrentDateTime() {
        return getCurrentDateTime(DEFAULT_FORMAT);
    }

    public static String getCurrentDateTime(String format) {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(format);
        return now.format(formatter);
    }

    // Định dạng Date thành chuỗi với định dạng cụ thể
    public static String formatDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat(DEFAULT_FORMAT);
        return sdf.format(date);
    }
}

