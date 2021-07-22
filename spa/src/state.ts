export type Title =
  | "Kalda"
  | "Session Info"
  | "Guidelines"
  | "Daily Reflection"
  | "Therapy Sessions"
  | "Urgent Support"
  | "Nerd data"
  | "My Account"
  | "Will Pool";

export type AppState = {
  currentUser: User;
  reflections: Array<Post>;
  pools: Array<Post>;
  next_therapy?: Therapy;
  therapies: Array<Therapy>;
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
  link: string;
  startsAt: Date;
  title: string;
  description: string;
  therapist: string;
  credentials: string;
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
