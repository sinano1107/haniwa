String extractionGroupTagId(String uri) {
  final i = uri.indexOf('id%3D') + 5;
  final groupTagId = uri.substring(i, i + 41);
  return groupTagId;
}
