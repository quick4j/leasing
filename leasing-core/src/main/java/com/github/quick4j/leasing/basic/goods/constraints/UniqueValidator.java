package com.github.quick4j.leasing.basic.goods.constraints;

import com.github.quick4j.core.repository.mybatis.Repository;
import org.springframework.web.context.ContextLoader;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

/**
 * @author zhaojh.
 */
public class UniqueValidator implements ConstraintValidator<Unique, String> {
    private Repository repository;

    @Override
    public void initialize(Unique unique) {
        repository = ContextLoader.getCurrentWebApplicationContext().getBean(Repository.class);
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext constraintValidatorContext) {
        return true;
//        if(value == null){
//            return true;
//        }

//        Fastener paramsTemplate = new Fastener();
//        paramsTemplate.setName(value);
//        List<Fastener> list = repository.findByParams(Fastener.class, paramsTemplate);
//
//        if(list.isEmpty()){
//            return true;
//        }else{
//            return false;
//        }
    }
}
