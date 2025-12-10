import type { Location } from "@/shared/types/location";
import typia from "typia";
import type { Heoby, HeobyList } from "../domain/heoby.domain";

export interface HeobyDto {
  scarecrow_uuid: string;
  name: string;
  location: Location;
  owner_name: string;
  status: string;
  updated_at: string;
  serial_number: string;
  temperature: number;
  humidity: number;
}

export interface HeobyListDto {
  my_scarecrows: HeobyDto[];
  village_scarecrows: HeobyDto[];
}

export const HeobyMapper = {
  assertHeobyRes: typia.createAssert<HeobyDto>(),

  fromDto: (dto: HeobyDto): Heoby => {
    return {
      uuid: dto.scarecrow_uuid,
      name: dto.name,
      location: dto.location,
      owner_name: dto.owner_name,
      status: dto.status,
      updated_at: dto.updated_at,
      temperature: dto.temperature,
      humidity: dto.humidity,
      camera: null,
      heatDetection: null,
      voice: null,
      battery: Math.floor(Math.random() * (100 - 30 + 1)) + 30,
      serial_number: dto.serial_number,
    };
  },
};

export const HeobyListMapper = {
  assertHeobyListRes: typia.createAssert<HeobyListDto>(),
  formDto: (dto: HeobyListDto): HeobyList => {
    return {
      my: dto.my_scarecrows.map((element) => HeobyMapper.fromDto(element)),
      other: dto.village_scarecrows.map((element) =>
        HeobyMapper.fromDto(element)
      ),
    };
  },
};
