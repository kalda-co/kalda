// a little wrapper around the capacitor dialog API in case we need to remove it
// in future. Stops their API spreading all over our application.

import { Dialog } from "@capacitor/dialog";

export function alertbox(title: string, message: string) {
  Dialog.alert({ title, message });
}
