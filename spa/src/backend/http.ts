type Response = {
  status: number;
  body: unknown;
};

export function assertStatus(resp: Response, expected: number) {
  if (resp.status !== expected) {
    throw new Error(
      `Unexpected HTTP status ${resp.status}: ${JSON.stringify(resp.body)}`
    );
  }
}

// TODO: make apiToken required and expose the request function for
// unauthenticated requests
export class HttpClient {
  apiToken: undefined | string;

  constructor(apiToken: undefined | string) {
    this.apiToken = apiToken;
  }

  async request(method: string, url: string, body: null | object) {
    let headers: Record<string, string> = {
      "content-type": "application/json",
      accept: "application/json",
    };
    if (this.apiToken) {
      headers["authorization"] = "Bearer " + this.apiToken;
    }
    let resp = await fetch(url, {
      headers,
      method,
      body: body ? JSON.stringify(body) : body,
    });
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
