export type Response = {
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

export class HttpClient {
  apiToken: string;

  constructor(apiToken: string) {
    this.apiToken = apiToken;
  }

  async get(url: string): Promise<Response> {
    return this.request("GET", url);
  }

  async post(url: string, body: object): Promise<Response> {
    return this.request("POST", url, body);
  }

  async patch(url: string, body: object): Promise<Response> {
    return this.request("PATCH", url, body);
  }

  async request(
    method: string,
    url: string,
    jsonBody?: object
  ): Promise<Response> {
    return request(method, url, jsonBody, this.apiToken);
  }
}

export async function request(
  method: string,
  url: string,
  jsonBody?: object,
  apiToken?: string
): Promise<Response> {
  let headers: Record<string, string> = {
    "content-type": "application/json",
    accept: "application/json",
  };
  if (apiToken) {
    headers["authorization"] = "Bearer " + apiToken;
  }
  let body = jsonBody ? JSON.stringify(jsonBody) : null;
  let resp = await fetch(url, { headers, method, body, mode: "cors" });
  if (resp.status >= 500) {
    let body = await resp.text();
    throw new Error(`Internal server error ${resp.status} ${body}`);
  }
  return {
    status: resp.status,
    body: await resp.json(),
  };
}
