bool isValidUrl(String url) {
  final uri = Uri.tryParse(url);
  return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
}
