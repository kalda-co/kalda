export type Title =
  | "Kalda"
  | "Session Info"
  | "Guidelines"
  | "Daily Reflection"
  | "Therapy Sessions"
  | "Urgent Support"
  | "Nerd data"
  | "My Account"
  | "Notifications"
  | "Will Pool";

export type AppState = {
  currentUser: User;
  reflections: Array<Post>;
  pools: Array<Post>;
  next_therapy?: Therapy;
  therapies: Array<Therapy>;
  comment_notifications: Array<CommentNotification>;
};

export type Post = {
  id: number;
  content: string;
  author: Author;
  comments: Array<Comment>;
};

export type Comment = {
  id: number;
  content: string;
  author: Author;
  replies: Array<Reply>;
  reactions: Array<Reaction>;
};

export type Reaction = {
  author: Author;
  relate: boolean;
  sendLove: boolean;
};

export type Reply = {
  id: number;
  content: string;
  author: Author;
  reactions: Array<Reaction>;
};

export type User = {
  id: number;
  username: string;
  hasSubscription: boolean;
};

export type Author = {
  id: number;
  username: string;
};

export type ReportComment = {
  id: number;
  reporter_reason: string;
  reporter: Author;
};

export type Therapy = {
  id: number;
  link: string | undefined;
  startsAt: Date;
  title: string;
  description: string;
  therapist: string;
  credentials: string;
};

export type Notifications = {
  comment_notifications: Array<CommentNotification>;
  post_notifications: Array<PostNotification>;
};

export type CommentNotification = {
  comment_content: string;
  comment_id: number;
  inserted_at: Date;
  // TODO: do we need this reply_id
  notification_reply_id: number;
  reply_author: User;
  reply_content: string;
};

export type PostNotification = {
  post_content: string;
  post_id: number;
  inserted_at: Date;
  // TODO: do we need this comment_id
  notification_comment_id: number;
  comment_author: User;
  comment_content: string;
};

export interface BubbleContent {
  id: number;
  author: Author;
  content: string;
  reactions: Array<Reaction>;
}

export type StripePaymentIntent = {
  clientSecret: string;
};

export type LoginSuccess = { type: "ok"; apiToken: string };
export type LoginError = { type: "error"; errorMessage: string };
export type LoginResult = LoginSuccess | LoginError;
