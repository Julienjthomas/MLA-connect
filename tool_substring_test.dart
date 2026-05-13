void main() {
  for (final s in ['', 'a', 'ab']) {
    try {
      print(s.substring(0, 10));
    } catch (e) {
      print('len=${s.length} err=$e');
    }
  }
}
