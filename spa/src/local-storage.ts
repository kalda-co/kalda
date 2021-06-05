import { Storage } from "@capacitor/storage";

const API_TOKEN_STORAGE_KEY = "api-token";

export async function saveApiToken(token: string): Promise<string> {
  await Storage.set({ key: API_TOKEN_STORAGE_KEY, value: token });
  return token;
}

export async function deleteApiToken(): Promise<void> {
  await Storage.remove({ key: API_TOKEN_STORAGE_KEY });
}

export async function loadApiToken(): Promise<string | undefined> {
  let result = await Storage.get({ key: API_TOKEN_STORAGE_KEY });
  return result.value || undefined;
}
