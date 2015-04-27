package com.github.quick4j.leasing.leaser.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.quick4j.core.entity.AbstractEntity;
import com.github.quick4j.core.entity.Entity;
import org.hibernate.validator.constraints.Length;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * @author zhaojh.
 */
@javax.persistence.Entity
@Table(name = "lease_leasers")
public class Leaser extends AbstractEntity {
    @Id
    @Column(length = 32)
    private String id;

    @NotNull
    @Length(min = 1, max = 4)
    @Column(name = "leaser_code", length = 100)
    private String code;

    @NotNull
    @Length(max = 1000)
    @Column(name = "leaser_name", length = 1000)
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
        return String.format("出租方|%s", getName());
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
