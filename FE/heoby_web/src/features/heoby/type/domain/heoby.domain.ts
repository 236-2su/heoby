import type { Location } from "@/shared/types/location";

export interface HeobyList {
  my: Heoby[];
  other: Heoby[];
}
export interface Heoby {
  uuid: string;
  name: string;
  location: Location;
  owner_name: string;
  status: string;
  updated_at: string;
  temperature: number | null;
  humidity: number | null;
  camera: boolean | null;
  heatDetection: boolean | null;
  voice: boolean | null;
  battery: number | null;
  serial_number: string | null;
}
