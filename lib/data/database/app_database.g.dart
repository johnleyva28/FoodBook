// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _hadBreakfastMeta = const VerificationMeta(
    'hadBreakfast',
  );
  @override
  late final GeneratedColumn<bool> hadBreakfast = GeneratedColumn<bool>(
    'had_breakfast',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("had_breakfast" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _breakfastPriceMeta = const VerificationMeta(
    'breakfastPrice',
  );
  @override
  late final GeneratedColumn<double> breakfastPrice = GeneratedColumn<double>(
    'breakfast_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _breakfastDescMeta = const VerificationMeta(
    'breakfastDesc',
  );
  @override
  late final GeneratedColumn<String> breakfastDesc = GeneratedColumn<String>(
    'breakfast_desc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hadLunchMeta = const VerificationMeta(
    'hadLunch',
  );
  @override
  late final GeneratedColumn<bool> hadLunch = GeneratedColumn<bool>(
    'had_lunch',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("had_lunch" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hadDinnerMeta = const VerificationMeta(
    'hadDinner',
  );
  @override
  late final GeneratedColumn<bool> hadDinner = GeneratedColumn<bool>(
    'had_dinner',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("had_dinner" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    hadBreakfast,
    breakfastPrice,
    breakfastDesc,
    hadLunch,
    hadDinner,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('had_breakfast')) {
      context.handle(
        _hadBreakfastMeta,
        hadBreakfast.isAcceptableOrUnknown(
          data['had_breakfast']!,
          _hadBreakfastMeta,
        ),
      );
    }
    if (data.containsKey('breakfast_price')) {
      context.handle(
        _breakfastPriceMeta,
        breakfastPrice.isAcceptableOrUnknown(
          data['breakfast_price']!,
          _breakfastPriceMeta,
        ),
      );
    }
    if (data.containsKey('breakfast_desc')) {
      context.handle(
        _breakfastDescMeta,
        breakfastDesc.isAcceptableOrUnknown(
          data['breakfast_desc']!,
          _breakfastDescMeta,
        ),
      );
    }
    if (data.containsKey('had_lunch')) {
      context.handle(
        _hadLunchMeta,
        hadLunch.isAcceptableOrUnknown(data['had_lunch']!, _hadLunchMeta),
      );
    }
    if (data.containsKey('had_dinner')) {
      context.handle(
        _hadDinnerMeta,
        hadDinner.isAcceptableOrUnknown(data['had_dinner']!, _hadDinnerMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      hadBreakfast: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}had_breakfast'],
      )!,
      breakfastPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}breakfast_price'],
      )!,
      breakfastDesc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breakfast_desc'],
      ),
      hadLunch: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}had_lunch'],
      )!,
      hadDinner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}had_dinner'],
      )!,
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLog extends DataClass implements Insertable<DailyLog> {
  final int id;
  final String date;
  final bool hadBreakfast;
  final double breakfastPrice;
  final String? breakfastDesc;
  final bool hadLunch;
  final bool hadDinner;
  const DailyLog({
    required this.id,
    required this.date,
    required this.hadBreakfast,
    required this.breakfastPrice,
    this.breakfastDesc,
    required this.hadLunch,
    required this.hadDinner,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['had_breakfast'] = Variable<bool>(hadBreakfast);
    map['breakfast_price'] = Variable<double>(breakfastPrice);
    if (!nullToAbsent || breakfastDesc != null) {
      map['breakfast_desc'] = Variable<String>(breakfastDesc);
    }
    map['had_lunch'] = Variable<bool>(hadLunch);
    map['had_dinner'] = Variable<bool>(hadDinner);
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      id: Value(id),
      date: Value(date),
      hadBreakfast: Value(hadBreakfast),
      breakfastPrice: Value(breakfastPrice),
      breakfastDesc: breakfastDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(breakfastDesc),
      hadLunch: Value(hadLunch),
      hadDinner: Value(hadDinner),
    );
  }

  factory DailyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      hadBreakfast: serializer.fromJson<bool>(json['hadBreakfast']),
      breakfastPrice: serializer.fromJson<double>(json['breakfastPrice']),
      breakfastDesc: serializer.fromJson<String?>(json['breakfastDesc']),
      hadLunch: serializer.fromJson<bool>(json['hadLunch']),
      hadDinner: serializer.fromJson<bool>(json['hadDinner']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'hadBreakfast': serializer.toJson<bool>(hadBreakfast),
      'breakfastPrice': serializer.toJson<double>(breakfastPrice),
      'breakfastDesc': serializer.toJson<String?>(breakfastDesc),
      'hadLunch': serializer.toJson<bool>(hadLunch),
      'hadDinner': serializer.toJson<bool>(hadDinner),
    };
  }

  DailyLog copyWith({
    int? id,
    String? date,
    bool? hadBreakfast,
    double? breakfastPrice,
    Value<String?> breakfastDesc = const Value.absent(),
    bool? hadLunch,
    bool? hadDinner,
  }) => DailyLog(
    id: id ?? this.id,
    date: date ?? this.date,
    hadBreakfast: hadBreakfast ?? this.hadBreakfast,
    breakfastPrice: breakfastPrice ?? this.breakfastPrice,
    breakfastDesc: breakfastDesc.present
        ? breakfastDesc.value
        : this.breakfastDesc,
    hadLunch: hadLunch ?? this.hadLunch,
    hadDinner: hadDinner ?? this.hadDinner,
  );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      hadBreakfast: data.hadBreakfast.present
          ? data.hadBreakfast.value
          : this.hadBreakfast,
      breakfastPrice: data.breakfastPrice.present
          ? data.breakfastPrice.value
          : this.breakfastPrice,
      breakfastDesc: data.breakfastDesc.present
          ? data.breakfastDesc.value
          : this.breakfastDesc,
      hadLunch: data.hadLunch.present ? data.hadLunch.value : this.hadLunch,
      hadDinner: data.hadDinner.present ? data.hadDinner.value : this.hadDinner,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('hadBreakfast: $hadBreakfast, ')
          ..write('breakfastPrice: $breakfastPrice, ')
          ..write('breakfastDesc: $breakfastDesc, ')
          ..write('hadLunch: $hadLunch, ')
          ..write('hadDinner: $hadDinner')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    hadBreakfast,
    breakfastPrice,
    breakfastDesc,
    hadLunch,
    hadDinner,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.hadBreakfast == this.hadBreakfast &&
          other.breakfastPrice == this.breakfastPrice &&
          other.breakfastDesc == this.breakfastDesc &&
          other.hadLunch == this.hadLunch &&
          other.hadDinner == this.hadDinner);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<int> id;
  final Value<String> date;
  final Value<bool> hadBreakfast;
  final Value<double> breakfastPrice;
  final Value<String?> breakfastDesc;
  final Value<bool> hadLunch;
  final Value<bool> hadDinner;
  const DailyLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.hadBreakfast = const Value.absent(),
    this.breakfastPrice = const Value.absent(),
    this.breakfastDesc = const Value.absent(),
    this.hadLunch = const Value.absent(),
    this.hadDinner = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    this.hadBreakfast = const Value.absent(),
    this.breakfastPrice = const Value.absent(),
    this.breakfastDesc = const Value.absent(),
    this.hadLunch = const Value.absent(),
    this.hadDinner = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyLog> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<bool>? hadBreakfast,
    Expression<double>? breakfastPrice,
    Expression<String>? breakfastDesc,
    Expression<bool>? hadLunch,
    Expression<bool>? hadDinner,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (hadBreakfast != null) 'had_breakfast': hadBreakfast,
      if (breakfastPrice != null) 'breakfast_price': breakfastPrice,
      if (breakfastDesc != null) 'breakfast_desc': breakfastDesc,
      if (hadLunch != null) 'had_lunch': hadLunch,
      if (hadDinner != null) 'had_dinner': hadDinner,
    });
  }

  DailyLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<bool>? hadBreakfast,
    Value<double>? breakfastPrice,
    Value<String?>? breakfastDesc,
    Value<bool>? hadLunch,
    Value<bool>? hadDinner,
  }) {
    return DailyLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      hadBreakfast: hadBreakfast ?? this.hadBreakfast,
      breakfastPrice: breakfastPrice ?? this.breakfastPrice,
      breakfastDesc: breakfastDesc ?? this.breakfastDesc,
      hadLunch: hadLunch ?? this.hadLunch,
      hadDinner: hadDinner ?? this.hadDinner,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (hadBreakfast.present) {
      map['had_breakfast'] = Variable<bool>(hadBreakfast.value);
    }
    if (breakfastPrice.present) {
      map['breakfast_price'] = Variable<double>(breakfastPrice.value);
    }
    if (breakfastDesc.present) {
      map['breakfast_desc'] = Variable<String>(breakfastDesc.value);
    }
    if (hadLunch.present) {
      map['had_lunch'] = Variable<bool>(hadLunch.value);
    }
    if (hadDinner.present) {
      map['had_dinner'] = Variable<bool>(hadDinner.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('hadBreakfast: $hadBreakfast, ')
          ..write('breakfastPrice: $breakfastPrice, ')
          ..write('breakfastDesc: $breakfastDesc, ')
          ..write('hadLunch: $hadLunch, ')
          ..write('hadDinner: $hadDinner')
          ..write(')'))
        .toString();
  }
}

class $SnackEntriesTable extends SnackEntries
    with TableInfo<$SnackEntriesTable, SnackEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnackEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, description, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snack_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SnackEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnackEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnackEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
    );
  }

  @override
  $SnackEntriesTable createAlias(String alias) {
    return $SnackEntriesTable(attachedDatabase, alias);
  }
}

class SnackEntry extends DataClass implements Insertable<SnackEntry> {
  final int id;
  final String date;
  final String? description;
  final double price;
  const SnackEntry({
    required this.id,
    required this.date,
    this.description,
    required this.price,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price'] = Variable<double>(price);
    return map;
  }

  SnackEntriesCompanion toCompanion(bool nullToAbsent) {
    return SnackEntriesCompanion(
      id: Value(id),
      date: Value(date),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      price: Value(price),
    );
  }

  factory SnackEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnackEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      description: serializer.fromJson<String?>(json['description']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'description': serializer.toJson<String?>(description),
      'price': serializer.toJson<double>(price),
    };
  }

  SnackEntry copyWith({
    int? id,
    String? date,
    Value<String?> description = const Value.absent(),
    double? price,
  }) => SnackEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    description: description.present ? description.value : this.description,
    price: price ?? this.price,
  );
  SnackEntry copyWithCompanion(SnackEntriesCompanion data) {
    return SnackEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      description: data.description.present
          ? data.description.value
          : this.description,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnackEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, description, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnackEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.description == this.description &&
          other.price == this.price);
}

class SnackEntriesCompanion extends UpdateCompanion<SnackEntry> {
  final Value<int> id;
  final Value<String> date;
  final Value<String?> description;
  final Value<double> price;
  const SnackEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
  });
  SnackEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    this.description = const Value.absent(),
    required double price,
  }) : date = Value(date),
       price = Value(price);
  static Insertable<SnackEntry> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? description,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
    });
  }

  SnackEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<String?>? description,
    Value<double>? price,
  }) {
    return SnackEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnackEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, amount, date, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final double amount;
  final String date;
  final String? note;
  const Payment({
    required this.id,
    required this.amount,
    required this.date,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      amount: Value(amount),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<String>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<String>(date),
      'note': serializer.toJson<String?>(note),
    };
  }

  Payment copyWith({
    int? id,
    double? amount,
    String? date,
    Value<String?> note = const Value.absent(),
  }) => Payment(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, date, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.note == this.note);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> date;
  final Value<String?> note;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String date,
    this.note = const Value.absent(),
  }) : amount = Value(amount),
       date = Value(date);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? date,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<String>? date,
    Value<String?>? note,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  late final $SnackEntriesTable snackEntries = $SnackEntriesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyLogs,
    snackEntries,
    payments,
    settings,
  ];
}

typedef $$DailyLogsTableCreateCompanionBuilder = DailyLogsCompanion Function({
  Value<int> id,
  required String date,
  Value<bool> hadBreakfast,
  Value<double> breakfastPrice,
  Value<String?> breakfastDesc,
  Value<bool> hadLunch,
  Value<bool> hadDinner,
});
typedef $$DailyLogsTableUpdateCompanionBuilder = DailyLogsCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<bool> hadBreakfast,
  Value<double> breakfastPrice,
  Value<String?> breakfastDesc,
  Value<bool> hadLunch,
  Value<bool> hadDinner,
});

class $$DailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hadBreakfast => $composableBuilder(
    column: $table.hadBreakfast,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get breakfastPrice => $composableBuilder(
    column: $table.breakfastPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breakfastDesc => $composableBuilder(
    column: $table.breakfastDesc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hadLunch => $composableBuilder(
    column: $table.hadLunch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hadDinner => $composableBuilder(
    column: $table.hadDinner,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hadBreakfast => $composableBuilder(
    column: $table.hadBreakfast,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get breakfastPrice => $composableBuilder(
    column: $table.breakfastPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breakfastDesc => $composableBuilder(
    column: $table.breakfastDesc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hadLunch => $composableBuilder(
    column: $table.hadLunch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hadDinner => $composableBuilder(
    column: $table.hadDinner,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get hadBreakfast => $composableBuilder(
    column: $table.hadBreakfast,
    builder: (column) => column,
  );

  GeneratedColumn<double> get breakfastPrice => $composableBuilder(
    column: $table.breakfastPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get breakfastDesc => $composableBuilder(
    column: $table.breakfastDesc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hadLunch =>
      $composableBuilder(column: $table.hadLunch, builder: (column) => column);

  GeneratedColumn<bool> get hadDinner =>
      $composableBuilder(column: $table.hadDinner, builder: (column) => column);
}

class $$DailyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyLogsTable,
          DailyLog,
          $$DailyLogsTableFilterComposer,
          $$DailyLogsTableOrderingComposer,
          $$DailyLogsTableAnnotationComposer,
          $$DailyLogsTableCreateCompanionBuilder,
          $$DailyLogsTableUpdateCompanionBuilder,
          (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
          DailyLog,
          PrefetchHooks Function()
        > {
  $$DailyLogsTableTableManager(_$AppDatabase db, $DailyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<bool> hadBreakfast = const Value.absent(),
                Value<double> breakfastPrice = const Value.absent(),
                Value<String?> breakfastDesc = const Value.absent(),
                Value<bool> hadLunch = const Value.absent(),
                Value<bool> hadDinner = const Value.absent(),
              }) => DailyLogsCompanion(
                id: id,
                date: date,
                hadBreakfast: hadBreakfast,
                breakfastPrice: breakfastPrice,
                breakfastDesc: breakfastDesc,
                hadLunch: hadLunch,
                hadDinner: hadDinner,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                Value<bool> hadBreakfast = const Value.absent(),
                Value<double> breakfastPrice = const Value.absent(),
                Value<String?> breakfastDesc = const Value.absent(),
                Value<bool> hadLunch = const Value.absent(),
                Value<bool> hadDinner = const Value.absent(),
              }) => DailyLogsCompanion.insert(
                id: id,
                date: date,
                hadBreakfast: hadBreakfast,
                breakfastPrice: breakfastPrice,
                breakfastDesc: breakfastDesc,
                hadLunch: hadLunch,
                hadDinner: hadDinner,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyLogsTable, DailyLog>(table),
                  BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyLogsTable,
      DailyLog,
      $$DailyLogsTableFilterComposer,
      $$DailyLogsTableOrderingComposer,
      $$DailyLogsTableAnnotationComposer,
      $$DailyLogsTableCreateCompanionBuilder,
      $$DailyLogsTableUpdateCompanionBuilder,
      (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
      DailyLog,
      PrefetchHooks Function()
    >;
typedef $$SnackEntriesTableCreateCompanionBuilder =
    SnackEntriesCompanion Function({
      Value<int> id,
      required String date,
      Value<String?> description,
      required double price,
    });
typedef $$SnackEntriesTableUpdateCompanionBuilder =
    SnackEntriesCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<String?> description,
      Value<double> price,
    });

class $$SnackEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SnackEntriesTable> {
  $$SnackEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SnackEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SnackEntriesTable> {
  $$SnackEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SnackEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnackEntriesTable> {
  $$SnackEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);
}

class $$SnackEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnackEntriesTable,
          SnackEntry,
          $$SnackEntriesTableFilterComposer,
          $$SnackEntriesTableOrderingComposer,
          $$SnackEntriesTableAnnotationComposer,
          $$SnackEntriesTableCreateCompanionBuilder,
          $$SnackEntriesTableUpdateCompanionBuilder,
          (
            SnackEntry,
            BaseReferences<_$AppDatabase, $SnackEntriesTable, SnackEntry>,
          ),
          SnackEntry,
          PrefetchHooks Function()
        > {
  $$SnackEntriesTableTableManager(_$AppDatabase db, $SnackEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnackEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnackEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnackEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> price = const Value.absent(),
              }) => SnackEntriesCompanion(
                id: id,
                date: date,
                description: description,
                price: price,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                Value<String?> description = const Value.absent(),
                required double price,
              }) => SnackEntriesCompanion.insert(
                id: id,
                date: date,
                description: description,
                price: price,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SnackEntriesTable, SnackEntry>(table),
                  BaseReferences<_$AppDatabase, $SnackEntriesTable, SnackEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SnackEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnackEntriesTable,
      SnackEntry,
      $$SnackEntriesTableFilterComposer,
      $$SnackEntriesTableOrderingComposer,
      $$SnackEntriesTableAnnotationComposer,
      $$SnackEntriesTableCreateCompanionBuilder,
      $$SnackEntriesTableUpdateCompanionBuilder,
      (
        SnackEntry,
        BaseReferences<_$AppDatabase, $SnackEntriesTable, SnackEntry>,
      ),
      SnackEntry,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  required double amount,
  required String date,
  Value<String?> note,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<String> date,
  Value<String?> note,
});

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
          Payment,
          PrefetchHooks Function()
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                amount: amount,
                date: date,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required String date,
                Value<String?> note = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                amount: amount,
                date: date,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentsTable, Payment>(table),
                  BaseReferences<_$AppDatabase, $PaymentsTable, Payment>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
      Payment,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
  $$SnackEntriesTableTableManager get snackEntries =>
      $$SnackEntriesTableTableManager(_db, _db.snackEntries);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
