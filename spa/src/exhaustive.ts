// This error can be used to assert that switch statements are exhaustive and
// handle all variants.

export class UnmatchedError extends Error {
  constructor(error: never) {
    super(`Unreachable case: ${JSON.stringify(error)}`);
  }
}
