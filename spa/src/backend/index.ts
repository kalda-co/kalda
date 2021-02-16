import type {
  User,
  Post,
  Reply,
  ReportComment,
  AppState,
  Comment,
} from "../state";
import { field, number, string, array } from "./decode";

let CSRFToken = "";

export function setCSRFToken(token: string) {
  CSRFToken = token;
}

type Response = {
  status: number;
  body: unknown;
};

function assertStatus(resp: Response, expected: number) {
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

async function httpGet(url: string) {
  return httpRequest("GET", url, null);
}

async function httpPost(url: string, body: object) {
  return httpRequest("POST", url, body);
}

export async function getInitialAppState(): Promise<AppState> {
  let resp = await httpGet("/v1/daily-reflections");
  assertStatus(resp, 200);
  return appState(resp.body);
}

export async function createComment(
  postId: number,
  content: string
): Promise<Comment> {
  let url = `/v1/posts/${postId}/comments`;
  let resp = await httpPost(url, { content });
  assertStatus(resp, 201);
  return comment(resp.body);
}

export async function createReply(
  commentId: number,
  content: string
): Promise<Reply> {
  let url = `/v1/comments/${commentId}/replies`;
  let resp = await httpPost(url, { content });
  assertStatus(resp, 201);
  return reply(resp.body);
}

export async function reportComment(
  commentId: number,
  reporter_reason: string
): Promise<void> {
  let url = `/v1/comments/${commentId}/reports`;
  let resp = await httpPost(url, { reporter_reason });
  assertStatus(resp, 201);
}

export async function reportReply(
  replyId: number,
  reporter_reason: string
): Promise<void> {
  let url = `/v1/replies/${replyId}/reports`;
  let resp = await httpPost(url, { reporter_reason });
  assertStatus(resp, 201);
}

function appState(json: unknown): AppState {
  return {
    currentUser: field("current_user", user)(json),
    posts: field("posts", array(post))(json),
  };
}

function post(json: unknown): Post {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", user)(json),
    comments: field("comments", array(comment))(json),
  };
}

function comment(json: unknown): Comment {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", user)(json),
    replies: field("replies", array(reply))(json),
  };
}

function reply(json: unknown): Reply {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", user)(json),
  };
}

function user(json: unknown): User {
  return {
    id: field("id", number)(json),
    username: field("username", string)(json),
  };
}
