package com.github.quick4j.leasing.basic.goods.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.quick4j.core.entity.AbstractEntity;
import com.github.quick4j.core.entity.Entity;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * @author zhaojh.
 */
@javax.persistence.Entity
@Table(name = "basic_goods")
public class Goods extends AbstractEntity {
    @Id
    @Column(length = 32)
    private String id;

    @NotNull
    @Column(name = "goods_code", length = 100)
    private String code;

    @NotNull
    @Column(name = "goods_name", length = 500)
    private String name;

    @NotNull
    @Column(name = "goods_type", length = 100)
    private String type;

    @Column(name = "goods_spec", length = 100)
    private String spec;//规格型号

    @Column(name = "goods_unit", length = 100)
    private String unit;

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
        return name;
    }

    @Override
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getSpec() {
        return spec;
    }

    public void setSpec(String spec) {
        this.spec = spec;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }
}
