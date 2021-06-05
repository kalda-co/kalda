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
  // Check for a token in the previously used volatile storage, migrating it to
  // the cross platform durable storage if it exists
  let localToken = localStorage.getItem(API_TOKEN_STORAGE_KEY);
  if (localToken) {
    localStorage.removeItem(API_TOKEN_STORAGE_KEY);
    saveApiToken(localToken);
    return localToken;
  }
  // Otherwise, read from the durable cross platform storage
  let result = await Storage.get({ key: API_TOKEN_STORAGE_KEY });
  return result.value || undefined;
}
