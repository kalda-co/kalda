import { render } from "@testing-library/svelte";
import Loaded from "../Loaded.svelte";
import { MockApiClient } from "../backend";
import type { AppState } from "../state";

test("should render", () => {
  let api = new MockApiClient();
  let state: AppState = {
    currentUser: { id: 1, username: "user" },
    pools: [],
    therapies: [],
    reflections: [],
  };
  let results = render(Loaded, { props: { state, api } });
  expect(() => results.getByText("Kalda")).not.toThrow();
});

test("it works", () => {
  expect(1).toBe(1);
});
