import { LocalNotifications } from "@capacitor/local-notifications";
import type {
  LocalNotificationSchema,
  LocalNotificationDescriptor,
} from "@capacitor/local-notifications";
import * as log from "./log";

const DAILY_REFLECTION_FIRST_ID = 10000;
const DAILY_REFLECTION_DAYS_TO_SCHEDULE = 14;
const DAILY_REFLECTION_TIME_HOURS = 8;

export async function scheduleDailyReflectionNotifications(): Promise<void> {
  // We would like to use the schedule to repeat every day but there seems to be
  // a bug where this does not work on Android.
  // https://github.com/ionic-team/capacitor/issues/4332
  await cancelDailyReflectionNotifications();
  await schedule(range(DAILY_REFLECTION_DAYS_TO_SCHEDULE).map(dailyReflection));
  log.info("Daily reflection notifications scheduled");
}

function dailyReflection(index: number): LocalNotificationSchema {
  let date = new Date();
  let hasAlreadyFiredToday = date.getHours() >= DAILY_REFLECTION_TIME_HOURS;
  let daysLater = index + (hasAlreadyFiredToday ? 1 : 0);
  date.setDate(date.getDate() + daysLater);
  date.setHours(DAILY_REFLECTION_TIME_HOURS);
  date.setMinutes(0);
  return {
    id: DAILY_REFLECTION_FIRST_ID + index,
    title: "Good morning!",
    body: "Time for your daily reflection",
    schedule: { at: date },
  };
}

export async function cancelDailyReflectionNotifications(): Promise<void> {
  let notifications = range(DAILY_REFLECTION_DAYS_TO_SCHEDULE).map((index) => ({
    id: DAILY_REFLECTION_FIRST_ID + index,
  }));
  cancel(notifications);
}

function range(upTo: number) {
  return Array(upTo)
    .fill(0)
    .map((_, index) => index);
}

async function cancel(
  notifications: Array<LocalNotificationDescriptor>
): Promise<void> {
  try {
    await LocalNotifications.cancel({ notifications });
  } catch (_error) {
    log.info("Local notifications not supported");
  }
}

async function schedule(
  notifications: Array<LocalNotificationSchema>
): Promise<void> {
  try {
    await LocalNotifications.schedule({ notifications });
  } catch (_error) {
    log.info("Local notifications not supported");
  }
}

// Date.getDay() returns integer where Sunday == 0
const DAY_BEFORE_NOTIFICATION_DAY = 2; // Tuesday
const DAY_BEFORE_NOTIFICATION_TIME = 19; // 19:00pm
const DAY_BEFORE_NOTIFICATION_FIRST_ID = 20000;
const DAY_BEFORE_NOTIFICATION_MESSAGE_BODY =
  "Your kalda Group Session is tomorrow at 7pm.";
const HOUR_BEFORE_NOTIFICATION_DAY = 3; // Wednesday
const HOUR_BEFORE_NOTIFICATION_TIME = 18; // 18:00pm
const HOUR_BEFORE_NOTIFICATION_FIRST_ID = 30000;
const HOUR_BEFORE_NOTIFICATION_MESSAGE_BODY =
  "Your Kalda Group Session starts in 1 hour at 7pm";

const NOTIFICATIONS_TO_SCHEDULE = 3; //up to 3 weeks
var TEST_DATE: Date;

// export function weeklySessionDayBefore(index: number): LocalNotificationSchema {
//   let date = TEST_DATE || new Date();
//   let afterReminderTime = date.getHours() >= DAY_BEFORE_NOTIFICATION_TIME;
//   let effectiveDayOfWeek = date.getDay() + (afterReminderTime ? 1 : 0);
//   // For example if day of week is monday, getDay returns 1.
//   // 7 - (1 - 2) is 7 - -1 is 8
//   // 8 mod 7 is 1 so on monday reminderInDays returns 1, reminding on Tuesday
//   // if today is thursday, effectiveDayOfWeek is 4, reminderInDays returns 5 (Tuesday)
//   // if today is tuesday before 19:00 effective day of week is 2. reminderInDays (7 - (2 - 2)) mod 7, returns 0
//   let reminderInDays =
//     (7 - (effectiveDayOfWeek - DAY_BEFORE_NOTIFICATION_DAY)) % 7;
//   date.setDate(date.getDate() + reminderInDays);
//   date.setHours(DAY_BEFORE_NOTIFICATION_TIME);
//   date.setMinutes(0);
//   return {
//     id: DAY_BEFORE_NOTIFICATION_FIRST_ID + index,
//     title: "Therapy Reminder",
//     body: "Your Kalda Group Session is tomorrow at 7pm",
//     schedule: { at: date },
//   };
// }

export function weeklySessionNotification(
  index: number,
  notificationDay: number,
  notificationTime: number,
  notificationFirstID: number,
  notificationBody: string
): LocalNotificationSchema {
  let date = TEST_DATE || new Date();
  let afterReminderTime = date.getHours() >= notificationTime;
  let effectiveDayOfWeek = date.getDay() + (afterReminderTime ? 1 : 0);
  let reminderInDays = (7 - (effectiveDayOfWeek - notificationDay)) % 7;
  date.setDate(date.getDate() + reminderInDays);
  date.setHours(notificationTime);
  date.setMinutes(0);
  return {
    id: notificationFirstID + index,
    title: "Therapy Reminder",
    // body: "Your Kalda Group Session starts in 1 hour at 7pm",
    body: notificationBody,
    schedule: { at: date },
  };
}

export async function cancelNotifications(
  firstNotificationID: number,
  numberNotificationsScheduled: number
): Promise<void> {
  let notifications = range(numberNotificationsScheduled).map((index) => ({
    id: firstNotificationID + index,
  }));
  await LocalNotifications.cancel({ notifications });
}

export async function scheduleTherapyNotifications(): Promise<void> {
  await cancelNotifications(
    DAY_BEFORE_NOTIFICATION_FIRST_ID,
    NOTIFICATIONS_TO_SCHEDULE
  );
  await cancelNotifications(
    HOUR_BEFORE_NOTIFICATION_FIRST_ID,
    NOTIFICATIONS_TO_SCHEDULE
  );
  await LocalNotifications.schedule({
    notifications: range(NOTIFICATIONS_TO_SCHEDULE).map((x) =>
      weeklySessionNotification(
        x,
        DAY_BEFORE_NOTIFICATION_FIRST_ID,
        DAY_BEFORE_NOTIFICATION_DAY,
        DAY_BEFORE_NOTIFICATION_TIME,
        DAY_BEFORE_NOTIFICATION_MESSAGE_BODY
      )
    ),
  });
  await LocalNotifications.schedule({
    notifications: range(NOTIFICATIONS_TO_SCHEDULE).map((x) =>
      weeklySessionNotification(
        x,
        HOUR_BEFORE_NOTIFICATION_DAY,
        HOUR_BEFORE_NOTIFICATION_TIME,
        HOUR_BEFORE_NOTIFICATION_FIRST_ID,
        HOUR_BEFORE_NOTIFICATION_MESSAGE_BODY
      )
    ),
  });
}
