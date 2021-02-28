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
  const day = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"][
    datetime.getDay()
  ];
  const year = datetime.getFullYear();
  const tz = datetime.getTimezoneOffset();
  const hh = datetime.getHours();
  const mi = datetime.getMinutes();
  return `${day} ${mon} ${dd}, ${year} at ${hh}:${mi} GMT+${tz}`;
}
