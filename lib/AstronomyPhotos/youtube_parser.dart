/// Converts fully qualified YouTube Url to video id.
///
/// If videoId is passed as url then no conversion is done.
String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var regex in [
    r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$',
    r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$',
    r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$',
  ]) {
    Match? match = RegExp(regex).firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}
