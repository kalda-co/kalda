import type { Reply, AppState, Comment, Reaction, LoginResult } from "../state";
import { loginSuccess, appState, reply, comment, reaction } from "./resources";
import { assertStatus, HttpClient } from "./http";

export async function login(
  email: string,
  password: string
): Promise<LoginResult> {
  let http = new HttpClient(undefined);
  let resp = await http.post("/v1/users/session", { email, password });
  if (resp.status === 201) {
    return loginSuccess(resp.body);
  } else {
    return { type: "error", errorMessage: "Unrecognised email or password" };
  }
}

// An interface for the API client.
// Our components ask for this interface rather than the actual
// AuthenticatedApiClient class so that we can provide an inert mock
// client in tests.
export interface ApiClient {
  getInitialAppState(): Promise<AppState>;

  createComment(postId: number, content: string): Promise<Comment>;

  createReply(commentId: number, content: string): Promise<Reply>;

  createCommentReaction(
    commentId: number,
    relate: boolean,
    send_love: boolean
  ): Promise<Reaction>;

  createReplyReaction(
    replyId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Reaction>;

  reportComment(commentId: number, reporter_reason: string): Promise<void>;

  reportReply(replyId: number, reporter_reason: string): Promise<void>;
}

// An implementation of ApiClient that actually connects to the backend.
// How handy!
export class AuthenticatedApiClient implements ApiClient {
  httpClient: HttpClient;

  constructor(apiToken: string | undefined) {
    this.httpClient = new HttpClient(apiToken);
  }

  async getInitialAppState(): Promise<AppState> {
    let resp = await this.httpClient.get("/v1/token/dashboard");
    assertStatus(resp, 200);
    return appState(resp.body);
  }

  async createComment(postId: number, content: string): Promise<Comment> {
    let url = `/v1/token/posts/${postId}/comments`;
    let resp = await this.httpClient.post(url, { content });
    assertStatus(resp, 201);
    return comment(resp.body);
  }

  async createReply(commentId: number, content: string): Promise<Reply> {
    let url = `/v1/token/comments/${commentId}/replies`;
    let resp = await this.httpClient.post(url, { content });
    assertStatus(resp, 201);
    return reply(resp.body);
  }

  async createCommentReaction(
    commentId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Reaction> {
    let url = `/v1/token/comments/${commentId}/reactions`;
    let resp = await this.httpClient.patch(url, {
      relate,
      send_love: sendLove,
    });
    assertStatus(resp, 201);
    return reaction(resp.body);
  }

  async createReplyReaction(
    replyId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Reaction> {
    let url = `/v1/token/replies/${replyId}/reactions`;
    let resp = await this.httpClient.patch(url, {
      relate,
      send_love: sendLove,
    });
    assertStatus(resp, 201);
    return reaction(resp.body);
  }

  async reportComment(
    commentId: number,
    reporter_reason: string
  ): Promise<void> {
    let url = `/v1/token/comments/${commentId}/reports`;
    let resp = await this.httpClient.post(url, { reporter_reason });
    assertStatus(resp, 201);
  }

  async reportReply(replyId: number, reporter_reason: string): Promise<void> {
    let url = `/v1/token/replies/${replyId}/reports`;
    let resp = await this.httpClient.post(url, { reporter_reason });
    assertStatus(resp, 201);
  }
}

// A mock API client used in tests
export class MockApiClient implements ApiClient {
  getCsrfToken(): string {
    return "some-csrf-token";
  }
  getInitialAppState(): Promise<AppState> {
    throw new Error("Method not implemented.");
  }
  createComment(postId: number, content: string): Promise<Comment> {
    throw new Error("Method not implemented.");
  }
  createReply(commentId: number, content: string): Promise<Reply> {
    throw new Error("Method not implemented.");
  }
  createCommentReaction(
    commentId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Reaction> {
    throw new Error("Method not implemented.");
  }
  createReplyReaction(
    replyId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Reaction> {
    throw new Error("Method not implemented.");
  }
  reportComment(commentId: number, reporter_reason: string): Promise<void> {
    throw new Error("Method not implemented.");
  }
  reportReply(replyId: number, reporter_reason: string): Promise<void> {
    throw new Error("Method not implemented.");
  }
}
