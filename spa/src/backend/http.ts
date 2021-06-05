import { deleteApiToken } from "../local-storage";
import { UnmatchedError } from "../exhaustive";

export type Response<Resource> = Success<Resource> | ErrorResponse;

export type ErrorResponse =
  | NetworkError
  | ServerError
  | AuthError
  | UnexpectedStatus
  | UnexpectedBody;

export type NetworkError = {
  type: "NetworkError";
  detail: string;
};

export type ServerError = {
  type: "ServerError";
  detail: string;
};

export type UnexpectedStatus = {
  type: "UnexpectedStatus";
  status: number;
  detail: string;
};

export type UnexpectedBody = {
  type: "UnexpectedBody";
  status: number;
  detail: string;
};

export type AuthError = {
  type: "AuthError";
  detail: string;
};

export type Success<Resource> = {
  type: "Success";
  status: number;
  resource: Resource;
};

export interface ErrorHandlers {
  authFailed: () => void;
  serverError: () => void;
  networkError: () => void;
  unexpectedBody: () => void;
  unexpectedStatus: () => void;
}

export class RequestBuilder {
  private _client: HttpClient;
  private _method: Method;
  private _body: undefined | object;
  private _url: string;
  private _expectedStatuses: Array<number>;

  constructor(client: HttpClient, method: Method, url: string) {
    this._client = client;
    this._url = url;
    this._method = method;
    this._body = undefined;
    this._expectedStatuses = [200];
  }

  body(body: object): RequestBuilder {
    this._body = body;
    return this;
  }

  expect(expectedStatuses: number | Array<number>): RequestBuilder {
    this._expectedStatuses = Array.isArray(expectedStatuses)
      ? expectedStatuses
      : [expectedStatuses];
    return this;
  }

  request<Resource>(
    decoder: (input: any) => Resource
  ): Promise<Response<Resource>> {
    return this._client.request(
      this._expectedStatuses,
      this._method,
      this._url,
      decoder,
      this._body
    );
  }
}

export type Method = "GET" | "POST" | "PATCH";

// A HTTP client that:
// - handles authentication with out API using an API token.
// - does some error handling by invoking callback functions when certain
//   generic errors occur.
export class HttpClient {
  apiToken: string;
  errorHandlers: ErrorHandlers;

  constructor(apiToken: string, handlers: ErrorHandlers) {
    this.apiToken = apiToken;
    this.errorHandlers = handlers;
  }

  get(url: string): RequestBuilder {
    return new RequestBuilder(this, "GET", url);
  }

  post(url: string): RequestBuilder {
    return new RequestBuilder(this, "POST", url);
  }

  patch(url: string): RequestBuilder {
    return new RequestBuilder(this, "PATCH", url);
  }

  async request<T>(
    expectedStatuses: Array<number>,
    method: string,
    url: string,
    decoder: (body: any) => T,
    jsonBody?: object
  ): Promise<Response<T>> {
    let response = await request(
      expectedStatuses,
      method,
      url,
      decoder,
      jsonBody,
      this.apiToken
    );
    switch (response.type) {
      case "Success":
        return response;

      case "NetworkError":
        this.errorHandlers.networkError();
        return response;

      case "AuthError":
        this.errorHandlers.authFailed();
        return response;

      case "ServerError":
        this.errorHandlers.serverError();
        return response;

      case "UnexpectedStatus":
        this.errorHandlers.unexpectedStatus();
        return response;

      case "UnexpectedBody":
        this.errorHandlers.unexpectedBody();
        return response;

      default:
        throw new UnmatchedError(response);
    }
  }
}

export async function request<T>(
  expectedStatuses: Array<number>,
  method: string,
  url: string,
  decoder: (body: any) => T,
  jsonBody?: object,
  apiToken?: string
): Promise<Response<T>> {
  let headers: Record<string, string> = {
    "content-type": "application/json",
    accept: "application/json",
  };
  if (apiToken) {
    headers["authorization"] = "Bearer " + apiToken;
  }
  let body = jsonBody ? JSON.stringify(jsonBody) : null;
  try {
    let resp = await fetch(url, { headers, method, body });
    return await handleResponse(resp, expectedStatuses, decoder);
  } catch (error) {
    return { type: "NetworkError", detail: error };
  }
}

async function handleResponse<T>(
  resp: globalThis.Response,
  expectedStatuses: Array<number>,
  decoder: (body: any) => T
): Promise<Response<T>> {
  if (resp.status >= 500) {
    return {
      type: "ServerError",
      detail: await resp.text(),
    };
  } else if (resp.status == 401) {
    return {
      type: "AuthError",
      detail: "Not authenticated",
    };
  } else if (expectedStatuses.includes(resp.status)) {
    return await decodeBody(resp, decoder);
  } else {
    return {
      type: "UnexpectedStatus",
      status: resp.status,
      detail: await resp.text(),
    };
  }
}

async function decodeBody<T>(
  resp: globalThis.Response,
  decoder: (body: any) => T
): Promise<Response<T>> {
  try {
    return {
      type: "Success",
      status: resp.status,
      resource: decoder(await resp.json()),
    };
  } catch (error) {
    return {
      type: "UnexpectedBody",
      status: resp.status,
      detail: error,
    };
  }
}
