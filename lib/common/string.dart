String shortening(String text, int max) {
  return (text.length > max) ? text.substring(0, max) + '...' : text;
}
