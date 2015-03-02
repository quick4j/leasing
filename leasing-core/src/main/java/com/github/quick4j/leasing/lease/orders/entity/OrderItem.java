package com.github.quick4j.leasing.lease.orders.entity;

import com.github.quick4j.core.entity.AbstractEntity;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

/**
 * @author zhaojh.
 */
@MappedSuperclass
public abstract class OrderItem extends AbstractEntity{
    @NotNull
    @Column(name = "order_id", length = 32, nullable = false)
    private String orderId;

    @NotNull
    @Column(name = "goods_id", length = 32, nullable = false)
    private String goodsId;

    @NotNull
    @Column(name = "goods_name", length = 500)
    private String goodsName;

    @Column(name = "goods_spec", length = 100)
    private String goodsSpec;

    @Column(name = "goods_location")
    private String goodsLocation;

    @Column(name = "packages")
    private int packages;

    @Column(name = "numbers", precision = 10, scale = 2)
    private BigDecimal numbers;

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(String goodsId) {
        this.goodsId = goodsId;
    }

    public String getGoodsName() {
        return goodsName;
    }

    public void setGoodsName(String goodsName) {
        this.goodsName = goodsName;
    }

    public String getGoodsSpec() {
        return goodsSpec;
    }

    public void setGoodsSpec(String goodsSpec) {
        this.goodsSpec = goodsSpec;
    }

    public String getGoodsLocation() {
        return goodsLocation;
    }

    public void setGoodsLocation(String goodsLocation) {
        this.goodsLocation = goodsLocation;
    }

    public int getPackages() {
        return packages;
    }

    public void setPackages(int packages) {
        this.packages = packages;
    }

    public BigDecimal getNumbers() {
        return numbers;
    }

    public void setNumbers(BigDecimal numbers) {
        this.numbers = numbers;
    }

    @Override
    public void setMasterId(String masterId) {
        this.orderId = masterId;
    }
}
