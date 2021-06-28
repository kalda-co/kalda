import { LocalNotifications } from "@capacitor/local-notifications";
import type { Therapy } from "./state";
import type {
  LocalNotificationSchema,
  LocalNotificationDescriptor,
} from "@capacitor/local-notifications";
import * as log from "./log";
import { HOUR, DAY } from "./constants";

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

export async function scheduleTherapyNotifications(
  therapies: Array<Therapy>
): Promise<void> {
  // await cancel(notificationsForTherapies(therapies));
  // We want to cancel a fixed larger number of notifications rather than ones based upon the data from the API. If the data changes in the backend the notifications will be wrong.

  // Reproduction:

  // Notifications scheduled for 1 therapy
  // App closed
  //  Admin cancels therapy
  // App opened
  // API returns no therapies
  // No therapies so no notifications are cancelled
  // User gets notification about therapy that doesn't exist
  let presumedMaxTherapies = 10;
  let notificationsPerTherapy = 2;
  let notifications = range(presumedMaxTherapies * notificationsPerTherapy).map(
    (index) => ({ id: THERAPY_FIRST_ID + index })
  );
  await cancel(notifications);
  await schedule(notificationsForTherapies(therapies));
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

const THERAPY_FIRST_ID = 20000;

export function notificationsForTherapies(
  therapies: Array<Therapy>
): Array<LocalNotificationSchema> {
  return therapies
    .flatMap((therapy) => {
      return [
        {
          body: `Your therapy session '${therapy.title}' is in 24 hours.`,
          timeBefore: 1 * DAY,
          therapy,
        },
        {
          body: `Your therapy session '${therapy.title}' starts in 1 hour.`,
          timeBefore: 1 * HOUR,
          therapy,
        },
      ];
    })
    .map((notificationData, index) => {
      let { therapy, body, timeBefore } = notificationData;
      return therapyNotification(therapy, index, timeBefore, body);
    });
}

export function therapyNotification(
  therapy: Therapy,
  index: number,
  timeBefore: number,
  body: string
): LocalNotificationSchema {
  let id = THERAPY_FIRST_ID + index;
  let title = "Therapy Reminder";
  let date = new Date(therapy?.startsAt?.getTime() - timeBefore);
  return {
    id,
    title,
    body,
    schedule: { at: date },
  };
}
