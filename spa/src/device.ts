import { Network } from "@capacitor/network";
import { App } from "@capacitor/app";
import { StatusBar } from "@capacitor/status-bar";

export type NetworkConnectionStatus = "cellular" | "wifi" | "none";

export async function currentNetworkConnectionStatus(): Promise<NetworkConnectionStatus> {
  let status = await Network.getStatus();
  if (!status.connected) return "none";
  if (status.connectionType === "cellular") return "cellular";
  return "wifi";
}

export interface ListenerHandle {
  cancel: () => void;
}

// Call the `doThis` callback function each time the app returns to the
// foreground. The returned `ListenerHandle` can be used to remove the listener.
export function whenAppForegrounded(doThis: () => void): ListenerHandle {
  let cancelled = false;
  let capacitorHandle: { remove: () => void } | undefined;

  App.addListener("appStateChange", ({ isActive }) => {
    if (isActive) doThis();
  }).then((handle) => {
    if (cancelled) {
      handle.remove();
    } else {
      capacitorHandle = handle;
    }
  });

  // The cancel function calls the `remove` method of the handle, if the handle
  // exists. It may not exist because it is asynchronously set by async
  // `App.addListener` function.
  let cancel = () => {
    cancelled = true;
    if (capacitorHandle) capacitorHandle.remove();
  };
  return { cancel };
}

export async function setStatusBarColor(color: string) {
  StatusBar.setBackgroundColor({ color }).catch(() => {
    // We don't care if this fails (we are probably just running in a browser)
  });
}
