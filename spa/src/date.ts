import type { Therapy } from "./state";

export function formattedDatetime(datetime: Date) {
  const dd = datetime.getDate();
  const mm = datetime.getMonth();
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  const mon = months[mm];
  const day = ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"][
    datetime.getDay()
  ];
  const year = datetime.getFullYear();
  const tz = datetime.getTimezoneOffset() / 60;
  let ht = datetime.getHours();
  const hh = ht < 10 ? `0${ht}` : `${ht}`;
  let hm = datetime.getMinutes();
  const mi = hm < 10 ? `0${hm}` : `${hm}`;
  return `${day} ${mon} ${dd}, ${year} at ${hh}:${mi} GMT+${tz}`;
}

export function datetimeToURI(therapy: Therapy) {
  const starts = therapy.startsAt;
  const YYYY = starts.getFullYear();
  const dd = starts.getDate();
  const DD = dd < 10 ? `0${dd}` : `${dd}`;
  const ma = starts.getMonth();
  const mm = ma + 1;
  const MM = mm < 10 ? `0${mm}` : `${mm}`;
  const hm = starts.getMinutes();
  const mi = hm < 10 ? `0${hm}` : `${hm}`;
  const ht = starts.getHours();
  const httz = ht + starts.getTimezoneOffset() / 60;
  const hh = httz < 10 ? `0${httz}` : `${httz}`;
  const endsAtHT = httz + 1;
  const endsAtHH = endsAtHT < 10 ? `0${endsAtHT}` : `${endsAtHT}`;
  const datetimeString = `${YYYY}${MM}${DD}T${hh}${mi}00Z%2F${YYYY}${MM}${DD}T${endsAtHH}${mi}00Z`;
  const desc = encodeURI(therapy.description);
  const title = encodeURI(therapy.title);
  return `https://www.google.com/calendar/render?action=TEMPLATE&text=${title}&details=${desc}&location=${therapy.link}&dates=${datetimeString}`;
}

// TODO: Make this date easier to read (lol)
export function readableDate(date: Date) {
  return date.toDateString();
}

export function readableTime(date: Date) {
  let ht = date.getHours();
  const hh = ht < 10 ? `0${ht}` : `${ht}`;
  let hm = date.getMinutes();
  const mi = hm < 10 ? `0${hm}` : `${hm}`;
  return `${hh}:${mi}`;
}
