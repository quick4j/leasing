package com.github.quick4j.leasing.lease.orders.entity;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.github.quick4j.core.entity.AbstractEntity;
import com.github.quick4j.leasing.lease.orders.OrderType;

import javax.persistence.Column;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.MappedSuperclass;

/**
 * @author zhaojh.
 */
@MappedSuperclass
public abstract class OrderHeader extends AbstractEntity{
    @Column(name = "code", length = 100)
    private String code;

    @JsonDeserialize(using = OpenTimeDeserializer.class)
    @Column(name = "open_time")
    private long openTime;

    @Enumerated(EnumType.STRING)
    @Column(name = "order_type", length = 100, nullable = false)
    private OrderType type;

    @Column(name = "transactor_id", length = 32)
    private String transactorId;

    @Column(name = "transactor", length = 200)
    private String transactor;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public long getOpenTime() {
        return openTime;
    }

    public void setOpenTime(long openTime) {
        this.openTime = openTime;
    }

    public OrderType getType() {
        return type;
    }

    public void setType(OrderType type) {
        this.type = type;
    }

    public String getTransactor() {
        return transactor;
    }

    public void setTransactor(String transactor) {
        this.transactor = transactor;
    }

    public String getTransactorId() {
        return transactorId;
    }

    public void setTransactorId(String transactorId) {
        this.transactorId = transactorId;
    }
}
