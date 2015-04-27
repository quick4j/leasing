package com.github.quick4j.leasing.orders.leasing.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.quick4j.core.entity.Entity;
import com.github.quick4j.leasing.orders.entity.OrderHeader;
import org.hibernate.validator.constraints.NotEmpty;

import javax.persistence.*;
import java.util.List;

/**
 * @author zhaojh.
 */
@javax.persistence.Entity
@Table(name = "lease_orders")
public class LeaseOrder extends OrderHeader {
    @Id
    @Column(length = 32)
    private String id;

    @NotEmpty
    @Column(name = "holder_id",length = 32, nullable = false)
    private String holderId;

    @Column(name = "hoder_name", length = 1000)
    private String holderName;

    @NotEmpty
    @Column(name = "project_id", length = 32, nullable = false)
    private String projectId;

    @Column(name = "project_name", length = 1000)
    private String projectName;

    @Column(name = "car_number", length = 20)
    private String carNumber;

    @Column(name = "carrier", length = 200)
    private String carrier;

    @OneToMany
    @JoinColumn(name = "order_id")
    private List<LeaseOrderItem> items;

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
        return items;
    }

    @JsonIgnore
    @Override
    public String getChineseName() {
        return getName();
    }

    @Override
    public String getName() {
        return String.format("租赁单|%s", getCode());
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

    public String getCarNumber() {
        return carNumber;
    }

    public void setCarNumber(String carNumber) {
        this.carNumber = carNumber;
    }

    public String getCarrier() {
        return carrier;
    }

    public void setCarrier(String carrier) {
        this.carrier = carrier;
    }

    public List<LeaseOrderItem> getItems() {
        return items;
    }

    public void setItems(List<LeaseOrderItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "LeaseOrder{" +
                "id='" + id + '\'' +
                ", code='" + getCode() + '\'' +
                ", holderId='" + holderId + '\'' +
                ", holderName='" + holderName + '\'' +
                ", projectId='" + projectId + '\'' +
                ", projectName='" + projectName + '\'' +
                ", carNumber='" + carNumber + '\'' +
                ", carrier='" + carrier + '\'' +
                ", items=" + items +
                '}';
    }
}
