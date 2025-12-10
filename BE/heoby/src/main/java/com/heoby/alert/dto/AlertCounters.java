package com.heoby.alert.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record AlertCounters(
    @JsonProperty("critical_unread") long criticalUnread,
    @JsonProperty("warning_unread") long warningUnread,
    @JsonProperty("total_unread") long totalUnread
) {}
