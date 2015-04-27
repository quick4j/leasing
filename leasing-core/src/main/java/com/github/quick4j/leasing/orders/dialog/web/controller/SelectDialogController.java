package com.github.quick4j.leasing.orders.dialog.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author zhaojh.
 */
@Controller
@RequestMapping("/orders/common/dialog")
public class SelectDialogController {
    private final String LOCATION = "orders/dialog/";

    @RequestMapping(value = "/projects", method = RequestMethod.GET)
    public String doShowSelectProjectDialog(){
        return LOCATION + "selectProject";
    }

    @RequestMapping(value = "/goods", method = RequestMethod.GET)
    public String doShowSelectGoodsDialog(){
        return LOCATION + "selectGoods";
    }

    @RequestMapping(value = "/holders", method = RequestMethod.GET)
    public String doShowSelectHoldersDialog(){
        return LOCATION + "selectHolder";
    }

    @RequestMapping(value = "/leasers", method = RequestMethod.GET)
    public String doShowSelectLeasersDialog(){
        return LOCATION + "selectLeaser";
    }
}
