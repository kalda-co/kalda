import App from "./App.svelte";
import type { Post } from "./state";

let comments = [
  {
    id: 0,
    author: {
      id: 5,
      username: "Puppy_Queen",
    },
    replies: [],
    content:
      "My old line manager from work gave me a lot of support when I was working with them. Because they were a few years older than me (maybe like 5?) I felt like I could learn a bit about life from them as well as the job. Some of their support was more pastoral than related to the job. Now I’m not working with them I sometimes email them with questions and set up a quick call. It’s more like a friend now.",
  },
  {
    id: 1,
    author: {
      id: 5,
      username: "ElJ",
    },
    replies: [],
    content:
      "My mum is a big mentor because she’s honest and she’s been an awesome teacher for a long time. It’s awesome to see her with the kids she has a lot of presence and they get very quiet. I remember at school the best teachers were the ones that the students respected and were quiet for!  Teaching is such an important job and she’s stuck with it for a long long time made a lot of impact too.",
  },
  {
    id: 2,
    author: {
      id: 5,
      username: "Otter4life",
    },
    replies: [],
    content: "I like turtles!",
  },
  {
    id: 3,
    author: {
      id: 5,
      username: "Glitter-Friend",
    },
    replies: [],
    content:
      "Here is the horizon of a body. Laid on a soil that would not have it. A 10pm dew settles a glitter on its tar skin. You almost want to touch it. You are...",
  },
];

const post: Post = {
  id: 0,
  author: {
    id: 1,
    username: "Alsquid",
  },
  comments,
  content:
    "If there's a mentor or role model that had an impact on your life, how did they help you? Have you passed it on?",
};

const currentUser = {
  id: 0,
  username: "You",
};

const app = new App({
  target: document.body,
  props: {
    currentUser,
    post,
  },
});

export default app;
