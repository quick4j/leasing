package com.github.quick4j.leasing.lease.orders.entity;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 * @author zhaojh.
 */
public class OpenTimeDeserializer extends JsonDeserializer<Long> {
    @Override
    public Long deserialize(JsonParser jp, DeserializationContext ctxt)
            throws IOException, JsonProcessingException {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String value = jp.getValueAsString();
        try {
            return dateFormat.parse(value).getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return null;
    }
}
