package com.heoby.scarecrow.dto;

import java.util.UUID;

public record ScarecrowResponse(UUID id, String name, int workerCount) {
}
