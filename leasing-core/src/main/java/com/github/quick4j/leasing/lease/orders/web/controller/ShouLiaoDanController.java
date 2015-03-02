package com.github.quick4j.leasing.lease.orders.web.controller;

import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.util.JsonUtils;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.lease.orders.OrderType;
import com.github.quick4j.leasing.lease.orders.entity.LeaseOrder;
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
@Controller
@RequestMapping("/orders/shouliao")
public class ShouLiaoDanController {
    private final Logger logger = LoggerFactory.getLogger(ShouLiaoDanController.class);

    private final String LOCATION = "orders/shouliao/";
    @Resource
    private CrudService<LeaseOrder> crudService;

    @RequestMapping(method = RequestMethod.GET)
    public String listing(){
        return LOCATION + "index";
    }

    @RequestMapping(value = "/new", method = RequestMethod.GET)
    public String doShowBlankOutboundOrder(){
        return LOCATION + "new";
    }

    @RequestMapping(
            value = "/new",
            method = RequestMethod.POST,
            produces = "application/json"
    )
    @ResponseBody
    public AjaxResponse doSave(@RequestParam("leaseorder") String leaseOrder){
        LeaseOrder order = JsonUtils.formJson(leaseOrder, LeaseOrder.class);
        String code = String.format("SL-%s", DateFormatUtils.format(new Date(), "yyyyMMddHHmmssSSSS"));
        order.setCode(code);
        order.setType(OrderType.IN);
        crudService.save(order);

        Map<String, String> result = new HashMap<String, String>();
        result.put("id", order.getId());
        return new AjaxResponse(true, result);
    }
}
