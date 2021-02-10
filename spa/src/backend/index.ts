import type { AppState } from "../state";

const DailyReflectionEndpoint = "/v1/daily-reflections";

export async function getInitialAppState(): Promise<AppState> {
  try {
    let resp = await fetch(DailyReflectionEndpoint, {
      headers: { accept: "application/json" },
    });
    let json = await resp.json();
    return {
      type: "loaded",
      posts: json.posts,
      current_user: json.current_user,
    };
  } catch (error) {
    return { type: "failed_to_load", error };
  }
}
