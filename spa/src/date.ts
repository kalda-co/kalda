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
  let ht = datetime.getHours();
  const hh = ht < 10 ? `0${ht}` : `${ht}`;
  let hm = datetime.getMinutes();
  const mi = hm < 10 ? `0${hm}` : `${hm}`;
  return `${day} ${mon} ${dd}, ${year} at ${hh}:${mi} GMT+${tz}`;
}
