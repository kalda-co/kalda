import { LocalNotifications } from "@capacitor/local-notifications";

const DAILY_REFLECTION_NOTIFICATION_ID = 0;

export function scheduleDailyReflectionNotification() {
  LocalNotifications.schedule({
    notifications: [
      {
        id: DAILY_REFLECTION_NOTIFICATION_ID,
        title: "Good morning!",
        body: "Time for your daily reflection",
        schedule: {
          repeats: true,
          on: {
            hour: 8,
            minute: 0,
          },
        },
      },
    ],
  });
}

export function cancelDailyReflectionNotification() {
  LocalNotifications.cancel({
    notifications: [
      {
        id: DAILY_REFLECTION_NOTIFICATION_ID,
      },
    ],
  });
}
