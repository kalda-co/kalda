let CSRFToken = "";

export function setCSRFToken(token: string) {
  CSRFToken = token;
}

export function getCSRFToken() {
  return CSRFToken;
}

type Response = {
  status: number;
  body: unknown;
};

export function assertStatus(resp: Response, expected: number) {
  if (resp.status !== expected) {
    throw new Error(`Unexpected HTTP status ${resp.status}: ${resp.body}`);
  }
}

async function httpRequest(method: string, url: string, body: null | object) {
  let request = {
    headers: {
      "content-type": "application/json",
      "x-csrf-token": CSRFToken,
      accept: "application/json",
    },
    method,
    body: body ? JSON.stringify(body) : body,
  };
  let resp = await fetch(url, request);
  if (resp.status >= 500) {
    let body = await resp.text();
    throw new Error(`Internal server error ${resp.status} ${body}`);
  }
  return {
    status: resp.status,
    body: await resp.json(),
  };
}

export async function httpGet(url: string) {
  return httpRequest("GET", url, null);
}

export async function httpPost(url: string, body: object) {
  return httpRequest("POST", url, body);
}

export async function httpPatch(url: string, body: object) {
  return httpRequest("PATCH", url, body);
}
