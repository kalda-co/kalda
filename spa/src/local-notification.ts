import { LocalNotifications } from "@capacitor/local-notifications";
import type {
  LocalNotificationSchema,
  LocalNotificationDescriptor,
} from "@capacitor/local-notifications";

const DAILY_REFLECTION_FIRST_ID = 10000;
const DAILY_REFLECTION_DAYS_TO_SCHEDULE = 14;
const DAILY_REFLECTION_TIME_HOURS = 8;

export async function scheduleDailyReflectionNotifications(): Promise<void> {
  // We would like to use the schedule to repeat every day but there seems to be
  // a bug where this does not work on Android.
  // https://github.com/ionic-team/capacitor/issues/4332
  await cancelDailyReflectionNotifications();
  await schedule(range(DAILY_REFLECTION_DAYS_TO_SCHEDULE).map(dailyReflection));
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
    console.trace("Local notifications not supported");
  }
}

async function schedule(
  notifications: Array<LocalNotificationSchema>
): Promise<void> {
  try {
    await LocalNotifications.schedule({ notifications });
  } catch (_error) {
    console.trace("Local notifications not supported");
  }
}
