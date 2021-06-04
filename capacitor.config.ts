import { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "co.kalda.app",
  appName: "Kalda",
  webDir: "priv/static",
  bundledWebRuntime: false,
  plugins: {
    LocalNotifications: {
      smallIcon: "ic_stat_onesignal_default",
      iconColor: "#4a00b0",
    },
  },
};

export default config;
