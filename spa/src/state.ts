export type AppState = {
  currentUser: User;
  posts: Array<Post>;
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

export type FlagComment = {
  id: number;
  reporter_reason: string;
  reporter: User;
};
