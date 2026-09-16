/// Modelo de dominio para una categoría de bocadillos.
///
/// Se persiste en la tabla auxiliar `categories` (SQL crudo, no Drift).
class Category {
  final int id;
  final String name;
  final String icon;
  final String colorHex;
  final bool isDefault;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.isDefault,
  });

  factory Category.fromRow(Map<String, dynamic> row) => Category(
    id: row['id'] as int,
    name: row['name'] as String,
    icon: (row['icon'] as String?) ?? 'fastfood',
    colorHex: (row['color_hex'] as String?) ?? '#38BDF8',
    isDefault: ((row['is_default'] as int?) ?? 0) == 1,
  );

  Category copyWith({
    int? id,
    String? name,
    String? icon,
    String? colorHex,
    bool? isDefault,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorHex: colorHex ?? this.colorHex,
    isDefault: isDefault ?? this.isDefault,
  );

  @override
  String toString() => 'Category($id, $name)';
}

/// Modelo de dominio para un método de pago.
class PaymentMethod {
  final int id;
  final String name;
  final String icon;
  final String colorHex;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.isDefault,
  });

  factory PaymentMethod.fromRow(Map<String, dynamic> row) => PaymentMethod(
    id: row['id'] as int,
    name: row['name'] as String,
    icon: (row['icon'] as String?) ?? 'payments',
    colorHex: (row['color_hex'] as String?) ?? '#38BDF8',
    isDefault: ((row['is_default'] as int?) ?? 0) == 1,
  );

  @override
  String toString() => 'PaymentMethod($id, $name)';
}

/// Datos opcionales por día (notas, rating, gastos extra).
class DailyExtras {
  final String date; // yyyy-MM-dd
  final String? notes;
  final int? rating; // 1..5
  final double extraExpenses;

  const DailyExtras({
    required this.date,
    this.notes,
    this.rating,
    this.extraExpenses = 0,
  });

  factory DailyExtras.fromRow(Map<String, dynamic> row) => DailyExtras(
    date: row['date'] as String,
    notes: row['notes'] as String?,
    rating: row['rating'] as int?,
    extraExpenses: ((row['extra_expenses'] as num?) ?? 0).toDouble(),
  );

  DailyExtras copyWith({
    String? notes,
    int? rating,
    double? extraExpenses,
  }) => DailyExtras(
    date: date,
    notes: notes ?? this.notes,
    rating: rating ?? this.rating,
    extraExpenses: extraExpenses ?? this.extraExpenses,
  );
}
