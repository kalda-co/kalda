import type { Reply, AppState, Comment, Reaction } from "../state";
import { appState, reply, comment, reaction } from "./resources";
import {
  assertStatus,
  httpGet,
  httpPost,
  httpPatch,
  getCSRFToken,
  setCSRFToken,
} from "./http";

export { getCSRFToken, setCSRFToken };

export async function getInitialAppState(): Promise<AppState> {
  let resp = await httpGet("/v1/dashboard");
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

export async function createCommentReaction(
  commentId: number,
  relate: boolean,
  send_love: boolean
): Promise<Reaction> {
  let url = `/v1/comments/${commentId}/reactions`;
  let resp = await httpPatch(url, { relate, send_love });
  assertStatus(resp, 201);
  return reaction(resp.body);
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
