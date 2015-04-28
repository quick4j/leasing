package com.github.quick4j.leasing.summary.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.quick4j.core.entity.AbstractEntity;
import com.github.quick4j.core.entity.Entity;

import java.math.BigDecimal;
import java.util.List;

/**
 * @author zhaojh.
 */
public class SummaryResult extends AbstractEntity {
    private String goodsName;
    private String goodsSpec;
    private String packages;
    private BigDecimal numbers;

    @Override
    public void setId(String s) {}

    @Override
    @JsonIgnore
    public String getId() {
        return null;
    }

    @Override
    @JsonIgnore
    public List<? extends Entity> getSlave() {
        return null;
    }

    @Override
    @JsonIgnore
    public String getChineseName() {
        return null;
    }

    @Override
    @JsonIgnore
    public String getName() {
        return null;
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

    public BigDecimal getNumbers() {
        return numbers;
    }

    public void setNumbers(BigDecimal numbers) {
        this.numbers = numbers;
    }

    public String getPackages() {
        return packages;
    }

    public void setPackages(String packages) {
        this.packages = packages;
    }
}
