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

const THERAPY_FIRST_ID = 20000;

export function notificationsForTherapies(
  therapies: Array<Therapy>
): Array<LocalNotificationSchema> {
  return therapies
    .flatMap((therapy) => {
      return [
        {
          // title: `Your therapy starts in 24 hours at ${therapy.startsAt.getHours()}`, // Make a title using the therapy
          title: "Your therapy starts in 24 hours",
          timeBefore: 1 * DAY,
          therapy,
        },
        {
          title: "Your therapy starts in 1 hour",
          timeBefore: 1 * HOUR,
          therapy,
        },
      ];
    })
    .map((notificationData, index) => {
      let { therapy, title, timeBefore } = notificationData;
      return therapyNotification(therapy, index, timeBefore, title);
    });
}

export function therapyNotification(
  therapy: Therapy,
  index: number,
  timeBefore: number,
  body: string
): LocalNotificationSchema {
  let id = THERAPY_FIRST_ID + index;
  let title = "Therapy Reminder"; // Can use info from the Therapy here
  let date = new Date(therapy?.startsAt?.getTime() - timeBefore);
  return {
    id,
    title,
    body,
    schedule: { at: date },
  };
}
