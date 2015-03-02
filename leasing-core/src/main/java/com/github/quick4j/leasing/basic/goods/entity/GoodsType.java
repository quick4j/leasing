package com.github.quick4j.leasing.basic.goods.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.quick4j.core.entity.AbstractEntity;
import com.github.quick4j.core.entity.Entity;
import org.hibernate.validator.constraints.Length;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.List;

/**
 * @author zhaojh.
 */
@javax.persistence.Entity
@Table(name = "basic_goods_type")
public class GoodsType extends AbstractEntity {
    @Id
    @Column(length = 32)
    private String id;

    @NotNull
    @Size(min = 3, max = 4)
    @Column(name = "gc_code", length = 100, nullable = false)
    private String code;

    @NotNull
    @Length(min = 1)
    @Column(name = "gc_name", length = 500, nullable = false)
    private String name;

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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setName(String name) {
        this.name = name;
    }
}
