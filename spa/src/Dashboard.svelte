<script lang="ts">
  import type { User } from "./state";
  import type { Post } from "./state";
  export let user: User;
  export let post: Post;
</script>

<article>
  <div class="card-wide">
    <h1>
      Hello
      <cite>{user.username}</cite>!
    </h1>
    <h2>Today's reflection question.</h2>
    <div class="card">
      <p class="question">{post.content}</p>
      <a href="/app">
        <button>Post a reflection</button>
      </a>
    </div>
  </div>
  <h2>Activities</h2>
  <div class="card">
    <a href="/app">
      <img src="images/calendar-icon" alt="calendar icon" />
      <p>Date and Time</p>
    </a>
    <h1>Group therapy</h1>
    <p>Learn more about weekly group therapy</p>
  </div>
  <h2>Community</h2>
</article>
