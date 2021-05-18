export type Title =
  | "Kalda"
  | "Session Info"
  | "Guidelines"
  | "Daily Reflection"
  | "Therapy Sessions"
  | "Urgent Support"
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
  author: User;
  comments: Array<Comment>;
};

export type Comment = {
  id: number;
  content: string;
  author: User;
  replies: Array<Reply>;
  reactions: Array<Reaction>;
};

export type Reaction = {
  author: User;
  relate: boolean;
  sendLove: boolean;
};

export type Reply = {
  id: number;
  content: string;
  author: User;
  reactions: Array<Reaction>;
};

export type User = {
  id: number;
  username: string;
};

export type ReportComment = {
  id: number;
  reporter_reason: string;
  reporter: User;
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
  author: User;
  content: string;
  reactions: Array<Reaction>;
}

export type LoginSuccess = { type: "ok"; apiToken: string };
export type LoginError = { type: "error"; errorMessage: string };
export type LoginResult = LoginSuccess | LoginError;
