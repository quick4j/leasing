package com.github.quick4j.leasing.lease.relet.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.quick4j.core.entity.Entity;
import com.github.quick4j.leasing.lease.orders.entity.OrderHeader;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * @author zhaojh.
 */
@javax.persistence.Entity
@Table(name = "lease_relet_orders")
public class ReletOrder extends OrderHeader {
    @Id
    @Column(length = 32)
    private String id;

    @NotNull
    @Column(name = "holder_id",length = 32, nullable = false)
    private String holderId;

    @Column(name = "hoder_name", length = 1000)
    private String holderName;

    @NotNull
    @Column(name = "project_id", length = 32, nullable = false)
    private String projectId;

    @Column(name = "project_name", length = 1000)
    private String projectName;

    @NotNull
    @Column(name = "leaser_id", length = 32)
    private String leaserId;

    @Column(name = "leaser_name", length = 1000)
    private String leaserName;

    @OneToMany
    @JoinColumn(name = "order_id")
    private List<ReletOrderItem> items;

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
        return items;
    }

    @Override
    @JsonIgnore
    public String getChineseName() {
        return getName();
    }

    @Override
    public String getName() {
        return String.format("转租单|%s", getCode());
    }

    public String getHolderId() {
        return holderId;
    }

    public void setHolderId(String holderId) {
        this.holderId = holderId;
    }

    public String getHolderName() {
        return holderName;
    }

    public void setHolderName(String holderName) {
        this.holderName = holderName;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getLeaserId() {
        return leaserId;
    }

    public void setLeaserId(String leaserId) {
        this.leaserId = leaserId;
    }

    public String getLeaserName() {
        return leaserName;
    }

    public void setLeaserName(String leaserName) {
        this.leaserName = leaserName;
    }

    public List<ReletOrderItem> getItems() {
        return items;
    }

    public void setItems(List<ReletOrderItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "ReletOrder{" +
                "id='" + id + '\'' +
                ", code='" + getCode() + '\'' +
                ", holderId='" + holderId + '\'' +
                ", holderName='" + holderName + '\'' +
                ", projectId='" + projectId + '\'' +
                ", projectName='" + projectName + '\'' +
                ", leaserId='" + leaserId + '\'' +
                ", leaserName='" + leaserName + '\'' +
                ", items=" + items +
                '}';
    }
}
