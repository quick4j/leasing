package com.github.quick4j.leasing.basic.goods.web.controller;

import com.github.quick4j.core.service.Criteria;
import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.util.JsonUtils;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.basic.goods.entity.Goods;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.validation.Valid;

/**
 * @author zhaojh.
 */
@Controller
@RequestMapping("/basic/goods")
public class GoodsController {
    private static final Logger logger = LoggerFactory.getLogger(GoodsController.class);
    private final String LOCATION = "basic/goods/";

    @Resource
    private CrudService<Goods> crudService;

    @RequestMapping(method = RequestMethod.GET)
    public String listing(){
        return LOCATION + "index";
    }

    @RequestMapping(
            value = "/new",
            method = RequestMethod.GET
    )
    public String doShowNewDialog(){
        return LOCATION + "newGoods";
    }

    @RequestMapping(
            value = "/new",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doCreate(@Valid Goods goods){
        crudService.save(goods);
        return new AjaxResponse(true);
    }

    @RequestMapping(
            value = "/edit",
            method = RequestMethod.GET
    )
    public String doShowEditDialog(){
        return LOCATION + "editGoods";
    }

    @RequestMapping(
            value = "/edit",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doUpdate(@Valid Goods goods){
        logger.info("===>Goods: " + JsonUtils.toJson(goods));
        crudService.save(goods);
        return new AjaxResponse(true);
    }

    @RequestMapping(
            value = "/{id}/delete",
            method = RequestMethod.GET,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doDelete(@PathVariable("id") String id){
        Criteria<Goods> criteria = crudService.createCriteria(Goods.class);
        criteria.delete(id);
        return new AjaxResponse(true);
    }
}
