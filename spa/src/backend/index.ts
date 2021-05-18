import type { Reply, AppState, Comment, Reaction } from "../state";
import { appState, reply, comment, reaction } from "./resources";
import { assertStatus, HttpClient } from "./http";

type LoginSuccess = { type: "ok"; csrfToken: string };
type LoginError = { type: "error"; errorMessage: string };
type LoginResult = LoginSuccess | LoginError;

export async function login(
  email: string,
  password: string
): Promise<LoginResult> {
  // TODO: Real implementation
  console.log("email is", email, "password is", password);
  return { type: "ok", csrfToken: "some-token" };
}

// An interface for the API client.
// Our components ask for this interface rather than the actual
// AuthenticatedApiClient class so that we can provide an inert mock
// client in tests.
export interface ApiClient {
  getCsrfToken(): string;

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

  constructor(csrfToken: string) {
    this.httpClient = new HttpClient(csrfToken);
  }

  getCsrfToken(): string {
    return this.httpClient.csrfToken;
  }

  async getInitialAppState(): Promise<AppState> {
    let resp = await this.httpClient.get("/v1/dashboard");
    assertStatus(resp, 200);
    return appState(resp.body);
  }

  async createComment(postId: number, content: string): Promise<Comment> {
    let url = `/v1/posts/${postId}/comments`;
    let resp = await this.httpClient.post(url, { content });
    assertStatus(resp, 201);
    return comment(resp.body);
  }

  async createReply(commentId: number, content: string): Promise<Reply> {
    let url = `/v1/comments/${commentId}/replies`;
    let resp = await this.httpClient.post(url, { content });
    assertStatus(resp, 201);
    return reply(resp.body);
  }

  async createCommentReaction(
    commentId: number,
    relate: boolean,
    sendLove: boolean
  ): Promise<Reaction> {
    let url = `/v1/comments/${commentId}/reactions`;
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
    let url = `/v1/replies/${replyId}/reactions`;
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
    let url = `/v1/comments/${commentId}/reports`;
    let resp = await this.httpClient.post(url, { reporter_reason });
    assertStatus(resp, 201);
  }

  async reportReply(replyId: number, reporter_reason: string): Promise<void> {
    let url = `/v1/replies/${replyId}/reports`;
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
