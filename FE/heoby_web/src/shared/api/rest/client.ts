import type { AxiosInstance } from "axios";
import axios from "axios";

// API Client 생성
const ApiClient: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || "http://localhost:8080/api",
  timeout: 15000,
  headers: {
    "Content-Type": "application/json",
  },
});

export default ApiClient;
