import axios from "axios";

import { API_URL } from "@/lib/env";
import useLoaderStore from "@/store/loader-store";

const apiClient = axios.create({
  baseURL: API_URL,
});

function getToken() {
  if (typeof window === "undefined") return null;
  return localStorage.getItem("token");
}

apiClient.interceptors.request.use(
  (config) => {
    const token = getToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    useLoaderStore.getState().showLoader();
    return config;
  },
  (error) => {
    useLoaderStore.getState().hideLoader();
    return Promise.reject(error);
  },
);

apiClient.interceptors.response.use(
  (response) => {
    useLoaderStore.getState().hideLoader();
    return response;
  },
  (error) => {
    useLoaderStore.getState().hideLoader();
    return Promise.reject(error);
  },
);

export const resolveApiError = (error: unknown) => {
  if (!axios.isAxiosError(error)) return { message: "Bilinmeyen bir hata oluştu." };

  if (!error.response) return { message: "Sunucuya ulaşılamıyor." };

  const data = error.response.data as {
    message: string | string[];
    error: string;
    statusCode: number;
  };

  if (data.statusCode === 500) {
    return { message: "Sunucu hatası oluştu." };
  }

  return {
    message: Array.isArray(data.message) ? data.message.join(", ") : data.message,
    error: data.error,
  };
};

export default Object.assign(apiClient, {
  resolveApiError,
});
