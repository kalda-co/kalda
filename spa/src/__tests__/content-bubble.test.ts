import { makeReactionsCountText } from "../forum/content-bubble";
import type { Reaction } from "../state";

test("0 reactions", () => {
  let reactions: Array<Reaction> = [];
  expect(makeReactionsCountText(reactions)).toBe("");
});

test("both false", () => {
  let reactions: Array<Reaction> = [
    {
      sendLove: false,
      relate: false,
      author: { id: 1, username: "Tim" },
    },
  ];
  expect(makeReactionsCountText(reactions)).toBe("");
});

test("sendLove", () => {
  let reactions: Array<Reaction> = [
    {
      sendLove: true,
      relate: false,
      author: { id: 1, username: "Tim" },
    },
  ];
  expect(makeReactionsCountText(reactions)).toBe("1 \xa0 Tim");
});

test("sendLove and relate", () => {
  let reactions: Array<Reaction> = [
    {
      sendLove: true,
      relate: true,
      author: { id: 1, username: "Tim" },
    },
  ];
  expect(makeReactionsCountText(reactions)).toBe("2 \xa0 Tim");
});

test("2 users", () => {
  let reactions: Array<Reaction> = [
    {
      sendLove: true,
      relate: true,
      author: { id: 1, username: "Tim" },
    },
    {
      sendLove: true,
      relate: true,
      author: { id: 2, username: "Tom" },
    },
  ];
  expect(makeReactionsCountText(reactions)).toBe("4 \xa0 Tim, Tom");
});

test("3 users", () => {
  let reactions: Array<Reaction> = [
    {
      sendLove: true,
      relate: true,
      author: { id: 1, username: "Tim" },
    },
    {
      sendLove: true,
      relate: true,
      author: { id: 2, username: "Tom" },
    },
    {
      sendLove: false,
      relate: true,
      author: { id: 3, username: "Tum" },
    },
  ];
  expect(makeReactionsCountText(reactions)).toBe("5 \xa0 Tim, Tom, Tum");
});

test("4 users", () => {
  let reactions: Array<Reaction> = [
    {
      sendLove: true,
      relate: true,
      author: { id: 1, username: "Tim" },
    },
    {
      sendLove: true,
      relate: false,
      author: { id: 2, username: "Tom" },
    },
    {
      sendLove: false,
      relate: true,
      author: { id: 3, username: "Tum" },
    },
    {
      sendLove: false,
      relate: true,
      author: { id: 4, username: "Tam" },
    },
  ];
  expect(makeReactionsCountText(reactions)).toBe(
    "5 \xa0 Tim, Tom, Tum & 1 other"
  );
});

test("5 users", () => {
  let reactions: Array<Reaction> = [
    {
      sendLove: true,
      relate: false,
      author: { id: 1, username: "Tim" },
    },
    {
      sendLove: true,
      relate: false,
      author: { id: 2, username: "Tom" },
    },
    {
      sendLove: false,
      relate: true,
      author: { id: 3, username: "Tum" },
    },
    {
      sendLove: false,
      relate: true,
      author: { id: 4, username: "Tam" },
    },
    {
      sendLove: false,
      relate: true,
      author: { id: 5, username: "Tem" },
    },
  ];
  expect(makeReactionsCountText(reactions)).toBe(
    "5 \xa0 Tim, Tom, Tum & 2 others"
  );
});
