abstract final class PageSlice {
  static const int size = 8;

  static List<T> of<T>(List<T> items, int page) {
    if (items.isEmpty) return const [];
    final start = page * size;
    if (start >= items.length) return const [];
    final end = (start + size).clamp(0, items.length);
    return items.sublist(start, end);
  }

  static int count(int total) {
    if (total <= 0) return 1;
    return (total / size).ceil();
  }

  static int clampPage(int page, int total) {
    final last = count(total) - 1;
    if (page < 0) return 0;
    if (page > last) return last;
    return page;
  }
}
