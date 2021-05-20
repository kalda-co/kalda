const API_TOKEN_STORAGE_KEY = "api-token";

export function saveApiToken(token: string): string {
  localStorage.setItem(API_TOKEN_STORAGE_KEY, token);
  return token;
}

export function deleteApiToken(): void {
  localStorage.removeItem(API_TOKEN_STORAGE_KEY);
}

export function loadApiToken(): string | undefined {
  return localStorage.getItem(API_TOKEN_STORAGE_KEY) || undefined;
}
