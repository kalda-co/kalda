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
  | "Notification"
  | "Will Pool";

export type AppState = {
  currentUser: User;
  reflections: Array<Post>;
  pools: Array<Post>;
  nextTherapy?: Therapy;
  therapies: Array<Therapy>;
  commentNotifications: Array<CommentNotification>;
};

export type PostState = {
  post: Post;
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
  commentNotifications: Array<CommentNotification>;
  postNotifications: Array<PostNotification>;
};

export type CommentNotification = {
  id: number,
  parentPostId: number,
  commentContent: string;
  commentId: number;
  insertedAt: Date;
  replyId: number;
  replyAuthor: Author;
  replyContent: string;
};

export type PostNotification = {
  id: number;
  parentPostId: number;
  postContent: string;
  insertedAt: Date;
  commentId: number;
  commentAuthor: Author;
  commentContent: string;
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
