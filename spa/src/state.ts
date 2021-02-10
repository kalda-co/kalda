export type Loading = {
  type: "loading";
};

export type Loaded = {
  type: "loaded";
  current_user: User;
  posts: Array<Post>;
};

export type FailedToLoad = {
  type: "failed_to_load";
  error: Error;
};

export type AppState = Loading | Loaded | FailedToLoad;

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
