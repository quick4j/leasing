package com.github.quick4j.leasing.orders.relet.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.github.quick4j.core.entity.Entity;
import com.github.quick4j.leasing.orders.entity.OrderItem;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.List;

/**
 * @author zhaojh.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@javax.persistence.Entity
@Table(name = "lease_relet_order_items")
public class ReletOrderItem extends OrderItem {
    @Id
    @Column(length = 32)
    private String id;

    @Override
    public void setId(String id) {
        this.id = id;
    }

    @Override
    public String getId() {
        return id;
    }

    @Override
    @JsonIgnore
    public List<? extends Entity> getSlave() {
        return null;
    }

    @Override
    @JsonIgnore
    public String getChineseName() {
        return getName();
    }

    @Override
    public String getName() {
        return String.format("转租单条目|%s|%s", getOrderId(), getGoodsName());
    }
}
