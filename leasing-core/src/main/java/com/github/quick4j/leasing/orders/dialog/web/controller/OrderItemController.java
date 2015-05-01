package com.github.quick4j.leasing.orders.dialog.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author zhaojh.
 */
@Controller
@RequestMapping("/orders/items")
public class OrderItemController {
    private final String LOCATION = "orders/dialog/";

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String doShowAddGoodsDialog(){
        return LOCATION + "addGoods";
    }

    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String doShowEditGoodsDialog(){
        return LOCATION + "editGoods";
    }
}
