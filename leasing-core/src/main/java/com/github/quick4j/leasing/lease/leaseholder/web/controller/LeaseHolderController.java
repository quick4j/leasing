package com.github.quick4j.leasing.lease.leaseholder.web.controller;

import com.github.quick4j.core.service.Criteria;
import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.lease.leaseholder.entity.LeaseHoder;
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
@RequestMapping("/holder")
public class LeaseHolderController {
    private final String LOCATION = "leaseholder/";

    @Resource
    private CrudService<LeaseHoder> crudService;

    @RequestMapping(method = RequestMethod.GET)
    public String listing(){
        return LOCATION + "index";
    }

    @RequestMapping(
            value = "/new",
            method = RequestMethod.GET
    )
    public String doShowNewDialog(){
        return LOCATION + "newHolder";
    }

    @RequestMapping(
            value = "/new",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doCreate(@Valid LeaseHoder holder){
        crudService.save(holder);
        return new AjaxResponse(true);
    }

    @RequestMapping(value = "/{id}/edit", method = RequestMethod.GET)
    public String doShowEditDialog(@PathVariable("id") String id){
        return LOCATION + "editHolder";
    }

    @RequestMapping(
            value = "/{id}/edit",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doUpdate(@Valid LeaseHoder holder){
        crudService.save(holder);
        return new AjaxResponse(true);
    }

    @RequestMapping(
            value = "/{id}/delete",
            method = RequestMethod.GET,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doDelete(@PathVariable("id") String id){
        Criteria<LeaseHoder> criteria = crudService.createCriteria(LeaseHoder.class);
        criteria.delete(id);
        return new AjaxResponse(true);
    }
}
