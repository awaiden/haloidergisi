/// A page of a list endpoint (`{ items, meta: { total } }` from `@DrizzleQuery` services).
class Paginated<T> {
  const Paginated({required this.items, required this.total});

  final List<T> items;
  final int total;

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) => Paginated(
    items: (json['items'] as List)
        .map((e) => fromItem(e as Map<String, dynamic>))
        .toList(),
    total: ((json['meta'] as Map<String, dynamic>)['total'] as num).toInt(),
  );

  Paginated<R> map<R>(R Function(T) convert) =>
      Paginated(items: items.map(convert).toList(), total: total);
}
