package com.github.quick4j.leasing.lease.relet.web.controller;

import com.github.quick4j.core.service.Criteria;
import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.lease.relet.entity.Leaser;
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
@RequestMapping("/relet/leaser")
public class LeaserController {
    private static final Logger logger = LoggerFactory.getLogger(LeaserController.class);
    private final String LOCATION = "relet/leaser/";
    @Resource
    private CrudService<Leaser> crudService;

    @RequestMapping(method = RequestMethod.GET)
    public String listing(){
        return LOCATION + "index";
    }

    @RequestMapping(value = "/new", method = RequestMethod.GET)
    public String doShowNewDialog(){
        return LOCATION + "new";
    }

    @RequestMapping(
            value = "/new",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doCreate(@Valid Leaser leaser){
        crudService.save(leaser);
        return new AjaxResponse(true);
    }

    @RequestMapping(value = "/{id}/edit", method = RequestMethod.GET)
    public String doShowEditDialog(@PathVariable("id") String id){
        return LOCATION + "edit";
    }

    @RequestMapping(
            value = "/{id}/edit",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doUpdate(@Valid Leaser leaser){
        crudService.save(leaser);
        return new AjaxResponse(true);
    }

    @RequestMapping(
            value = "/{id}/delete",
            method = RequestMethod.GET,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doDelete(@PathVariable("id") String id){
        Criteria<Leaser> criteria = crudService.createCriteria(Leaser.class);
        criteria.delete(id);
        return new AjaxResponse(true);
    }
}
