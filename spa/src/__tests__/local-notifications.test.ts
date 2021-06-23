import { LocalNotifications } from "@capacitor/local-notifications";
import { weeklySessionDayBefore } from "../local-notification";
import type { LocalNotificationSchema } from "@capacitor/local-notifications";
import { date } from "../backend/decode";

test("Day is a monday", () => {
  var TEST_DATE = new Date("June 21, 2021 18:00:00");
  let date = new Date("June 22, 2021 19:00:00");
  let notification = weeklySessionDayBefore(1);

  expect(notification.id).toBe(10001);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});

test("Day is a Tuesday, before 19:00", () => {
  var TEST_DATE = new Date("June 22, 2021 18:00:00");
  let date = new Date("June 22, 2021 19:00:00");
  let notification = weeklySessionDayBefore(1);

  expect(notification.id).toBe(10001);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});

test("Day is a Tuesday, after 19:00", () => {
  var TEST_DATE = new Date("June 15, 2021 19:01:00");
  let date = new Date("June 22, 2021 19:00:00");
  let notification = weeklySessionDayBefore(1);

  expect(notification.id).toBe(10001);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});

test("Day is a Friday", () => {
  var TEST_DATE = new Date("June 18, 2021 19:01:00");
  let date = new Date("June 22, 2021 19:00:00");
  let notification = weeklySessionDayBefore(1);

  expect(notification.id).toBe(10001);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});

test("Day is a Friday, fires next week too", () => {
  var TEST_DATE = new Date("June 18, 2021 19:01:00");
  let date = new Date("June 29, 2021 19:00:00");
  let notification = weeklySessionDayBefore(2);

  expect(notification.id).toBe(10002);
  expect(notification.title).toBe("Therapy Reminder");
  let schedule = notification.schedule;
  let scheduleDate = schedule?.at;
  expect(scheduleDate?.getDay()).toBe(2);
  expect(scheduleDate?.getMonth()).toBe(5);
  expect(scheduleDate?.getFullYear()).toBe(2021);
  expect(scheduleDate?.getHours()).toBe(19);
});
