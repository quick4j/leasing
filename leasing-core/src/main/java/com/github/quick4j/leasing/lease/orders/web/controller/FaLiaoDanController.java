package com.github.quick4j.leasing.lease.orders.web.controller;

import com.github.quick4j.core.service.Criteria;
import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.util.JsonUtils;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.lease.orders.OrderType;
import com.github.quick4j.leasing.lease.orders.entity.LeaseOrder;
import com.github.quick4j.leasing.lease.orders.entity.LeaseOrderItem;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author zhaojh.
 */
@Controller
@RequestMapping("/orders/faliao")
public class FaLiaoDanController {
    private final Logger logger = LoggerFactory.getLogger(FaLiaoDanController.class);

    private final String LOCATION = "orders/faliao/";
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
        String code = String.format("FL-%s", DateFormatUtils.format(new Date(), "yyyyMMddHHmmssSSSS"));
        order.setCode(code);
        order.setType(OrderType.OUT);
        crudService.save(order);

        Map<String, String> result = new HashMap<String, String>();
        result.put("id", order.getId());
        return new AjaxResponse(true, result);
    }

    @RequestMapping(
            value = "/{id}",
            method = RequestMethod.GET,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse showOrderDetails(@PathVariable("id") String id){
        Criteria<LeaseOrder> criteria = crudService.createCriteria(LeaseOrder.class);
        LeaseOrder leaseOrder = criteria.findOne(id);

        Criteria<LeaseOrderItem> itemsCriteria = crudService.createCriteria(LeaseOrderItem.class);
        LeaseOrderItem template = new LeaseOrderItem();
        template.setOrderId(id);
        List<LeaseOrderItem> items = itemsCriteria.findAll(template);
        leaseOrder.setItems(items);

        return new AjaxResponse(true, leaseOrder);
    }

    @RequestMapping(
            value = "/{id}/delete",
            method = RequestMethod.GET,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doDelete(@PathVariable("id") String id){
        Criteria<LeaseOrderItem> itemCriteria = crudService.createCriteria(LeaseOrderItem.class);
        LeaseOrderItem items = new LeaseOrderItem();
        items.setOrderId(id);
        itemCriteria.delete(items);

        Criteria<LeaseOrder> criteria = crudService.createCriteria(LeaseOrder.class);
        criteria.delete(id);
        return new AjaxResponse(true);
    }
}
