import type { Reaction } from "../state";

export function makeReactionsCountText(allReactions: Array<Reaction>) {
  let reactions = allReactions
    .flatMap(({ relate, sendLove, author }) => [
      { reacted: relate, user: author.username },
      { reacted: sendLove, user: author.username },
    ])
    .filter((entry) => entry.reacted);

  let total = reactions.length;
  let authors = [...new Set(reactions.map((entry) => entry.user))];
  let text = `${total} \xa0 ${authors.slice(0, 3).join(", ")}`;

  switch (authors.length) {
    case 0:
      return "";
    case 1:
    case 2:
    case 3:
      return text;
    case 4:
      return `${text} & 1 other`;
    default:
      return `${text} & ${total - 3} others`;
  }
}
