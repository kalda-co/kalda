export type Page = "dashboard" | "guidelines" | "daily-reflection";

export type AppState = {
  currentUser: User;
  posts: Array<Post>;
  currentPage: Page;
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

export interface BubbleContent {
  id: number;
  author: User;
  content: string;
}
