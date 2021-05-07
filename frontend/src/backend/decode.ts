// A module for safely decoding values from unknown types
// (i.e. those we get from APIs)

export type Decoder<T> = (x: unknown) => T;

export function number(x: unknown): number {
  if (typeof x === "number") return x;
  throw new Error(` Expected number, got ${typeof x}`);
}

export function string(x: unknown): string {
  if (typeof x === "string") return x;
  throw new Error(` Expected string, got ${typeof x}`);
}

export function boolean(x: unknown): boolean {
  if (typeof x === "boolean") return x;
  throw new Error(` Expected boolean, got ${typeof x}`);
}

export function date(x: unknown): Date {
  let dateString = string(x);
  let date = new Date(dateString);
  if (!Number.isNaN(date)) return date;
  throw new Error(` Expected datetime string, got ${dateString}`);
}

export function optional<Element>(
  decoder: Decoder<Element>
): Decoder<Element | undefined> {
  return (x: unknown) => {
    if (x === undefined || x === null) return undefined;
    return decoder(x);
  };
}

export function array<Element>(
  decoder: Decoder<Element>
): Decoder<Array<Element>> {
  return (array: unknown) => {
    if (!Array.isArray(array)) {
      throw new Error(` Expected array, got ${typeof array}`);
    }

    let typeCheckElement = (element: unknown, i: number) => {
      return indexInto(array, i.toString(), decoder);
    };

    return array.map(typeCheckElement);
  };
}

export function field<Element>(
  fieldName: string,
  decoder: Decoder<Element>
): Decoder<Element> {
  return (object: unknown) => {
    if (typeof object !== "object" || object === null) {
      let found = object === null ? "null" : typeof object;
      throw new Error(` Expected object, got ${found}`);
    }

    return indexInto(object, fieldName, decoder);
  };
}

function indexInto<T>(thing: object, index: string, decoder: Decoder<T>): T {
  try {
    return decoder((thing as any)[index]);
  } catch (error) {
    throw new Error(`[${index}]${error.message}`);
  }
}
