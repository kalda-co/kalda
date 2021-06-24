import { LocalNotifications } from "@capacitor/local-notifications";
import { weeklySessionNotification } from "../local-notification";
import type { LocalNotificationSchema } from "@capacitor/local-notifications";
import { date } from "../backend/decode";

const DAY_BEFORE_NOTIFICATION_DAY = 2; // Tuesday
const DAY_BEFORE_NOTIFICATION_TIME = 19; // 19:00pm
const DAY_BEFORE_NOTIFICATION_FIRST_ID = 20000;
const DAY_BEFORE_NOTIFICATION_MESSAGE_BODY =
  "Your kalda Group Session is tomorrow at 7pm.";

test("Weekly day-before notifications when today is a monday", () => {
  var TEST_DATE = new Date("June 21, 2021 18:00:00");
  let date = new Date("June 22, 2021 19:00:00");
  let notification = weeklySessionNotification(
    1,
    DAY_BEFORE_NOTIFICATION_DAY,
    DAY_BEFORE_NOTIFICATION_TIME,
    DAY_BEFORE_NOTIFICATION_FIRST_ID,
    DAY_BEFORE_NOTIFICATION_MESSAGE_BODY
  );

  expect(notification.id).toBe(20001);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});

test("Weekly day-before notifications when today is a Tuesday, before 19:00", () => {
  var TEST_DATE = new Date("June 22, 2021 18:00:00");
  let date = new Date("June 22, 2021 19:00:00");
  let notification = weeklySessionNotification(
    1,
    DAY_BEFORE_NOTIFICATION_DAY,
    DAY_BEFORE_NOTIFICATION_TIME,
    DAY_BEFORE_NOTIFICATION_FIRST_ID,
    DAY_BEFORE_NOTIFICATION_MESSAGE_BODY
  );

  expect(notification.id).toBe(20001);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});

test("Weekly day-before notifications when today  is a Tuesday, after 19:00", () => {
  var TEST_DATE = new Date("June 15, 2021 19:01:00");
  let date = new Date("June 22, 2021 19:00:00");
  let notification = weeklySessionNotification(
    1,
    DAY_BEFORE_NOTIFICATION_DAY,
    DAY_BEFORE_NOTIFICATION_TIME,
    DAY_BEFORE_NOTIFICATION_FIRST_ID,
    DAY_BEFORE_NOTIFICATION_MESSAGE_BODY
  );

  expect(notification.id).toBe(20001);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});

test("Weekly day-before notifications when today  is a Friday", () => {
  var TEST_DATE = new Date("June 18, 2021 19:01:00");
  let date = new Date("June 22, 2021 19:00:00");
  let notification = weeklySessionNotification(
    1,
    DAY_BEFORE_NOTIFICATION_DAY,
    DAY_BEFORE_NOTIFICATION_TIME,
    DAY_BEFORE_NOTIFICATION_FIRST_ID,
    DAY_BEFORE_NOTIFICATION_MESSAGE_BODY
  );

  expect(notification.id).toBe(20001);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});

test("Weekly day-before notifications when today  is a Friday, fires next week too", () => {
  var TEST_DATE = new Date("June 18, 2021 19:01:00");
  // Not the following Tuesday but the one after that
  let date = new Date("June 29, 2021 19:00:00");
  let notification = weeklySessionNotification(
    2,
    DAY_BEFORE_NOTIFICATION_DAY,
    DAY_BEFORE_NOTIFICATION_TIME,
    DAY_BEFORE_NOTIFICATION_FIRST_ID,
    DAY_BEFORE_NOTIFICATION_MESSAGE_BODY
  );

  expect(notification.id).toBe(20002);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});

const HOUR_BEFORE_NOTIFICATION_DAY = 3; // Wednesday
const HOUR_BEFORE_NOTIFICATION_TIME = 18; // 18:00pm
const HOUR_BEFORE_NOTIFICATION_FIRST_ID = 30000;
const HOUR_BEFORE_NOTIFICATION_MESSAGE_BODY =
  "Your Kalda Group Session starts in 1 hour at 7pm";

test("Weekly HOUR-before notifications when today is a Wednesday day, before 18:00", () => {
  var TEST_DATE = new Date("June 23, 2021 16:00:00");
  let date = new Date("June 23, 2021 18:00:00");
  let notification = weeklySessionNotification(
    1,
    HOUR_BEFORE_NOTIFICATION_DAY,
    HOUR_BEFORE_NOTIFICATION_TIME,
    HOUR_BEFORE_NOTIFICATION_FIRST_ID,
    HOUR_BEFORE_NOTIFICATION_MESSAGE_BODY
  );

  expect(notification.id).toBe(30001);
  expect(notification.title).toBe("Therapy Reminder");
  expect(notification.body).toBe(
    "Your Kalda Group Session starts in 1 hour at 7pm"
  );
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(3);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(18);
});

test("Weekly HOUR-before notifications when today is a Wednesday day, AFTER 18:00", () => {
  var TEST_DATE = new Date("June 16, 2021 18:10:00");
  let date = new Date("June 23, 2021 18:00:00");
  let notification = weeklySessionNotification(
    1,
    HOUR_BEFORE_NOTIFICATION_DAY,
    HOUR_BEFORE_NOTIFICATION_TIME,
    HOUR_BEFORE_NOTIFICATION_FIRST_ID,
    HOUR_BEFORE_NOTIFICATION_MESSAGE_BODY
  );

  expect(notification.id).toBe(30001);
  expect(notification.title).toBe("Therapy Reminder");
  expect(notification.body).toBe(
    "Your Kalda Group Session starts in 1 hour at 7pm"
  );
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(3);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(18);
});
