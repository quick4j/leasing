package com.github.quick4j.leasing;

import org.apache.commons.lang3.time.DateFormatUtils;
import org.junit.Test;

import java.util.Date;

/**
 * @author zhaojh.
 */
public class OrderCodeTest {
    @Test
    public void testBuildCode(){
        String code = String.format(
                "OUT-%s",
                DateFormatUtils.format(new Date(), "yyyyMMddHHmmssSSSS")
        );
        System.out.println(code);
    }
}
