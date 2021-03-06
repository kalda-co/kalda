export type Page =
  | "dashboard"
  | "group-therapy-info"
  | "guidelines"
  | "daily-reflection"
  | "therapy-sessions"
  | "will-pool";

export type Title =
  | "Kalda"
  | "Group Therapy"
  | "Guidelines"
  | "Daily Reflection"
  | "Therapy Sessions"
  | "Will Pool";

export type AppState = {
  currentUser: User;
  reflections: Array<Post>;
  pools: Array<Post>;
  currentPage: Page;
  therapy?: Therapy;
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
};

export type Reply = {
  id: number;
  content: string;
  author: User;
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
  event_datetime: Date;
  title?: string;
  description?: string;
  therapist?: string;
  credentials?: string;
};

export interface BubbleContent {
  id: number;
  author: User;
  content: string;
}
