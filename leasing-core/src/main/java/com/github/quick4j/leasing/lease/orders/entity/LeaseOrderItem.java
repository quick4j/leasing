package com.github.quick4j.leasing.lease.orders.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.github.quick4j.core.entity.AbstractEntity;
import com.github.quick4j.core.entity.Entity;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

/**
 * @author zhaojh.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@javax.persistence.Entity
@Table(name = "lease_order_items")
public class LeaseOrderItem extends OrderItem {
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

    @JsonIgnore
    @Override
    public List<? extends Entity> getSlave() {
        return null;
    }

    @JsonIgnore
    @Override
    public String getChineseName() {
        return getName();
    }

    @Override
    public String getName() {
        return String.format("租赁单条目|%s|%s", getOrderId(), getGoodsName());
    }

    @Override
    public String toString() {
        return "LeaseOrderItem{" +
                "id='" + id + '\'' +
                "orderId='" + getOrderId() + '\'' +
                "goodsName='" + getGoodsName() + '\'' +
                "goodsSpec='" + getGoodsSpec() + '\'' +
                "packages='" + getPackages() + '\'' +
                "numbers='" + getNumbers() + '\'' +
                '}';
    }
}
