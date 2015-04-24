package com.github.quick4j.leasing.leaseholder.web.controller;

import com.github.quick4j.core.service.Criteria;
import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.leaseholder.entity.Project;
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
@RequestMapping("/project")
public class ProjectController {
    private final String LOCATION = "leaseholder/";
    @Resource
    private CrudService<Project> crudService;

    @RequestMapping(
            value = "/new",
            method = RequestMethod.GET
    )
    public String doShowNewDialog(){
        return LOCATION + "newProject";
    }

    @RequestMapping(
            value = "/new",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doCreate(@Valid Project project){
        crudService.save(project);
        return new AjaxResponse(true);
    }

    @RequestMapping(value = "/{id}/edit", method = RequestMethod.GET)
    public String doShowEditDialog(@PathVariable("id") String id){
        return LOCATION + "editProject";
    }

    @RequestMapping(
            value = "/{id}/edit",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doUpdate(@Valid Project project){
        crudService.save(project);
        return new AjaxResponse(true);
    }

    @RequestMapping(
            value = "/{id}/delete",
            method = RequestMethod.GET,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doDelete(@PathVariable("id") String id){
        Criteria<Project> criteria = crudService.createCriteria(Project.class);
        criteria.delete(id);
        return new AjaxResponse(true);
    }
}
