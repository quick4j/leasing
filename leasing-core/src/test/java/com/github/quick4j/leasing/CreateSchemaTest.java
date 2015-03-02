package com.github.quick4j.leasing;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @author zhaojh.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
        "/spring-config.xml",
        "/spring-config-mybatis.xml",
        "/spring-config-jpa.xml"
})
public class CreateSchemaTest {

    @Test
    public void buildSchema(){
        System.out.println("build leasing schema.");
    }
}
