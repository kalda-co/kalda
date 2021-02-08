export type Loading = {
  type: "loading";
};

export type Loaded = {
  type: "loaded";
};

export type FailedToLoad = {
  type: "failedToLoad";
  currentUser: User;
  posts: Array<Post>;
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
  name: string;
};
