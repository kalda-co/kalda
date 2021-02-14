import type { AppState, Comment } from "../state";

let CSRFToken = "";

export function setCSRFToken(token: string) {
  CSRFToken = token;
}

const DailyReflectionEndpoint = "/v1/daily-reflections";

function constructPostCommentEndpoint(post_id: number): string {
  // js string interpolation in html safe way
  return "/v1/posts/" + post_id + "/comments";
}

export async function getInitialAppState(): Promise<AppState> {
  let resp = await fetch(DailyReflectionEndpoint, {
    credentials: "include",
    headers: { accept: "application/json" },
  });
  let json = await resp.json();
  return {
    posts: json.posts,
    current_user: json.current_user,
  };
}

export async function createComment(
  post_id: number,
  content: string
): Promise<Comment> {
  let body = JSON.stringify({
    content: content,
  });
  let resp = await fetch(constructPostCommentEndpoint(post_id), {
    headers: {
      "content-type": "application/json",
      accept: "application/json",
      "x-csrf-token": CSRFToken,
    },
    credentials: "include",
    method: "POST",
    body,
  });
  let json = await resp.json();
  if (resp.status !== 201) {
    throw new Error(`Comment could not be created. ${resp.status} ${json}`);
  }
  return json;
}
