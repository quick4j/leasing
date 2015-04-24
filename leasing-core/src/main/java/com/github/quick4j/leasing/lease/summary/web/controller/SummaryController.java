package com.github.quick4j.leasing.lease.summary.web.controller;

import com.github.quick4j.core.service.Criteria;
import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.lease.summary.entity.SummaryResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zhaojh.
 */
@Controller
@RequestMapping("/summary")
public class SummaryController {
    private static final Logger logger = LoggerFactory.getLogger(SummaryController.class);
    private final String LOCATION = "summary/";
    @Resource
    private CrudService<SummaryResult> crudService;

    @RequestMapping(
            value = "/leasing",
            method = RequestMethod.GET
    )
    public String showQueryLeasing3(){
        return LOCATION + "leasing";
    }

    @RequestMapping(
            value = "/leasing",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse queryLeasing(@RequestParam(required = false) String holderid,
                                     @RequestParam(required = false) String projectid){
        logger.info("===> queryLeasing.");
        logger.info("===> holderid:" + holderid);
        logger.info("===> projectid:" + projectid);

        Map<String, Object> parameters = new HashMap<String, Object>();
        parameters.put("holderId", holderid);
        parameters.put("projectId", projectid);

        Criteria<SummaryResult> criteria = crudService.createCriteria(SummaryResult.class);
        List<SummaryResult> list = criteria.findAll("generalSummary", parameters);

        parameters.clear();
        parameters.put("rows", list);
        return new AjaxResponse(true, parameters);
    }

    @RequestMapping(
            value = "/relet",
            method = RequestMethod.GET
    )
    public String showQueryRelet(){
        return LOCATION + "relet";
    }

    @RequestMapping(
            value = "/relet",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse SummaryRelet(@RequestParam(required = false) String leaserid){

        Map<String, Object> parameters = new HashMap<String, Object>();
        parameters.put("leaserId", leaserid);

        Criteria<SummaryResult> criteria = crudService.createCriteria(SummaryResult.class);
        List<SummaryResult> list = criteria.findAll("generalReletSummary", parameters);
        parameters.clear();
        parameters.put("rows", list);
        return new AjaxResponse(true, parameters);
    }
}
