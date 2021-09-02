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
  Author,
  User,
  Post,
  Reply,
  AppState,
  PostState,
  Comment,
  Therapy,
  Reaction,
  LoginSuccess,
  StripePaymentIntent,
  CommentNotification,
} from "../state";

export function appState(json: unknown): AppState {
  return {
    currentUser: field("current_user", user)(json),
    reflections: field("reflections", array(post))(json),
    pools: field("pools", array(post))(json),
    nextTherapy: field("next_therapy", optional(therapy))(json),
    therapies: field("therapies", array(therapy))(json),
    commentNotifications: field(
      "comment_notifications",
      array(commentNotification)
    )(json),
  };
}

export function postState(json: unknown): PostState {
  return {
    post: field("post", post)(json),
  }
}

export function therapy(json: unknown): Therapy {
  return {
    id: field("id", number)(json),
    link: field("link", optional(string))(json),
    startsAt: field("starts_at", date)(json),
    title: field("title", string)(json),
    description: field("description", string)(json),
    therapist: field("therapist", string)(json),
    credentials: field("credentials", string)(json),
  };
}

export function commentNotification(json: unknown): CommentNotification {
  return {
    notificationId: field("notification_id", number)(json),
    parentPostId: field("parent_post_id", number)(json),
    commentContent: field("comment_content", string)(json),
    commentId: field("comment_id", number)(json),
    insertedAt: field("inserted_at", date)(json),
    replyId: field("notification_reply_id", number)(json),
    replyAuthor: field("reply_author", author)(json),
    replyContent: field("reply_content", string)(json),
  };
}
export function post(json: unknown): Post {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", author)(json),
    comments: field("comments", array(comment))(json),
  };
}

export function comment(json: unknown): Comment {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", author)(json),
    replies: field("replies", array(reply))(json),
    reactions: field("reactions", array(reaction))(json),
  };
}

export function reply(json: unknown): Reply {
  return {
    id: field("id", number)(json),
    content: field("content", string)(json),
    author: field("author", author)(json),
    reactions: field("reactions", array(reaction))(json),
  };
}

export function user(json: unknown): User {
  return {
    id: field("id", number)(json),
    username: field("username", string)(json),
    hasSubscription: field("has_subscription", boolean)(json),
  };
}

export function author(json: unknown): Author {
  return {
    id: field("id", number)(json),
    username: field("username", string)(json),
  };
}

export function reaction(json: unknown): Reaction {
  return {
    author: field("author", author)(json),
    relate: field("relate", boolean)(json),
    sendLove: field("send_love", boolean)(json),
  };
}

export function loginSuccess(json: unknown): LoginSuccess {
  return {
    type: "ok",
    apiToken: field("token", string)(json),
  };
}

export function stripePaymentIntent(json: unknown): StripePaymentIntent {
  return {
    clientSecret: field("client_secret", string)(json),
  };
}
