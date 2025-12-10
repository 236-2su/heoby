import typia from "typia";
import type { Cctv, CctvStatus } from "../domain/cctv.domain";

export interface CctvListItemDto {
  id: number;
  name: string;
  location: string;
  status: CctvStatus;
  lastUpdate: string;
}

export interface CctvListResDto {
  cctvs: CctvListItemDto[];
}

export interface CctvDetailResDto extends CctvListItemDto {
  streamUrl?: string;
}

export interface TotalWorkersDto {
  workers: number;
}
export const assertCctvListResDto = typia.createAssert<CctvListResDto>();
export const assertCctvDetailResDto = typia.createAssert<CctvDetailResDto>();

export function cctvDtoToDomain(dto: CctvDetailResDto): Cctv {
  return {
    id: dto.id,
    name: dto.name,
    location: dto.location,
    status: dto.status,
    lastUpdate: dto.lastUpdate,
  };
}

export function cctvListDtoToDomain(dto: CctvListResDto): Cctv[] {
  return dto.cctvs.map((cctv) => ({
    id: cctv.id,
    name: cctv.name,
    location: cctv.location,
    status: cctv.status,
    lastUpdate: cctv.lastUpdate,
  }));
}
