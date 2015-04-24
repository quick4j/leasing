package com.github.quick4j.leasing.leaseholder.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.quick4j.core.entity.AbstractEntity;
import com.github.quick4j.core.entity.Entity;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * @author zhaojh.
 */
@javax.persistence.Entity
@Table(name = "lease_holders")
public class LeaseHoder extends AbstractEntity {
    @Id
    @Column(length = 32)
    private String id;

    @NotNull
    @NotEmpty
    @Length(max = 50)
    @Column(name = "holder_code", length = 100)
    private String code;

    @NotNull
    @NotEmpty
    @Length(max = 1000)
    @Column(name = "holder_name", length = 1000)
    private String name;


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
