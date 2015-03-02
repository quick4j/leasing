package com.github.quick4j.leasing.lease.relet.web.controller;

import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.util.JsonUtils;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.lease.orders.OrderType;
import com.github.quick4j.leasing.lease.relet.entity.ReletOrder;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @author zhaojh.
 */
@Controller(value = "ReletFaLiaoDanController")
@RequestMapping("/relet/faliao")
public class FaLiaoDanController {
    private static final Logger logger = LoggerFactory.getLogger(FaLiaoDanController.class);
    private final String LOCATION = "relet/faliao/";

    @Resource
    private CrudService<ReletOrder> crudService;

    @RequestMapping(method = RequestMethod.GET)
    public String listing(){
        return LOCATION + "index";
    }

    @RequestMapping(value = "/new", method = RequestMethod.GET)
    public String doShowBlankOrder(){
        return LOCATION + "new";
    }

    @RequestMapping(
            value = "/new",
            method = RequestMethod.POST,
            produces = "application/json"
    )
    @ResponseBody
    public AjaxResponse doSave(@RequestParam("order") String order){
        ReletOrder reletOrder = JsonUtils.formJson(order, ReletOrder.class);
        String code = String.format("ZFL-%s", DateFormatUtils.format(new Date(), "yyyyMMddHHmmssSSSS"));
        reletOrder.setCode(code);
        reletOrder.setType(OrderType.OUT);
        crudService.save(reletOrder);

        Map<String, String> result = new HashMap<String, String>();
        result.put("id", reletOrder.getId());
        return new AjaxResponse(true, result);
    }
}
