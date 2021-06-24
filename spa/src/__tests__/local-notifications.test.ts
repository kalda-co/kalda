import { LocalNotifications } from "@capacitor/local-notifications";
import { notificationsForTherapies } from "../local-notification";
import type { LocalNotificationSchema } from "@capacitor/local-notifications";
import { date } from "../backend/decode";
import type { Therapy } from "../state";

test("notificationsForTherapies/1", () => {
  let therapies: Array<Therapy> = [
    {
      id: 1,
      title: "Mindfulness",
      description: "How to get still and present and reduce anxiety",
      therapist: "Al Dee",
      credentials: "FreeMind hypnotherapist and mindfulness coach",
      link: "https://somerandomlink.co",
      startsAt: new Date("June 03, 2026 19:00:00"),
    },
    {
      id: 2,
      title: "Gratitude",
      description: "How to be thankful and feel the joy",
      therapist: "Al Dee",
      credentials: "FreeMind hypnotherapist and mindfulness coach",
      link: "https://somerandomlink.co",
      startsAt: new Date("June 10, 2026 19:00:00"),
    },
    {
      id: 3,
      title: "Movement",
      description: "How to be within your body",
      therapist: "Al Dee",
      credentials: "FreeMind hypnotherapist and mindfulness coach",
      link: "https://somerandomlink.co",
      startsAt: new Date("June 17, 2026 19:00:00"),
    },
    {
      id: 4,
      title: "Stillness",
      description: "How to tolerate discomfort",
      therapist: "Al Dee",
      credentials: "FreeMind hypnotherapist and mindfulness coach",
      link: "https://somerandomlink.co",
      startsAt: new Date("June 24, 2026 19:00:00"),
    },
  ];

  let notifications = notificationsForTherapies(therapies);
  expect(notificationsForTherapies(therapies)).toEqual([
    {
      id: 20000,
      title: "Therapy Reminder",
      body: "Your therapy session 'Mindfulness' is in 24 hours.",
      schedule: {
        at: new Date("June 02, 2026 19:00:00"),
      },
    },
    {
      id: 20001,
      title: "Therapy Reminder",
      body: "Your therapy session 'Mindfulness' starts in 1 hour.",
      schedule: {
        at: new Date("June 03, 2026 18:00:00"),
      },
    },
    {
      id: 20002,
      title: "Therapy Reminder",
      body: "Your therapy session 'Gratitude' is in 24 hours.",
      schedule: {
        at: new Date("June 09, 2026 19:00:00"),
      },
    },
    {
      id: 20003,
      title: "Therapy Reminder",
      body: "Your therapy session 'Gratitude' starts in 1 hour.",
      schedule: {
        at: new Date("June 10, 2026 18:00:00"),
      },
    },
    {
      id: 20004,
      title: "Therapy Reminder",
      body: "Your therapy session 'Movement' is in 24 hours.",
      schedule: {
        at: new Date("June 16, 2026 19:00:00"),
      },
    },
    {
      id: 20005,
      title: "Therapy Reminder",
      body: "Your therapy session 'Movement' starts in 1 hour.",
      schedule: {
        at: new Date("June 17, 2026 18:00:00"),
      },
    },
    {
      id: 20006,
      title: "Therapy Reminder",
      body: "Your therapy session 'Stillness' is in 24 hours.",
      schedule: {
        at: new Date("June 23, 2026 19:00:00"),
      },
    },
    {
      id: 20007,
      title: "Therapy Reminder",
      body: "Your therapy session 'Stillness' starts in 1 hour.",
      schedule: {
        at: new Date("June 24, 2026 18:00:00"),
      },
    },
  ]);
});
