const MAX_MESSAGES = 100;

import { writable } from "svelte/store";
import type { Writable } from "svelte/store";

export const messages: Writable<Array<Message>> = writable([]);

export type Message = { time: Date; level: Level; text: string };

export type Level = "info" | "error";

export function info(...things: Array<any>): void {
  recordToLog("info", things);
  // TODO: log when in dev mode
  // console.log(...things);
}

export function error(...things: Array<any>): void {
  recordToLog("error", things);
  console.error(...things);
}

function recordToLog(level: Level, things: Array<any>): void {
  let message = { level, time: new Date(), text: things.join(" ") };
  messages.update((messages) => {
    messages.unshift(message);
    // Discard old messages if the log is now too large
    messages.length = Math.min(MAX_MESSAGES, messages.length);
    return messages;
  });
}
