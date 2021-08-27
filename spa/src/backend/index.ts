import type {
  Reply,
  AppState,
  Comment,
  Reaction,
  LoginResult,
  StripePaymentIntent,
  User,
  Post,
} from "../state";
import {
  loginSuccess,
  appState,
  reply,
  comment,
  reaction,
  stripePaymentIntent,
  post,
} from "./resources";
import { request, Response, HttpClient, ErrorHandlers } from "./http";
import { UnmatchedError } from "../exhaustive";
import * as log from "../log";

export type { Response };

export async function login(
  apiBase: string,
  email: string,
  password: string
): Promise<LoginResult> {
  let url = apiBase + "/v1/users/session";
  let result = await request([201], "POST", url, loginSuccess, {
    email,
    password,
  });
  switch (result.type) {
    case "Success":
      return result.resource;

    case "UnexpectedBody":
    case "NetworkError":
    case "ServerError":
      return {
        type: "error",
        errorMessage:
          "We're having trouble logging in right now. Please try again later",
      };

    case "AuthError":
    case "UnexpectedStatus":
      return { type: "error", errorMessage: "Unrecognised email or password" };

    default:
      throw new UnmatchedError(result);
  }
}

// An interface for the API client.
// Our components ask for this interface rather than the actual
// AuthenticatedApiClient class so that we can provide an inert mock
// client in tests.
export interface ApiClient {
  getInitialAppState(): Promise<Response<AppState>>;

  createComment(postId: number, content: string): Promise<Response<Comment>>;

  createReply(commentId: number, content: string): Promise<Response<Reply>>;

  createCommentReaction(
    commentId: number,
    relate: boolean,
    send_love: boolean
  ): Promise<Response<Reaction>>;

  createReplyReaction(
    replyId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Response<Reaction>>;

  reportComment(
    commentId: number,
    reporter_reason: string
  ): Promise<Response<null>>;

  reportReply(
    replyId: number,
    reporter_reason: string
  ): Promise<Response<null>>;

  getStripePaymentIntent(): Promise<Response<StripePaymentIntent>>;

  getPostState(postId: number, commentId: number): Promise<Response<Post>>;
}

// An implementation of ApiClient that actually connects to the backend.
// How handy!
export class AuthenticatedApiClient implements ApiClient {
  private httpClient: HttpClient;
  private apiBase: string;

  constructor(apiBase: string, apiToken: string, errorHandlers: ErrorHandlers) {
    this.httpClient = new HttpClient(apiToken, errorHandlers);
    this.apiBase = apiBase;
  }

  private route(path: string): string {
    return this.apiBase + path;
  }

  async getInitialAppState(): Promise<Response<AppState>> {
    let url = this.route("/v1/token/dashboard");
    return await this.httpClient.get(url).expect(200).request(appState);
  }

  async createComment(
    postId: number,
    content: string
  ): Promise<Response<Comment>> {
    let url = this.route(`/v1/token/posts/${postId}/comments`);
    return await this.httpClient
      .post(url)
      .expect(201)
      .body({ content })
      .request(comment);
  }

  async createReply(
    commentId: number,
    content: string
  ): Promise<Response<Reply>> {
    let url = this.route(`/v1/token/comments/${commentId}/replies`);
    return await this.httpClient
      .post(url)
      .expect(201)
      .body({ content })
      .request(reply);
  }

  async createCommentReaction(
    commentId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Response<Reaction>> {
    let url = this.route(`/v1/token/comments/${commentId}/reactions`);
    return await this.httpClient
      .patch(url)
      .expect(201)
      .body({ relate, send_love: sendLove })
      .request(reaction);
  }

  async createReplyReaction(
    replyId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Response<Reaction>> {
    let url = this.route(`/v1/token/replies/${replyId}/reactions`);
    return await this.httpClient
      .patch(url)
      .expect(201)
      .body({ relate, send_love: sendLove })
      .request(reaction);
  }

  async reportComment(
    commentId: number,
    reporter_reason: string
  ): Promise<Response<null>> {
    let url = this.route(`/v1/token/comments/${commentId}/reports`);
    return await this.httpClient
      .post(url)
      .expect(201)
      .body({ reporter_reason })
      .request((_) => null);
  }

  async reportReply(
    replyId: number,
    reporter_reason: string
  ): Promise<Response<null>> {
    let url = this.route(`/v1/token/replies/${replyId}/reports`);
    return await this.httpClient
      .post(url)
      .expect(201)
      .body({ reporter_reason })
      .request((_) => null);
  }

  async getStripePaymentIntent(): Promise<Response<StripePaymentIntent>> {
    let url = this.route(`/v1/token/stripe-payment-intent`);
    return await this.httpClient
      .post(url)
      .expect(201)
      .request(stripePaymentIntent);
  }

  async getPostState(postId: number, commentId: number): Promise<Response<Post>> {
    let url = this.route(`/v1/token/posts/${postId}/comments/${commentId}`)
    return await this.httpClient.get(url).expect(200).request(post);
  }
}

// A mock API client used in tests
export class MockApiClient implements ApiClient {
  getCsrfToken(): string {
    return "some-csrf-token";
  }
  getInitialAppState(): Promise<Response<AppState>> {
    throw new Error("Method not implemented.");
  }
  createComment(postId: number, content: string): Promise<Response<Comment>> {
    throw new Error("Method not implemented.");
  }
  createReply(commentId: number, content: string): Promise<Response<Reply>> {
    throw new Error("Method not implemented.");
  }
  createCommentReaction(
    commentId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Response<Reaction>> {
    throw new Error("Method not implemented.");
  }
  createReplyReaction(
    replyId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Response<Reaction>> {
    throw new Error("Method not implemented.");
  }
  reportComment(
    commentId: number,
    reporter_reason: string
  ): Promise<Response<null>> {
    throw new Error("Method not implemented.");
  }
  reportReply(
    replyId: number,
    reporter_reason: string
  ): Promise<Response<null>> {
    throw new Error("Method not implemented.");
  }
  getStripePaymentIntent(): Promise<Response<StripePaymentIntent>> {
    throw new Error("Method not implemented.");
  }
  getPostState(postId: number, commentId: number): Promise<Response<Post>> {
    throw new Error("Method not implemented.");
  }
}

