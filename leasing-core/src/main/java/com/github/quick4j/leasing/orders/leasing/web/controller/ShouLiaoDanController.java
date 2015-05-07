package com.github.quick4j.leasing.orders.leasing.web.controller;

import com.github.quick4j.core.service.Criteria;
import com.github.quick4j.core.service.CrudService;
import com.github.quick4j.core.util.JsonUtils;
import com.github.quick4j.core.web.http.AjaxResponse;
import com.github.quick4j.leasing.orders.entity.OrderType;
import com.github.quick4j.leasing.orders.leasing.entity.LeaseOrder;
import com.github.quick4j.leasing.orders.leasing.entity.LeaseOrderItem;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @author zhaojh.
 */
@Controller
@RequestMapping("/orders/leaseorder/in")
public class ShouLiaoDanController {
    private final Logger logger = LoggerFactory.getLogger(ShouLiaoDanController.class);

    private final String LOCATION = "orders/leasing/in/";
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
        result.put("code", order.getCode());
        return new AjaxResponse(true, result);
    }

    @RequestMapping(
            value = "/{id}",
            method = RequestMethod.GET
    )
    public String showOrderDetails(@PathVariable("id") String id, Model model){
        Criteria<LeaseOrder> criteria = crudService.createCriteria(LeaseOrder.class);
        LeaseOrder leaseOrder = criteria.findOne(id);
        model.addAttribute("order", leaseOrder);
        return LOCATION + "details";
    }

    @RequestMapping(
            value = "/{id}/edit",
            method = RequestMethod.GET
    )
    public String showEditForm(@PathVariable("id") String id, Model model){
        Criteria<LeaseOrder> criteria = crudService.createCriteria(LeaseOrder.class);
        LeaseOrder leaseOrder = criteria.findOne(id);
        model.addAttribute("order", leaseOrder);
        return LOCATION + "edit";
    }

    @RequestMapping(
            value = "/{id}/edit",
            method = RequestMethod.POST,
            produces = "application/json;charset=utf-8"
    )
    @ResponseBody
    public AjaxResponse doUpdate(@RequestParam("leaseorder") String leaseOrder){
        LeaseOrder order = JsonUtils.formJson(leaseOrder, LeaseOrder.class);
        crudService.save(order);
        return new AjaxResponse(true);
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
