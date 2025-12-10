import typia from "typia";

export interface Location {
  lat: number;
  lon: number;
}

export const assertLocation = typia.createAssert<Location>();
