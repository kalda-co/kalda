<div class="loading">
  <div class="loading-spinner" />
  <h2 class="loading-text">Loading</h2>
</div>

<style>
  .loading {
    background-color: var(--color-purple);
    display: flex;
    height: 100%;
    width: 100%;
    align-items: center;
    justify-content: center;
    color: var(--color-white);
    flex-direction: column;
  }
  .loading-text {
    font-size: 24px;
  }
  .loading-spinner {
    --border: 18px;
    --size: calc(var(--border) * 4);
    border: var(--border) solid #f3f3f3;
    border-radius: 50%;
    border-top: var(--border) solid var(--color-pink);
    width: var(--size);
    height: var(--size);
    animation: spin 2s ease-in-out infinite;
  }
  @keyframes spin {
    0% {
      transform: rotate(-45deg);
    }
    90% {
      transform: rotate(315deg);
    }
    100% {
      transform: rotate(315deg);
    }
  }
</style>
