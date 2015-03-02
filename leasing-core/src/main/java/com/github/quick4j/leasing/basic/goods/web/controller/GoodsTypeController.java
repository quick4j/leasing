package com.github.quick4j.leasing.basic.goods.web.controller;

import com.github.quick4j.core.service.Criteria;
import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.basic.goods.entity.GoodsType;
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
@RequestMapping("/goods/type")
public class GoodsTypeController {
    private final String LOCATION = "goods/";
    @Resource
    private CrudService<GoodsType> crudService;

    @RequestMapping(value = "/new", method = RequestMethod.GET)
    public String doShowNewDialog(){
        return LOCATION + "newGoodsType";
    }

    @RequestMapping(
            value = "/new",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doCreate(@Valid GoodsType goodsType){
        crudService.save(goodsType);
        return new AjaxResponse(true);
    }

    @RequestMapping(
            value = "/edit",
            method = RequestMethod.GET
    )
    public String doShowEditDialog(){
        return LOCATION + "editGoodsType";
    }

    @RequestMapping(
            value = "/edit",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doUpdate(@Valid GoodsType goodsType){
        crudService.save(goodsType);
        return new AjaxResponse(true);
    }

    @RequestMapping(
            value = "/{id}/delete",
            method = RequestMethod.GET,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doDelete(@PathVariable("id") String id){
        Criteria<GoodsType> criteria = crudService.createCriteria(GoodsType.class);
        criteria.delete(id);
        return new AjaxResponse(true);
    }
}
