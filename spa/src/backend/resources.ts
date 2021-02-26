import { field, number, string, array, date, optional } from "./decode";
import type { User, Post, Reply, AppState, Comment, Therapy } from "../state";

export function appState(json: unknown): AppState {
  return {
    currentUser: field("current_user", user)(json),
    reflections: field("reflections", array(post))(json),
    pools: field("pools", array(post))(json),
    currentPage: "dashboard",
    therapy: field("therapy", optional(therapy))(json),
  };
}

export function therapy(json: unknown): Therapy {
  return {
    id: field("id", number)(json),
    link: field("link", string)(json),
    event_datetime: field("event_datetime", date)(json),
  };
}

export function post(json: unknown): Post {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", user)(json),
    comments: field("comments", array(comment))(json),
  };
}

export function comment(json: unknown): Comment {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", user)(json),
    replies: field("replies", array(reply))(json),
  };
}

export function reply(json: unknown): Reply {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", user)(json),
  };
}

export function user(json: unknown): User {
  return {
    id: field("id", number)(json),
    username: field("username", string)(json),
  };
}
