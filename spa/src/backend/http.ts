type Response = {
  status: number;
  body: unknown;
};

export function assertStatus(resp: Response, expected: number) {
  if (resp.status !== expected) {
    throw new Error(`Unexpected HTTP status ${resp.status}: ${resp.body}`);
  }
}

export class HttpClient {
  csrfToken: string;

  constructor(csrfToken: string) {
    this.csrfToken = csrfToken;
  }

  async request(method: string, url: string, body: null | object) {
    let request = {
      headers: {
        "content-type": "application/json",
        "x-csrf-token": this.csrfToken,
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

  async get(url: string) {
    return this.request("GET", url, null);
  }

  async post(url: string, body: object) {
    return this.request("POST", url, body);
  }

  async patch(url: string, body: object) {
    return this.request("PATCH", url, body);
  }
}
