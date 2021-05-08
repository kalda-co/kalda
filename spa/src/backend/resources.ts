import {
  field,
  number,
  string,
  array,
  date,
  optional,
  boolean,
} from "./decode";
import type {
  User,
  Post,
  Reply,
  AppState,
  Comment,
  Therapy,
  Reaction,
} from "../state";

export function appState(json: unknown): AppState {
  return {
    currentUser: field("current_user", user)(json),
    reflections: field("reflections", array(post))(json),
    pools: field("pools", array(post))(json),
    next_therapy: field("next_therapy", optional(therapy))(json),
    therapies: field("therapies", array(therapy))(json),
  };
}

export function therapy(json: unknown): Therapy {
  return {
    id: field("id", number)(json),
    link: field("link", string)(json),
    startsAt: field("starts_at", date)(json),
    title: field("title", string)(json),
    description: field("description", string)(json),
    therapist: field("therapist", string)(json),
    credentials: field("credentials", string)(json),
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
    reactions: field("reactions", array(reaction))(json),
  };
}

export function reply(json: unknown): Reply {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", user)(json),
    reactions: field("reactions", array(reaction))(json),
  };
}

export function user(json: unknown): User {
  return {
    id: field("id", number)(json),
    username: field("username", string)(json),
  };
}

export function reaction(json: unknown): Reaction {
  return {
    author: field("author", user)(json),
    relate: field("relate", boolean)(json),
    sendLove: field("send_love", boolean)(json),
  };
}
