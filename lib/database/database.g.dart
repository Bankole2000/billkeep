// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
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
  static const VerificationMeta _budgetAmountMeta = const VerificationMeta(
    'budgetAmount',
  );
  @override
  late final GeneratedColumn<int> budgetAmount = GeneratedColumn<int>(
    'budget_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetTypeMeta = const VerificationMeta(
    'budgetType',
  );
  @override
  late final GeneratedColumn<String> budgetType = GeneratedColumn<String>(
    'budget_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetFrequencyMeta = const VerificationMeta(
    'budgetFrequency',
  );
  @override
  late final GeneratedColumn<String> budgetFrequency = GeneratedColumn<String>(
    'budget_frequency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    budgetAmount,
    budgetType,
    budgetFrequency,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('budget_amount')) {
      context.handle(
        _budgetAmountMeta,
        budgetAmount.isAcceptableOrUnknown(
          data['budget_amount']!,
          _budgetAmountMeta,
        ),
      );
    }
    if (data.containsKey('budget_type')) {
      context.handle(
        _budgetTypeMeta,
        budgetType.isAcceptableOrUnknown(data['budget_type']!, _budgetTypeMeta),
      );
    }
    if (data.containsKey('budget_frequency')) {
      context.handle(
        _budgetFrequencyMeta,
        budgetFrequency.isAcceptableOrUnknown(
          data['budget_frequency']!,
          _budgetFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      budgetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_amount'],
      ),
      budgetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_type'],
      ),
      budgetFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_frequency'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String? description;
  final int? budgetAmount;
  final String? budgetType;
  final String? budgetFrequency;
  final bool isSynced;
  final String? tempId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  const Project({
    required this.id,
    required this.name,
    this.description,
    this.budgetAmount,
    this.budgetType,
    this.budgetFrequency,
    required this.isSynced,
    this.tempId,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || budgetAmount != null) {
      map['budget_amount'] = Variable<int>(budgetAmount);
    }
    if (!nullToAbsent || budgetType != null) {
      map['budget_type'] = Variable<String>(budgetType);
    }
    if (!nullToAbsent || budgetFrequency != null) {
      map['budget_frequency'] = Variable<String>(budgetFrequency);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || tempId != null) {
      map['temp_id'] = Variable<String>(tempId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      budgetAmount: budgetAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetAmount),
      budgetType: budgetType == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetType),
      budgetFrequency: budgetFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetFrequency),
      isSynced: Value(isSynced),
      tempId: tempId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      budgetAmount: serializer.fromJson<int?>(json['budgetAmount']),
      budgetType: serializer.fromJson<String?>(json['budgetType']),
      budgetFrequency: serializer.fromJson<String?>(json['budgetFrequency']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      tempId: serializer.fromJson<String?>(json['tempId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'budgetAmount': serializer.toJson<int?>(budgetAmount),
      'budgetType': serializer.toJson<String?>(budgetType),
      'budgetFrequency': serializer.toJson<String?>(budgetFrequency),
      'isSynced': serializer.toJson<bool>(isSynced),
      'tempId': serializer.toJson<String?>(tempId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<int?> budgetAmount = const Value.absent(),
    Value<String?> budgetType = const Value.absent(),
    Value<String?> budgetFrequency = const Value.absent(),
    bool? isSynced,
    Value<String?> tempId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    budgetAmount: budgetAmount.present ? budgetAmount.value : this.budgetAmount,
    budgetType: budgetType.present ? budgetType.value : this.budgetType,
    budgetFrequency: budgetFrequency.present
        ? budgetFrequency.value
        : this.budgetFrequency,
    isSynced: isSynced ?? this.isSynced,
    tempId: tempId.present ? tempId.value : this.tempId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isArchived: isArchived ?? this.isArchived,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      budgetAmount: data.budgetAmount.present
          ? data.budgetAmount.value
          : this.budgetAmount,
      budgetType: data.budgetType.present
          ? data.budgetType.value
          : this.budgetType,
      budgetFrequency: data.budgetFrequency.present
          ? data.budgetFrequency.value
          : this.budgetFrequency,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('budgetAmount: $budgetAmount, ')
          ..write('budgetType: $budgetType, ')
          ..write('budgetFrequency: $budgetFrequency, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    budgetAmount,
    budgetType,
    budgetFrequency,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.budgetAmount == this.budgetAmount &&
          other.budgetType == this.budgetType &&
          other.budgetFrequency == this.budgetFrequency &&
          other.isSynced == this.isSynced &&
          other.tempId == this.tempId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int?> budgetAmount;
  final Value<String?> budgetType;
  final Value<String?> budgetFrequency;
  final Value<bool> isSynced;
  final Value<String?> tempId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.budgetAmount = const Value.absent(),
    this.budgetType = const Value.absent(),
    this.budgetFrequency = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.budgetAmount = const Value.absent(),
    this.budgetType = const Value.absent(),
    this.budgetFrequency = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? budgetAmount,
    Expression<String>? budgetType,
    Expression<String>? budgetFrequency,
    Expression<bool>? isSynced,
    Expression<String>? tempId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (budgetAmount != null) 'budget_amount': budgetAmount,
      if (budgetType != null) 'budget_type': budgetType,
      if (budgetFrequency != null) 'budget_frequency': budgetFrequency,
      if (isSynced != null) 'is_synced': isSynced,
      if (tempId != null) 'temp_id': tempId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int?>? budgetAmount,
    Value<String?>? budgetType,
    Value<String?>? budgetFrequency,
    Value<bool>? isSynced,
    Value<String?>? tempId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      budgetType: budgetType ?? this.budgetType,
      budgetFrequency: budgetFrequency ?? this.budgetFrequency,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (budgetAmount.present) {
      map['budget_amount'] = Variable<int>(budgetAmount.value);
    }
    if (budgetType.present) {
      map['budget_type'] = Variable<String>(budgetType.value);
    }
    if (budgetFrequency.present) {
      map['budget_frequency'] = Variable<String>(budgetFrequency.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('budgetAmount: $budgetAmount, ')
          ..write('budgetType: $budgetType, ')
          ..write('budgetFrequency: $budgetFrequency, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES projects(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedAmountMeta = const VerificationMeta(
    'expectedAmount',
  );
  @override
  late final GeneratedColumn<int> expectedAmount = GeneratedColumn<int>(
    'expected_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextRenewalDateMeta = const VerificationMeta(
    'nextRenewalDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextRenewalDate =
      GeneratedColumn<DateTime>(
        'next_renewal_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    expectedAmount,
    currency,
    type,
    frequency,
    startDate,
    nextRenewalDate,
    categoryId,
    notes,
    isActive,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('expected_amount')) {
      context.handle(
        _expectedAmountMeta,
        expectedAmount.isAcceptableOrUnknown(
          data['expected_amount']!,
          _expectedAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedAmountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_renewal_date')) {
      context.handle(
        _nextRenewalDateMeta,
        nextRenewalDate.isAcceptableOrUnknown(
          data['next_renewal_date']!,
          _nextRenewalDateMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      expectedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      nextRenewalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_renewal_date'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final String projectId;
  final String name;
  final int expectedAmount;
  final String currency;
  final String type;
  final String? frequency;
  final DateTime startDate;
  final DateTime? nextRenewalDate;
  final String? categoryId;
  final String? notes;
  final bool isActive;
  final bool isSynced;
  final String? tempId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Expense({
    required this.id,
    required this.projectId,
    required this.name,
    required this.expectedAmount,
    required this.currency,
    required this.type,
    this.frequency,
    required this.startDate,
    this.nextRenewalDate,
    this.categoryId,
    this.notes,
    required this.isActive,
    required this.isSynced,
    this.tempId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    map['expected_amount'] = Variable<int>(expectedAmount);
    map['currency'] = Variable<String>(currency);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || frequency != null) {
      map['frequency'] = Variable<String>(frequency);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || nextRenewalDate != null) {
      map['next_renewal_date'] = Variable<DateTime>(nextRenewalDate);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || tempId != null) {
      map['temp_id'] = Variable<String>(tempId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      expectedAmount: Value(expectedAmount),
      currency: Value(currency),
      type: Value(type),
      frequency: frequency == null && nullToAbsent
          ? const Value.absent()
          : Value(frequency),
      startDate: Value(startDate),
      nextRenewalDate: nextRenewalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRenewalDate),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
      tempId: tempId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      expectedAmount: serializer.fromJson<int>(json['expectedAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      type: serializer.fromJson<String>(json['type']),
      frequency: serializer.fromJson<String?>(json['frequency']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextRenewalDate: serializer.fromJson<DateTime?>(json['nextRenewalDate']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      tempId: serializer.fromJson<String?>(json['tempId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'expectedAmount': serializer.toJson<int>(expectedAmount),
      'currency': serializer.toJson<String>(currency),
      'type': serializer.toJson<String>(type),
      'frequency': serializer.toJson<String?>(frequency),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextRenewalDate': serializer.toJson<DateTime?>(nextRenewalDate),
      'categoryId': serializer.toJson<String?>(categoryId),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'isSynced': serializer.toJson<bool>(isSynced),
      'tempId': serializer.toJson<String?>(tempId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Expense copyWith({
    String? id,
    String? projectId,
    String? name,
    int? expectedAmount,
    String? currency,
    String? type,
    Value<String?> frequency = const Value.absent(),
    DateTime? startDate,
    Value<DateTime?> nextRenewalDate = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    bool? isSynced,
    Value<String?> tempId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Expense(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    expectedAmount: expectedAmount ?? this.expectedAmount,
    currency: currency ?? this.currency,
    type: type ?? this.type,
    frequency: frequency.present ? frequency.value : this.frequency,
    startDate: startDate ?? this.startDate,
    nextRenewalDate: nextRenewalDate.present
        ? nextRenewalDate.value
        : this.nextRenewalDate,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    isSynced: isSynced ?? this.isSynced,
    tempId: tempId.present ? tempId.value : this.tempId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      expectedAmount: data.expectedAmount.present
          ? data.expectedAmount.value
          : this.expectedAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      type: data.type.present ? data.type.value : this.type,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextRenewalDate: data.nextRenewalDate.present
          ? data.nextRenewalDate.value
          : this.nextRenewalDate,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('currency: $currency, ')
          ..write('type: $type, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextRenewalDate: $nextRenewalDate, ')
          ..write('categoryId: $categoryId, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    name,
    expectedAmount,
    currency,
    type,
    frequency,
    startDate,
    nextRenewalDate,
    categoryId,
    notes,
    isActive,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.expectedAmount == this.expectedAmount &&
          other.currency == this.currency &&
          other.type == this.type &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.nextRenewalDate == this.nextRenewalDate &&
          other.categoryId == this.categoryId &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.isSynced == this.isSynced &&
          other.tempId == this.tempId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<int> expectedAmount;
  final Value<String> currency;
  final Value<String> type;
  final Value<String?> frequency;
  final Value<DateTime> startDate;
  final Value<DateTime?> nextRenewalDate;
  final Value<String?> categoryId;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<bool> isSynced;
  final Value<String?> tempId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.expectedAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.type = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextRenewalDate = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String projectId,
    required String name,
    required int expectedAmount,
    this.currency = const Value.absent(),
    required String type,
    this.frequency = const Value.absent(),
    required DateTime startDate,
    this.nextRenewalDate = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       name = Value(name),
       expectedAmount = Value(expectedAmount),
       type = Value(type),
       startDate = Value(startDate);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<int>? expectedAmount,
    Expression<String>? currency,
    Expression<String>? type,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextRenewalDate,
    Expression<String>? categoryId,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<bool>? isSynced,
    Expression<String>? tempId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (expectedAmount != null) 'expected_amount': expectedAmount,
      if (currency != null) 'currency': currency,
      if (type != null) 'type': type,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (nextRenewalDate != null) 'next_renewal_date': nextRenewalDate,
      if (categoryId != null) 'category_id': categoryId,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (isSynced != null) 'is_synced': isSynced,
      if (tempId != null) 'temp_id': tempId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? name,
    Value<int>? expectedAmount,
    Value<String>? currency,
    Value<String>? type,
    Value<String?>? frequency,
    Value<DateTime>? startDate,
    Value<DateTime?>? nextRenewalDate,
    Value<String?>? categoryId,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<bool>? isSynced,
    Value<String?>? tempId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      expectedAmount: expectedAmount ?? this.expectedAmount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextRenewalDate: nextRenewalDate ?? this.nextRenewalDate,
      categoryId: categoryId ?? this.categoryId,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (expectedAmount.present) {
      map['expected_amount'] = Variable<int>(expectedAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextRenewalDate.present) {
      map['next_renewal_date'] = Variable<DateTime>(nextRenewalDate.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('currency: $currency, ')
          ..write('type: $type, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextRenewalDate: $nextRenewalDate, ')
          ..write('categoryId: $categoryId, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<String> expenseId = GeneratedColumn<String>(
    'expense_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _incomeIdMeta = const VerificationMeta(
    'incomeId',
  );
  @override
  late final GeneratedColumn<String> incomeId = GeneratedColumn<String>(
    'income_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualAmountMeta = const VerificationMeta(
    'actualAmount',
  );
  @override
  late final GeneratedColumn<int> actualAmount = GeneratedColumn<int>(
    'actual_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('MANUAL'),
  );
  static const VerificationMeta _verifiedMeta = const VerificationMeta(
    'verified',
  );
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
    'verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("verified" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    paymentType,
    expenseId,
    incomeId,
    actualAmount,
    currency,
    paymentDate,
    source,
    verified,
    notes,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  ];
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
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentTypeMeta);
    }
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    }
    if (data.containsKey('income_id')) {
      context.handle(
        _incomeIdMeta,
        incomeId.isAcceptableOrUnknown(data['income_id']!, _incomeIdMeta),
      );
    }
    if (data.containsKey('actual_amount')) {
      context.handle(
        _actualAmountMeta,
        actualAmount.isAcceptableOrUnknown(
          data['actual_amount']!,
          _actualAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualAmountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('verified')) {
      context.handle(
        _verifiedMeta,
        verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      paymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_type'],
      )!,
      expenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expense_id'],
      ),
      incomeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}income_id'],
      ),
      actualAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      verified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}verified'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final String paymentType;
  final String? expenseId;
  final String? incomeId;
  final int actualAmount;
  final String currency;
  final DateTime paymentDate;
  final String source;
  final bool verified;
  final String? notes;
  final bool isSynced;
  final String? tempId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Payment({
    required this.id,
    required this.paymentType,
    this.expenseId,
    this.incomeId,
    required this.actualAmount,
    required this.currency,
    required this.paymentDate,
    required this.source,
    required this.verified,
    this.notes,
    required this.isSynced,
    this.tempId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payment_type'] = Variable<String>(paymentType);
    if (!nullToAbsent || expenseId != null) {
      map['expense_id'] = Variable<String>(expenseId);
    }
    if (!nullToAbsent || incomeId != null) {
      map['income_id'] = Variable<String>(incomeId);
    }
    map['actual_amount'] = Variable<int>(actualAmount);
    map['currency'] = Variable<String>(currency);
    map['payment_date'] = Variable<DateTime>(paymentDate);
    map['source'] = Variable<String>(source);
    map['verified'] = Variable<bool>(verified);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || tempId != null) {
      map['temp_id'] = Variable<String>(tempId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      paymentType: Value(paymentType),
      expenseId: expenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseId),
      incomeId: incomeId == null && nullToAbsent
          ? const Value.absent()
          : Value(incomeId),
      actualAmount: Value(actualAmount),
      currency: Value(currency),
      paymentDate: Value(paymentDate),
      source: Value(source),
      verified: Value(verified),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSynced: Value(isSynced),
      tempId: tempId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      expenseId: serializer.fromJson<String?>(json['expenseId']),
      incomeId: serializer.fromJson<String?>(json['incomeId']),
      actualAmount: serializer.fromJson<int>(json['actualAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      source: serializer.fromJson<String>(json['source']),
      verified: serializer.fromJson<bool>(json['verified']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      tempId: serializer.fromJson<String?>(json['tempId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'paymentType': serializer.toJson<String>(paymentType),
      'expenseId': serializer.toJson<String?>(expenseId),
      'incomeId': serializer.toJson<String?>(incomeId),
      'actualAmount': serializer.toJson<int>(actualAmount),
      'currency': serializer.toJson<String>(currency),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'source': serializer.toJson<String>(source),
      'verified': serializer.toJson<bool>(verified),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
      'tempId': serializer.toJson<String?>(tempId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Payment copyWith({
    String? id,
    String? paymentType,
    Value<String?> expenseId = const Value.absent(),
    Value<String?> incomeId = const Value.absent(),
    int? actualAmount,
    String? currency,
    DateTime? paymentDate,
    String? source,
    bool? verified,
    Value<String?> notes = const Value.absent(),
    bool? isSynced,
    Value<String?> tempId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Payment(
    id: id ?? this.id,
    paymentType: paymentType ?? this.paymentType,
    expenseId: expenseId.present ? expenseId.value : this.expenseId,
    incomeId: incomeId.present ? incomeId.value : this.incomeId,
    actualAmount: actualAmount ?? this.actualAmount,
    currency: currency ?? this.currency,
    paymentDate: paymentDate ?? this.paymentDate,
    source: source ?? this.source,
    verified: verified ?? this.verified,
    notes: notes.present ? notes.value : this.notes,
    isSynced: isSynced ?? this.isSynced,
    tempId: tempId.present ? tempId.value : this.tempId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      incomeId: data.incomeId.present ? data.incomeId.value : this.incomeId,
      actualAmount: data.actualAmount.present
          ? data.actualAmount.value
          : this.actualAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      source: data.source.present ? data.source.value : this.source,
      verified: data.verified.present ? data.verified.value : this.verified,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('paymentType: $paymentType, ')
          ..write('expenseId: $expenseId, ')
          ..write('incomeId: $incomeId, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('currency: $currency, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('source: $source, ')
          ..write('verified: $verified, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    paymentType,
    expenseId,
    incomeId,
    actualAmount,
    currency,
    paymentDate,
    source,
    verified,
    notes,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.paymentType == this.paymentType &&
          other.expenseId == this.expenseId &&
          other.incomeId == this.incomeId &&
          other.actualAmount == this.actualAmount &&
          other.currency == this.currency &&
          other.paymentDate == this.paymentDate &&
          other.source == this.source &&
          other.verified == this.verified &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced &&
          other.tempId == this.tempId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String> paymentType;
  final Value<String?> expenseId;
  final Value<String?> incomeId;
  final Value<int> actualAmount;
  final Value<String> currency;
  final Value<DateTime> paymentDate;
  final Value<String> source;
  final Value<bool> verified;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<String?> tempId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.incomeId = const Value.absent(),
    this.actualAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.source = const Value.absent(),
    this.verified = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required String paymentType,
    this.expenseId = const Value.absent(),
    this.incomeId = const Value.absent(),
    required int actualAmount,
    this.currency = const Value.absent(),
    required DateTime paymentDate,
    this.source = const Value.absent(),
    this.verified = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       paymentType = Value(paymentType),
       actualAmount = Value(actualAmount),
       paymentDate = Value(paymentDate);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? paymentType,
    Expression<String>? expenseId,
    Expression<String>? incomeId,
    Expression<int>? actualAmount,
    Expression<String>? currency,
    Expression<DateTime>? paymentDate,
    Expression<String>? source,
    Expression<bool>? verified,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<String>? tempId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentType != null) 'payment_type': paymentType,
      if (expenseId != null) 'expense_id': expenseId,
      if (incomeId != null) 'income_id': incomeId,
      if (actualAmount != null) 'actual_amount': actualAmount,
      if (currency != null) 'currency': currency,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (source != null) 'source': source,
      if (verified != null) 'verified': verified,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (tempId != null) 'temp_id': tempId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? paymentType,
    Value<String?>? expenseId,
    Value<String?>? incomeId,
    Value<int>? actualAmount,
    Value<String>? currency,
    Value<DateTime>? paymentDate,
    Value<String>? source,
    Value<bool>? verified,
    Value<String?>? notes,
    Value<bool>? isSynced,
    Value<String?>? tempId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      paymentType: paymentType ?? this.paymentType,
      expenseId: expenseId ?? this.expenseId,
      incomeId: incomeId ?? this.incomeId,
      actualAmount: actualAmount ?? this.actualAmount,
      currency: currency ?? this.currency,
      paymentDate: paymentDate ?? this.paymentDate,
      source: source ?? this.source,
      verified: verified ?? this.verified,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<String>(expenseId.value);
    }
    if (incomeId.present) {
      map['income_id'] = Variable<String>(incomeId.value);
    }
    if (actualAmount.present) {
      map['actual_amount'] = Variable<int>(actualAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('paymentType: $paymentType, ')
          ..write('expenseId: $expenseId, ')
          ..write('incomeId: $incomeId, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('currency: $currency, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('source: $source, ')
          ..write('verified: $verified, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeTable extends Income with TableInfo<$IncomeTable, IncomeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES projects(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedAmountMeta = const VerificationMeta(
    'expectedAmount',
  );
  @override
  late final GeneratedColumn<int> expectedAmount = GeneratedColumn<int>(
    'expected_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextExpectedDateMeta = const VerificationMeta(
    'nextExpectedDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextExpectedDate =
      GeneratedColumn<DateTime>(
        'next_expected_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    description,
    expectedAmount,
    currency,
    type,
    frequency,
    startDate,
    nextExpectedDate,
    categoryId,
    invoiceNumber,
    notes,
    isActive,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('expected_amount')) {
      context.handle(
        _expectedAmountMeta,
        expectedAmount.isAcceptableOrUnknown(
          data['expected_amount']!,
          _expectedAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedAmountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_expected_date')) {
      context.handle(
        _nextExpectedDateMeta,
        nextExpectedDate.isAcceptableOrUnknown(
          data['next_expected_date']!,
          _nextExpectedDateMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      expectedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      nextExpectedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_expected_date'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $IncomeTable createAlias(String alias) {
    return $IncomeTable(attachedDatabase, alias);
  }
}

class IncomeData extends DataClass implements Insertable<IncomeData> {
  final String id;
  final String projectId;
  final String description;
  final int expectedAmount;
  final String currency;
  final String type;
  final String? frequency;
  final DateTime startDate;
  final DateTime? nextExpectedDate;
  final String? categoryId;
  final String? invoiceNumber;
  final String? notes;
  final bool isActive;
  final bool isSynced;
  final String? tempId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IncomeData({
    required this.id,
    required this.projectId,
    required this.description,
    required this.expectedAmount,
    required this.currency,
    required this.type,
    this.frequency,
    required this.startDate,
    this.nextExpectedDate,
    this.categoryId,
    this.invoiceNumber,
    this.notes,
    required this.isActive,
    required this.isSynced,
    this.tempId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['description'] = Variable<String>(description);
    map['expected_amount'] = Variable<int>(expectedAmount);
    map['currency'] = Variable<String>(currency);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || frequency != null) {
      map['frequency'] = Variable<String>(frequency);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || nextExpectedDate != null) {
      map['next_expected_date'] = Variable<DateTime>(nextExpectedDate);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<String>(invoiceNumber);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || tempId != null) {
      map['temp_id'] = Variable<String>(tempId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IncomeCompanion toCompanion(bool nullToAbsent) {
    return IncomeCompanion(
      id: Value(id),
      projectId: Value(projectId),
      description: Value(description),
      expectedAmount: Value(expectedAmount),
      currency: Value(currency),
      type: Value(type),
      frequency: frequency == null && nullToAbsent
          ? const Value.absent()
          : Value(frequency),
      startDate: Value(startDate),
      nextExpectedDate: nextExpectedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextExpectedDate),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
      tempId: tempId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IncomeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeData(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      description: serializer.fromJson<String>(json['description']),
      expectedAmount: serializer.fromJson<int>(json['expectedAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      type: serializer.fromJson<String>(json['type']),
      frequency: serializer.fromJson<String?>(json['frequency']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextExpectedDate: serializer.fromJson<DateTime?>(
        json['nextExpectedDate'],
      ),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      invoiceNumber: serializer.fromJson<String?>(json['invoiceNumber']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      tempId: serializer.fromJson<String?>(json['tempId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'description': serializer.toJson<String>(description),
      'expectedAmount': serializer.toJson<int>(expectedAmount),
      'currency': serializer.toJson<String>(currency),
      'type': serializer.toJson<String>(type),
      'frequency': serializer.toJson<String?>(frequency),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextExpectedDate': serializer.toJson<DateTime?>(nextExpectedDate),
      'categoryId': serializer.toJson<String?>(categoryId),
      'invoiceNumber': serializer.toJson<String?>(invoiceNumber),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'isSynced': serializer.toJson<bool>(isSynced),
      'tempId': serializer.toJson<String?>(tempId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IncomeData copyWith({
    String? id,
    String? projectId,
    String? description,
    int? expectedAmount,
    String? currency,
    String? type,
    Value<String?> frequency = const Value.absent(),
    DateTime? startDate,
    Value<DateTime?> nextExpectedDate = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> invoiceNumber = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    bool? isSynced,
    Value<String?> tempId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => IncomeData(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    description: description ?? this.description,
    expectedAmount: expectedAmount ?? this.expectedAmount,
    currency: currency ?? this.currency,
    type: type ?? this.type,
    frequency: frequency.present ? frequency.value : this.frequency,
    startDate: startDate ?? this.startDate,
    nextExpectedDate: nextExpectedDate.present
        ? nextExpectedDate.value
        : this.nextExpectedDate,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    invoiceNumber: invoiceNumber.present
        ? invoiceNumber.value
        : this.invoiceNumber,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    isSynced: isSynced ?? this.isSynced,
    tempId: tempId.present ? tempId.value : this.tempId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  IncomeData copyWithCompanion(IncomeCompanion data) {
    return IncomeData(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      description: data.description.present
          ? data.description.value
          : this.description,
      expectedAmount: data.expectedAmount.present
          ? data.expectedAmount.value
          : this.expectedAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      type: data.type.present ? data.type.value : this.type,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextExpectedDate: data.nextExpectedDate.present
          ? data.nextExpectedDate.value
          : this.nextExpectedDate,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeData(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('description: $description, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('currency: $currency, ')
          ..write('type: $type, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextExpectedDate: $nextExpectedDate, ')
          ..write('categoryId: $categoryId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    description,
    expectedAmount,
    currency,
    type,
    frequency,
    startDate,
    nextExpectedDate,
    categoryId,
    invoiceNumber,
    notes,
    isActive,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeData &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.description == this.description &&
          other.expectedAmount == this.expectedAmount &&
          other.currency == this.currency &&
          other.type == this.type &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.nextExpectedDate == this.nextExpectedDate &&
          other.categoryId == this.categoryId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.isSynced == this.isSynced &&
          other.tempId == this.tempId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IncomeCompanion extends UpdateCompanion<IncomeData> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> description;
  final Value<int> expectedAmount;
  final Value<String> currency;
  final Value<String> type;
  final Value<String?> frequency;
  final Value<DateTime> startDate;
  final Value<DateTime?> nextExpectedDate;
  final Value<String?> categoryId;
  final Value<String?> invoiceNumber;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<bool> isSynced;
  final Value<String?> tempId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const IncomeCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.description = const Value.absent(),
    this.expectedAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.type = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextExpectedDate = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeCompanion.insert({
    required String id,
    required String projectId,
    required String description,
    required int expectedAmount,
    this.currency = const Value.absent(),
    required String type,
    this.frequency = const Value.absent(),
    required DateTime startDate,
    this.nextExpectedDate = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       description = Value(description),
       expectedAmount = Value(expectedAmount),
       type = Value(type),
       startDate = Value(startDate);
  static Insertable<IncomeData> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? description,
    Expression<int>? expectedAmount,
    Expression<String>? currency,
    Expression<String>? type,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextExpectedDate,
    Expression<String>? categoryId,
    Expression<String>? invoiceNumber,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<bool>? isSynced,
    Expression<String>? tempId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (description != null) 'description': description,
      if (expectedAmount != null) 'expected_amount': expectedAmount,
      if (currency != null) 'currency': currency,
      if (type != null) 'type': type,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (nextExpectedDate != null) 'next_expected_date': nextExpectedDate,
      if (categoryId != null) 'category_id': categoryId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (isSynced != null) 'is_synced': isSynced,
      if (tempId != null) 'temp_id': tempId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? description,
    Value<int>? expectedAmount,
    Value<String>? currency,
    Value<String>? type,
    Value<String?>? frequency,
    Value<DateTime>? startDate,
    Value<DateTime?>? nextExpectedDate,
    Value<String?>? categoryId,
    Value<String?>? invoiceNumber,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<bool>? isSynced,
    Value<String?>? tempId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return IncomeCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      description: description ?? this.description,
      expectedAmount: expectedAmount ?? this.expectedAmount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextExpectedDate: nextExpectedDate ?? this.nextExpectedDate,
      categoryId: categoryId ?? this.categoryId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (expectedAmount.present) {
      map['expected_amount'] = Variable<int>(expectedAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextExpectedDate.present) {
      map['next_expected_date'] = Variable<DateTime>(nextExpectedDate.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('description: $description, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('currency: $currency, ')
          ..write('type: $type, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextExpectedDate: $nextExpectedDate, ')
          ..write('categoryId: $categoryId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodoItemsTable extends TodoItems
    with TableInfo<$TodoItemsTable, TodoItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES projects(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _directExpenseAmountMeta =
      const VerificationMeta('directExpenseAmount');
  @override
  late final GeneratedColumn<int> directExpenseAmount = GeneratedColumn<int>(
    'direct_expense_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _directExpenseCurrencyMeta =
      const VerificationMeta('directExpenseCurrency');
  @override
  late final GeneratedColumn<String> directExpenseCurrency =
      GeneratedColumn<String>(
        'direct_expense_currency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _directExpenseTypeMeta = const VerificationMeta(
    'directExpenseType',
  );
  @override
  late final GeneratedColumn<String> directExpenseType =
      GeneratedColumn<String>(
        'direct_expense_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _directExpenseFrequencyMeta =
      const VerificationMeta('directExpenseFrequency');
  @override
  late final GeneratedColumn<String> directExpenseFrequency =
      GeneratedColumn<String>(
        'direct_expense_frequency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _directExpenseDescriptionMeta =
      const VerificationMeta('directExpenseDescription');
  @override
  late final GeneratedColumn<String> directExpenseDescription =
      GeneratedColumn<String>(
        'direct_expense_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdExpenseIdMeta = const VerificationMeta(
    'createdExpenseId',
  );
  @override
  late final GeneratedColumn<String> createdExpenseId = GeneratedColumn<String>(
    'created_expense_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdPaymentIdMeta = const VerificationMeta(
    'createdPaymentId',
  );
  @override
  late final GeneratedColumn<String> createdPaymentId = GeneratedColumn<String>(
    'created_payment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedShoppingListIdMeta =
      const VerificationMeta('linkedShoppingListId');
  @override
  late final GeneratedColumn<String> linkedShoppingListId =
      GeneratedColumn<String>(
        'linked_shopping_list_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _parentTodoIdMeta = const VerificationMeta(
    'parentTodoId',
  );
  @override
  late final GeneratedColumn<String> parentTodoId = GeneratedColumn<String>(
    'parent_todo_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    title,
    description,
    isCompleted,
    completedAt,
    directExpenseAmount,
    directExpenseCurrency,
    directExpenseType,
    directExpenseFrequency,
    directExpenseDescription,
    createdExpenseId,
    createdPaymentId,
    linkedShoppingListId,
    parentTodoId,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('direct_expense_amount')) {
      context.handle(
        _directExpenseAmountMeta,
        directExpenseAmount.isAcceptableOrUnknown(
          data['direct_expense_amount']!,
          _directExpenseAmountMeta,
        ),
      );
    }
    if (data.containsKey('direct_expense_currency')) {
      context.handle(
        _directExpenseCurrencyMeta,
        directExpenseCurrency.isAcceptableOrUnknown(
          data['direct_expense_currency']!,
          _directExpenseCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('direct_expense_type')) {
      context.handle(
        _directExpenseTypeMeta,
        directExpenseType.isAcceptableOrUnknown(
          data['direct_expense_type']!,
          _directExpenseTypeMeta,
        ),
      );
    }
    if (data.containsKey('direct_expense_frequency')) {
      context.handle(
        _directExpenseFrequencyMeta,
        directExpenseFrequency.isAcceptableOrUnknown(
          data['direct_expense_frequency']!,
          _directExpenseFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('direct_expense_description')) {
      context.handle(
        _directExpenseDescriptionMeta,
        directExpenseDescription.isAcceptableOrUnknown(
          data['direct_expense_description']!,
          _directExpenseDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_expense_id')) {
      context.handle(
        _createdExpenseIdMeta,
        createdExpenseId.isAcceptableOrUnknown(
          data['created_expense_id']!,
          _createdExpenseIdMeta,
        ),
      );
    }
    if (data.containsKey('created_payment_id')) {
      context.handle(
        _createdPaymentIdMeta,
        createdPaymentId.isAcceptableOrUnknown(
          data['created_payment_id']!,
          _createdPaymentIdMeta,
        ),
      );
    }
    if (data.containsKey('linked_shopping_list_id')) {
      context.handle(
        _linkedShoppingListIdMeta,
        linkedShoppingListId.isAcceptableOrUnknown(
          data['linked_shopping_list_id']!,
          _linkedShoppingListIdMeta,
        ),
      );
    }
    if (data.containsKey('parent_todo_id')) {
      context.handle(
        _parentTodoIdMeta,
        parentTodoId.isAcceptableOrUnknown(
          data['parent_todo_id']!,
          _parentTodoIdMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      directExpenseAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}direct_expense_amount'],
      ),
      directExpenseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direct_expense_currency'],
      ),
      directExpenseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direct_expense_type'],
      ),
      directExpenseFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direct_expense_frequency'],
      ),
      directExpenseDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direct_expense_description'],
      ),
      createdExpenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_expense_id'],
      ),
      createdPaymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_payment_id'],
      ),
      linkedShoppingListId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_shopping_list_id'],
      ),
      parentTodoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_todo_id'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TodoItemsTable createAlias(String alias) {
    return $TodoItemsTable(attachedDatabase, alias);
  }
}

class TodoItem extends DataClass implements Insertable<TodoItem> {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? completedAt;
  final int? directExpenseAmount;
  final String? directExpenseCurrency;
  final String? directExpenseType;
  final String? directExpenseFrequency;
  final String? directExpenseDescription;
  final String? createdExpenseId;
  final String? createdPaymentId;
  final String? linkedShoppingListId;
  final String? parentTodoId;
  final bool isSynced;
  final String? tempId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TodoItem({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    required this.isCompleted,
    this.completedAt,
    this.directExpenseAmount,
    this.directExpenseCurrency,
    this.directExpenseType,
    this.directExpenseFrequency,
    this.directExpenseDescription,
    this.createdExpenseId,
    this.createdPaymentId,
    this.linkedShoppingListId,
    this.parentTodoId,
    required this.isSynced,
    this.tempId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || directExpenseAmount != null) {
      map['direct_expense_amount'] = Variable<int>(directExpenseAmount);
    }
    if (!nullToAbsent || directExpenseCurrency != null) {
      map['direct_expense_currency'] = Variable<String>(directExpenseCurrency);
    }
    if (!nullToAbsent || directExpenseType != null) {
      map['direct_expense_type'] = Variable<String>(directExpenseType);
    }
    if (!nullToAbsent || directExpenseFrequency != null) {
      map['direct_expense_frequency'] = Variable<String>(
        directExpenseFrequency,
      );
    }
    if (!nullToAbsent || directExpenseDescription != null) {
      map['direct_expense_description'] = Variable<String>(
        directExpenseDescription,
      );
    }
    if (!nullToAbsent || createdExpenseId != null) {
      map['created_expense_id'] = Variable<String>(createdExpenseId);
    }
    if (!nullToAbsent || createdPaymentId != null) {
      map['created_payment_id'] = Variable<String>(createdPaymentId);
    }
    if (!nullToAbsent || linkedShoppingListId != null) {
      map['linked_shopping_list_id'] = Variable<String>(linkedShoppingListId);
    }
    if (!nullToAbsent || parentTodoId != null) {
      map['parent_todo_id'] = Variable<String>(parentTodoId);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || tempId != null) {
      map['temp_id'] = Variable<String>(tempId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TodoItemsCompanion toCompanion(bool nullToAbsent) {
    return TodoItemsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      directExpenseAmount: directExpenseAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(directExpenseAmount),
      directExpenseCurrency: directExpenseCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(directExpenseCurrency),
      directExpenseType: directExpenseType == null && nullToAbsent
          ? const Value.absent()
          : Value(directExpenseType),
      directExpenseFrequency: directExpenseFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(directExpenseFrequency),
      directExpenseDescription: directExpenseDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(directExpenseDescription),
      createdExpenseId: createdExpenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdExpenseId),
      createdPaymentId: createdPaymentId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdPaymentId),
      linkedShoppingListId: linkedShoppingListId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedShoppingListId),
      parentTodoId: parentTodoId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTodoId),
      isSynced: Value(isSynced),
      tempId: tempId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TodoItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoItem(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      directExpenseAmount: serializer.fromJson<int?>(
        json['directExpenseAmount'],
      ),
      directExpenseCurrency: serializer.fromJson<String?>(
        json['directExpenseCurrency'],
      ),
      directExpenseType: serializer.fromJson<String?>(
        json['directExpenseType'],
      ),
      directExpenseFrequency: serializer.fromJson<String?>(
        json['directExpenseFrequency'],
      ),
      directExpenseDescription: serializer.fromJson<String?>(
        json['directExpenseDescription'],
      ),
      createdExpenseId: serializer.fromJson<String?>(json['createdExpenseId']),
      createdPaymentId: serializer.fromJson<String?>(json['createdPaymentId']),
      linkedShoppingListId: serializer.fromJson<String?>(
        json['linkedShoppingListId'],
      ),
      parentTodoId: serializer.fromJson<String?>(json['parentTodoId']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      tempId: serializer.fromJson<String?>(json['tempId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'directExpenseAmount': serializer.toJson<int?>(directExpenseAmount),
      'directExpenseCurrency': serializer.toJson<String?>(
        directExpenseCurrency,
      ),
      'directExpenseType': serializer.toJson<String?>(directExpenseType),
      'directExpenseFrequency': serializer.toJson<String?>(
        directExpenseFrequency,
      ),
      'directExpenseDescription': serializer.toJson<String?>(
        directExpenseDescription,
      ),
      'createdExpenseId': serializer.toJson<String?>(createdExpenseId),
      'createdPaymentId': serializer.toJson<String?>(createdPaymentId),
      'linkedShoppingListId': serializer.toJson<String?>(linkedShoppingListId),
      'parentTodoId': serializer.toJson<String?>(parentTodoId),
      'isSynced': serializer.toJson<bool>(isSynced),
      'tempId': serializer.toJson<String?>(tempId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TodoItem copyWith({
    String? id,
    String? projectId,
    String? title,
    Value<String?> description = const Value.absent(),
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> directExpenseAmount = const Value.absent(),
    Value<String?> directExpenseCurrency = const Value.absent(),
    Value<String?> directExpenseType = const Value.absent(),
    Value<String?> directExpenseFrequency = const Value.absent(),
    Value<String?> directExpenseDescription = const Value.absent(),
    Value<String?> createdExpenseId = const Value.absent(),
    Value<String?> createdPaymentId = const Value.absent(),
    Value<String?> linkedShoppingListId = const Value.absent(),
    Value<String?> parentTodoId = const Value.absent(),
    bool? isSynced,
    Value<String?> tempId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TodoItem(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    directExpenseAmount: directExpenseAmount.present
        ? directExpenseAmount.value
        : this.directExpenseAmount,
    directExpenseCurrency: directExpenseCurrency.present
        ? directExpenseCurrency.value
        : this.directExpenseCurrency,
    directExpenseType: directExpenseType.present
        ? directExpenseType.value
        : this.directExpenseType,
    directExpenseFrequency: directExpenseFrequency.present
        ? directExpenseFrequency.value
        : this.directExpenseFrequency,
    directExpenseDescription: directExpenseDescription.present
        ? directExpenseDescription.value
        : this.directExpenseDescription,
    createdExpenseId: createdExpenseId.present
        ? createdExpenseId.value
        : this.createdExpenseId,
    createdPaymentId: createdPaymentId.present
        ? createdPaymentId.value
        : this.createdPaymentId,
    linkedShoppingListId: linkedShoppingListId.present
        ? linkedShoppingListId.value
        : this.linkedShoppingListId,
    parentTodoId: parentTodoId.present ? parentTodoId.value : this.parentTodoId,
    isSynced: isSynced ?? this.isSynced,
    tempId: tempId.present ? tempId.value : this.tempId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TodoItem copyWithCompanion(TodoItemsCompanion data) {
    return TodoItem(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      directExpenseAmount: data.directExpenseAmount.present
          ? data.directExpenseAmount.value
          : this.directExpenseAmount,
      directExpenseCurrency: data.directExpenseCurrency.present
          ? data.directExpenseCurrency.value
          : this.directExpenseCurrency,
      directExpenseType: data.directExpenseType.present
          ? data.directExpenseType.value
          : this.directExpenseType,
      directExpenseFrequency: data.directExpenseFrequency.present
          ? data.directExpenseFrequency.value
          : this.directExpenseFrequency,
      directExpenseDescription: data.directExpenseDescription.present
          ? data.directExpenseDescription.value
          : this.directExpenseDescription,
      createdExpenseId: data.createdExpenseId.present
          ? data.createdExpenseId.value
          : this.createdExpenseId,
      createdPaymentId: data.createdPaymentId.present
          ? data.createdPaymentId.value
          : this.createdPaymentId,
      linkedShoppingListId: data.linkedShoppingListId.present
          ? data.linkedShoppingListId.value
          : this.linkedShoppingListId,
      parentTodoId: data.parentTodoId.present
          ? data.parentTodoId.value
          : this.parentTodoId,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoItem(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('directExpenseAmount: $directExpenseAmount, ')
          ..write('directExpenseCurrency: $directExpenseCurrency, ')
          ..write('directExpenseType: $directExpenseType, ')
          ..write('directExpenseFrequency: $directExpenseFrequency, ')
          ..write('directExpenseDescription: $directExpenseDescription, ')
          ..write('createdExpenseId: $createdExpenseId, ')
          ..write('createdPaymentId: $createdPaymentId, ')
          ..write('linkedShoppingListId: $linkedShoppingListId, ')
          ..write('parentTodoId: $parentTodoId, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    title,
    description,
    isCompleted,
    completedAt,
    directExpenseAmount,
    directExpenseCurrency,
    directExpenseType,
    directExpenseFrequency,
    directExpenseDescription,
    createdExpenseId,
    createdPaymentId,
    linkedShoppingListId,
    parentTodoId,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoItem &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.description == this.description &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.directExpenseAmount == this.directExpenseAmount &&
          other.directExpenseCurrency == this.directExpenseCurrency &&
          other.directExpenseType == this.directExpenseType &&
          other.directExpenseFrequency == this.directExpenseFrequency &&
          other.directExpenseDescription == this.directExpenseDescription &&
          other.createdExpenseId == this.createdExpenseId &&
          other.createdPaymentId == this.createdPaymentId &&
          other.linkedShoppingListId == this.linkedShoppingListId &&
          other.parentTodoId == this.parentTodoId &&
          other.isSynced == this.isSynced &&
          other.tempId == this.tempId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TodoItemsCompanion extends UpdateCompanion<TodoItem> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> title;
  final Value<String?> description;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<int?> directExpenseAmount;
  final Value<String?> directExpenseCurrency;
  final Value<String?> directExpenseType;
  final Value<String?> directExpenseFrequency;
  final Value<String?> directExpenseDescription;
  final Value<String?> createdExpenseId;
  final Value<String?> createdPaymentId;
  final Value<String?> linkedShoppingListId;
  final Value<String?> parentTodoId;
  final Value<bool> isSynced;
  final Value<String?> tempId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TodoItemsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.directExpenseAmount = const Value.absent(),
    this.directExpenseCurrency = const Value.absent(),
    this.directExpenseType = const Value.absent(),
    this.directExpenseFrequency = const Value.absent(),
    this.directExpenseDescription = const Value.absent(),
    this.createdExpenseId = const Value.absent(),
    this.createdPaymentId = const Value.absent(),
    this.linkedShoppingListId = const Value.absent(),
    this.parentTodoId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodoItemsCompanion.insert({
    required String id,
    required String projectId,
    required String title,
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.directExpenseAmount = const Value.absent(),
    this.directExpenseCurrency = const Value.absent(),
    this.directExpenseType = const Value.absent(),
    this.directExpenseFrequency = const Value.absent(),
    this.directExpenseDescription = const Value.absent(),
    this.createdExpenseId = const Value.absent(),
    this.createdPaymentId = const Value.absent(),
    this.linkedShoppingListId = const Value.absent(),
    this.parentTodoId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       title = Value(title);
  static Insertable<TodoItem> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<int>? directExpenseAmount,
    Expression<String>? directExpenseCurrency,
    Expression<String>? directExpenseType,
    Expression<String>? directExpenseFrequency,
    Expression<String>? directExpenseDescription,
    Expression<String>? createdExpenseId,
    Expression<String>? createdPaymentId,
    Expression<String>? linkedShoppingListId,
    Expression<String>? parentTodoId,
    Expression<bool>? isSynced,
    Expression<String>? tempId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (directExpenseAmount != null)
        'direct_expense_amount': directExpenseAmount,
      if (directExpenseCurrency != null)
        'direct_expense_currency': directExpenseCurrency,
      if (directExpenseType != null) 'direct_expense_type': directExpenseType,
      if (directExpenseFrequency != null)
        'direct_expense_frequency': directExpenseFrequency,
      if (directExpenseDescription != null)
        'direct_expense_description': directExpenseDescription,
      if (createdExpenseId != null) 'created_expense_id': createdExpenseId,
      if (createdPaymentId != null) 'created_payment_id': createdPaymentId,
      if (linkedShoppingListId != null)
        'linked_shopping_list_id': linkedShoppingListId,
      if (parentTodoId != null) 'parent_todo_id': parentTodoId,
      if (isSynced != null) 'is_synced': isSynced,
      if (tempId != null) 'temp_id': tempId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodoItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? title,
    Value<String?>? description,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<int?>? directExpenseAmount,
    Value<String?>? directExpenseCurrency,
    Value<String?>? directExpenseType,
    Value<String?>? directExpenseFrequency,
    Value<String?>? directExpenseDescription,
    Value<String?>? createdExpenseId,
    Value<String?>? createdPaymentId,
    Value<String?>? linkedShoppingListId,
    Value<String?>? parentTodoId,
    Value<bool>? isSynced,
    Value<String?>? tempId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TodoItemsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      directExpenseAmount: directExpenseAmount ?? this.directExpenseAmount,
      directExpenseCurrency:
          directExpenseCurrency ?? this.directExpenseCurrency,
      directExpenseType: directExpenseType ?? this.directExpenseType,
      directExpenseFrequency:
          directExpenseFrequency ?? this.directExpenseFrequency,
      directExpenseDescription:
          directExpenseDescription ?? this.directExpenseDescription,
      createdExpenseId: createdExpenseId ?? this.createdExpenseId,
      createdPaymentId: createdPaymentId ?? this.createdPaymentId,
      linkedShoppingListId: linkedShoppingListId ?? this.linkedShoppingListId,
      parentTodoId: parentTodoId ?? this.parentTodoId,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (directExpenseAmount.present) {
      map['direct_expense_amount'] = Variable<int>(directExpenseAmount.value);
    }
    if (directExpenseCurrency.present) {
      map['direct_expense_currency'] = Variable<String>(
        directExpenseCurrency.value,
      );
    }
    if (directExpenseType.present) {
      map['direct_expense_type'] = Variable<String>(directExpenseType.value);
    }
    if (directExpenseFrequency.present) {
      map['direct_expense_frequency'] = Variable<String>(
        directExpenseFrequency.value,
      );
    }
    if (directExpenseDescription.present) {
      map['direct_expense_description'] = Variable<String>(
        directExpenseDescription.value,
      );
    }
    if (createdExpenseId.present) {
      map['created_expense_id'] = Variable<String>(createdExpenseId.value);
    }
    if (createdPaymentId.present) {
      map['created_payment_id'] = Variable<String>(createdPaymentId.value);
    }
    if (linkedShoppingListId.present) {
      map['linked_shopping_list_id'] = Variable<String>(
        linkedShoppingListId.value,
      );
    }
    if (parentTodoId.present) {
      map['parent_todo_id'] = Variable<String>(parentTodoId.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoItemsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('directExpenseAmount: $directExpenseAmount, ')
          ..write('directExpenseCurrency: $directExpenseCurrency, ')
          ..write('directExpenseType: $directExpenseType, ')
          ..write('directExpenseFrequency: $directExpenseFrequency, ')
          ..write('directExpenseDescription: $directExpenseDescription, ')
          ..write('createdExpenseId: $createdExpenseId, ')
          ..write('createdPaymentId: $createdPaymentId, ')
          ..write('linkedShoppingListId: $linkedShoppingListId, ')
          ..write('parentTodoId: $parentTodoId, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListsTable extends ShoppingLists
    with TableInfo<$ShoppingListsTable, ShoppingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES projects(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
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
  static const VerificationMeta _linkedExpenseIdMeta = const VerificationMeta(
    'linkedExpenseId',
  );
  @override
  late final GeneratedColumn<String> linkedExpenseId = GeneratedColumn<String>(
    'linked_expense_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    description,
    linkedExpenseId,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('linked_expense_id')) {
      context.handle(
        _linkedExpenseIdMeta,
        linkedExpenseId.isAcceptableOrUnknown(
          data['linked_expense_id']!,
          _linkedExpenseIdMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      linkedExpenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_expense_id'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ShoppingListsTable createAlias(String alias) {
    return $ShoppingListsTable(attachedDatabase, alias);
  }
}

class ShoppingList extends DataClass implements Insertable<ShoppingList> {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final String? linkedExpenseId;
  final bool isSynced;
  final String? tempId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ShoppingList({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    this.linkedExpenseId,
    required this.isSynced,
    this.tempId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || linkedExpenseId != null) {
      map['linked_expense_id'] = Variable<String>(linkedExpenseId);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || tempId != null) {
      map['temp_id'] = Variable<String>(tempId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ShoppingListsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      linkedExpenseId: linkedExpenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedExpenseId),
      isSynced: Value(isSynced),
      tempId: tempId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShoppingList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingList(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      linkedExpenseId: serializer.fromJson<String?>(json['linkedExpenseId']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      tempId: serializer.fromJson<String?>(json['tempId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'linkedExpenseId': serializer.toJson<String?>(linkedExpenseId),
      'isSynced': serializer.toJson<bool>(isSynced),
      'tempId': serializer.toJson<String?>(tempId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ShoppingList copyWith({
    String? id,
    String? projectId,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> linkedExpenseId = const Value.absent(),
    bool? isSynced,
    Value<String?> tempId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ShoppingList(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    linkedExpenseId: linkedExpenseId.present
        ? linkedExpenseId.value
        : this.linkedExpenseId,
    isSynced: isSynced ?? this.isSynced,
    tempId: tempId.present ? tempId.value : this.tempId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ShoppingList copyWithCompanion(ShoppingListsCompanion data) {
    return ShoppingList(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      linkedExpenseId: data.linkedExpenseId.present
          ? data.linkedExpenseId.value
          : this.linkedExpenseId,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingList(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('linkedExpenseId: $linkedExpenseId, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    name,
    description,
    linkedExpenseId,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingList &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.description == this.description &&
          other.linkedExpenseId == this.linkedExpenseId &&
          other.isSynced == this.isSynced &&
          other.tempId == this.tempId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ShoppingListsCompanion extends UpdateCompanion<ShoppingList> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> linkedExpenseId;
  final Value<bool> isSynced;
  final Value<String?> tempId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ShoppingListsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.linkedExpenseId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListsCompanion.insert({
    required String id,
    required String projectId,
    required String name,
    this.description = const Value.absent(),
    this.linkedExpenseId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       name = Value(name);
  static Insertable<ShoppingList> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? linkedExpenseId,
    Expression<bool>? isSynced,
    Expression<String>? tempId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (linkedExpenseId != null) 'linked_expense_id': linkedExpenseId,
      if (isSynced != null) 'is_synced': isSynced,
      if (tempId != null) 'temp_id': tempId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? linkedExpenseId,
    Value<bool>? isSynced,
    Value<String?>? tempId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ShoppingListsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      linkedExpenseId: linkedExpenseId ?? this.linkedExpenseId,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (linkedExpenseId.present) {
      map['linked_expense_id'] = Variable<String>(linkedExpenseId.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('linkedExpenseId: $linkedExpenseId, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListItemsTable extends ShoppingListItems
    with TableInfo<$ShoppingListItemsTable, ShoppingListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shoppingListIdMeta = const VerificationMeta(
    'shoppingListId',
  );
  @override
  late final GeneratedColumn<String> shoppingListId = GeneratedColumn<String>(
    'shopping_list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL REFERENCES shopping_lists(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedAmountMeta = const VerificationMeta(
    'estimatedAmount',
  );
  @override
  late final GeneratedColumn<int> estimatedAmount = GeneratedColumn<int>(
    'estimated_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualAmountMeta = const VerificationMeta(
    'actualAmount',
  );
  @override
  late final GeneratedColumn<int> actualAmount = GeneratedColumn<int>(
    'actual_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isPurchasedMeta = const VerificationMeta(
    'isPurchased',
  );
  @override
  late final GeneratedColumn<bool> isPurchased = GeneratedColumn<bool>(
    'is_purchased',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_purchased" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdExpenseIdMeta = const VerificationMeta(
    'createdExpenseId',
  );
  @override
  late final GeneratedColumn<String> createdExpenseId = GeneratedColumn<String>(
    'created_expense_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shoppingListId,
    name,
    estimatedAmount,
    actualAmount,
    currency,
    quantity,
    isPurchased,
    purchasedAt,
    notes,
    createdExpenseId,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
        _shoppingListIdMeta,
        shoppingListId.isAcceptableOrUnknown(
          data['shopping_list_id']!,
          _shoppingListIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('estimated_amount')) {
      context.handle(
        _estimatedAmountMeta,
        estimatedAmount.isAcceptableOrUnknown(
          data['estimated_amount']!,
          _estimatedAmountMeta,
        ),
      );
    }
    if (data.containsKey('actual_amount')) {
      context.handle(
        _actualAmountMeta,
        actualAmount.isAcceptableOrUnknown(
          data['actual_amount']!,
          _actualAmountMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('is_purchased')) {
      context.handle(
        _isPurchasedMeta,
        isPurchased.isAcceptableOrUnknown(
          data['is_purchased']!,
          _isPurchasedMeta,
        ),
      );
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_expense_id')) {
      context.handle(
        _createdExpenseIdMeta,
        createdExpenseId.isAcceptableOrUnknown(
          data['created_expense_id']!,
          _createdExpenseIdMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shoppingListId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shopping_list_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      estimatedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_amount'],
      ),
      actualAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_amount'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      isPurchased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_purchased'],
      )!,
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdExpenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_expense_id'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ShoppingListItemsTable createAlias(String alias) {
    return $ShoppingListItemsTable(attachedDatabase, alias);
  }
}

class ShoppingListItem extends DataClass
    implements Insertable<ShoppingListItem> {
  final String id;
  final String shoppingListId;
  final String name;
  final int? estimatedAmount;
  final int? actualAmount;
  final String currency;
  final int quantity;
  final bool isPurchased;
  final DateTime? purchasedAt;
  final String? notes;
  final String? createdExpenseId;
  final bool isSynced;
  final String? tempId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ShoppingListItem({
    required this.id,
    required this.shoppingListId,
    required this.name,
    this.estimatedAmount,
    this.actualAmount,
    required this.currency,
    required this.quantity,
    required this.isPurchased,
    this.purchasedAt,
    this.notes,
    this.createdExpenseId,
    required this.isSynced,
    this.tempId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shopping_list_id'] = Variable<String>(shoppingListId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || estimatedAmount != null) {
      map['estimated_amount'] = Variable<int>(estimatedAmount);
    }
    if (!nullToAbsent || actualAmount != null) {
      map['actual_amount'] = Variable<int>(actualAmount);
    }
    map['currency'] = Variable<String>(currency);
    map['quantity'] = Variable<int>(quantity);
    map['is_purchased'] = Variable<bool>(isPurchased);
    if (!nullToAbsent || purchasedAt != null) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdExpenseId != null) {
      map['created_expense_id'] = Variable<String>(createdExpenseId);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || tempId != null) {
      map['temp_id'] = Variable<String>(tempId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ShoppingListItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListItemsCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      name: Value(name),
      estimatedAmount: estimatedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedAmount),
      actualAmount: actualAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(actualAmount),
      currency: Value(currency),
      quantity: Value(quantity),
      isPurchased: Value(isPurchased),
      purchasedAt: purchasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdExpenseId: createdExpenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdExpenseId),
      isSynced: Value(isSynced),
      tempId: tempId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShoppingListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListItem(
      id: serializer.fromJson<String>(json['id']),
      shoppingListId: serializer.fromJson<String>(json['shoppingListId']),
      name: serializer.fromJson<String>(json['name']),
      estimatedAmount: serializer.fromJson<int?>(json['estimatedAmount']),
      actualAmount: serializer.fromJson<int?>(json['actualAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      quantity: serializer.fromJson<int>(json['quantity']),
      isPurchased: serializer.fromJson<bool>(json['isPurchased']),
      purchasedAt: serializer.fromJson<DateTime?>(json['purchasedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdExpenseId: serializer.fromJson<String?>(json['createdExpenseId']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      tempId: serializer.fromJson<String?>(json['tempId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shoppingListId': serializer.toJson<String>(shoppingListId),
      'name': serializer.toJson<String>(name),
      'estimatedAmount': serializer.toJson<int?>(estimatedAmount),
      'actualAmount': serializer.toJson<int?>(actualAmount),
      'currency': serializer.toJson<String>(currency),
      'quantity': serializer.toJson<int>(quantity),
      'isPurchased': serializer.toJson<bool>(isPurchased),
      'purchasedAt': serializer.toJson<DateTime?>(purchasedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdExpenseId': serializer.toJson<String?>(createdExpenseId),
      'isSynced': serializer.toJson<bool>(isSynced),
      'tempId': serializer.toJson<String?>(tempId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ShoppingListItem copyWith({
    String? id,
    String? shoppingListId,
    String? name,
    Value<int?> estimatedAmount = const Value.absent(),
    Value<int?> actualAmount = const Value.absent(),
    String? currency,
    int? quantity,
    bool? isPurchased,
    Value<DateTime?> purchasedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> createdExpenseId = const Value.absent(),
    bool? isSynced,
    Value<String?> tempId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ShoppingListItem(
    id: id ?? this.id,
    shoppingListId: shoppingListId ?? this.shoppingListId,
    name: name ?? this.name,
    estimatedAmount: estimatedAmount.present
        ? estimatedAmount.value
        : this.estimatedAmount,
    actualAmount: actualAmount.present ? actualAmount.value : this.actualAmount,
    currency: currency ?? this.currency,
    quantity: quantity ?? this.quantity,
    isPurchased: isPurchased ?? this.isPurchased,
    purchasedAt: purchasedAt.present ? purchasedAt.value : this.purchasedAt,
    notes: notes.present ? notes.value : this.notes,
    createdExpenseId: createdExpenseId.present
        ? createdExpenseId.value
        : this.createdExpenseId,
    isSynced: isSynced ?? this.isSynced,
    tempId: tempId.present ? tempId.value : this.tempId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ShoppingListItem copyWithCompanion(ShoppingListItemsCompanion data) {
    return ShoppingListItem(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      name: data.name.present ? data.name.value : this.name,
      estimatedAmount: data.estimatedAmount.present
          ? data.estimatedAmount.value
          : this.estimatedAmount,
      actualAmount: data.actualAmount.present
          ? data.actualAmount.value
          : this.actualAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      isPurchased: data.isPurchased.present
          ? data.isPurchased.value
          : this.isPurchased,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdExpenseId: data.createdExpenseId.present
          ? data.createdExpenseId.value
          : this.createdExpenseId,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItem(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('estimatedAmount: $estimatedAmount, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('currency: $currency, ')
          ..write('quantity: $quantity, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('notes: $notes, ')
          ..write('createdExpenseId: $createdExpenseId, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shoppingListId,
    name,
    estimatedAmount,
    actualAmount,
    currency,
    quantity,
    isPurchased,
    purchasedAt,
    notes,
    createdExpenseId,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListItem &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.name == this.name &&
          other.estimatedAmount == this.estimatedAmount &&
          other.actualAmount == this.actualAmount &&
          other.currency == this.currency &&
          other.quantity == this.quantity &&
          other.isPurchased == this.isPurchased &&
          other.purchasedAt == this.purchasedAt &&
          other.notes == this.notes &&
          other.createdExpenseId == this.createdExpenseId &&
          other.isSynced == this.isSynced &&
          other.tempId == this.tempId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ShoppingListItemsCompanion extends UpdateCompanion<ShoppingListItem> {
  final Value<String> id;
  final Value<String> shoppingListId;
  final Value<String> name;
  final Value<int?> estimatedAmount;
  final Value<int?> actualAmount;
  final Value<String> currency;
  final Value<int> quantity;
  final Value<bool> isPurchased;
  final Value<DateTime?> purchasedAt;
  final Value<String?> notes;
  final Value<String?> createdExpenseId;
  final Value<bool> isSynced;
  final Value<String?> tempId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ShoppingListItemsCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.name = const Value.absent(),
    this.estimatedAmount = const Value.absent(),
    this.actualAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isPurchased = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdExpenseId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListItemsCompanion.insert({
    required String id,
    required String shoppingListId,
    required String name,
    this.estimatedAmount = const Value.absent(),
    this.actualAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isPurchased = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdExpenseId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shoppingListId = Value(shoppingListId),
       name = Value(name);
  static Insertable<ShoppingListItem> custom({
    Expression<String>? id,
    Expression<String>? shoppingListId,
    Expression<String>? name,
    Expression<int>? estimatedAmount,
    Expression<int>? actualAmount,
    Expression<String>? currency,
    Expression<int>? quantity,
    Expression<bool>? isPurchased,
    Expression<DateTime>? purchasedAt,
    Expression<String>? notes,
    Expression<String>? createdExpenseId,
    Expression<bool>? isSynced,
    Expression<String>? tempId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (name != null) 'name': name,
      if (estimatedAmount != null) 'estimated_amount': estimatedAmount,
      if (actualAmount != null) 'actual_amount': actualAmount,
      if (currency != null) 'currency': currency,
      if (quantity != null) 'quantity': quantity,
      if (isPurchased != null) 'is_purchased': isPurchased,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (notes != null) 'notes': notes,
      if (createdExpenseId != null) 'created_expense_id': createdExpenseId,
      if (isSynced != null) 'is_synced': isSynced,
      if (tempId != null) 'temp_id': tempId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? shoppingListId,
    Value<String>? name,
    Value<int?>? estimatedAmount,
    Value<int?>? actualAmount,
    Value<String>? currency,
    Value<int>? quantity,
    Value<bool>? isPurchased,
    Value<DateTime?>? purchasedAt,
    Value<String?>? notes,
    Value<String?>? createdExpenseId,
    Value<bool>? isSynced,
    Value<String?>? tempId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ShoppingListItemsCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      name: name ?? this.name,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
      actualAmount: actualAmount ?? this.actualAmount,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      isPurchased: isPurchased ?? this.isPurchased,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      notes: notes ?? this.notes,
      createdExpenseId: createdExpenseId ?? this.createdExpenseId,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<String>(shoppingListId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (estimatedAmount.present) {
      map['estimated_amount'] = Variable<int>(estimatedAmount.value);
    }
    if (actualAmount.present) {
      map['actual_amount'] = Variable<int>(actualAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (isPurchased.present) {
      map['is_purchased'] = Variable<bool>(isPurchased.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdExpenseId.present) {
      map['created_expense_id'] = Variable<String>(createdExpenseId.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItemsCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('estimatedAmount: $estimatedAmount, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('currency: $currency, ')
          ..write('quantity: $quantity, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('notes: $notes, ')
          ..write('createdExpenseId: $createdExpenseId, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageRulesTable extends MessageRules
    with TableInfo<$MessageRulesTable, MessageRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _amountPatternMeta = const VerificationMeta(
    'amountPattern',
  );
  @override
  late final GeneratedColumn<String> amountPattern = GeneratedColumn<String>(
    'amount_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionPatternMeta =
      const VerificationMeta('descriptionPattern');
  @override
  late final GeneratedColumn<String> descriptionPattern =
      GeneratedColumn<String>(
        'description_pattern',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _defaultProjectIdMeta = const VerificationMeta(
    'defaultProjectId',
  );
  @override
  late final GeneratedColumn<String> defaultProjectId = GeneratedColumn<String>(
    'default_project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    sender,
    pattern,
    isActive,
    amountPattern,
    descriptionPattern,
    defaultProjectId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('amount_pattern')) {
      context.handle(
        _amountPatternMeta,
        amountPattern.isAcceptableOrUnknown(
          data['amount_pattern']!,
          _amountPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPatternMeta);
    }
    if (data.containsKey('description_pattern')) {
      context.handle(
        _descriptionPatternMeta,
        descriptionPattern.isAcceptableOrUnknown(
          data['description_pattern']!,
          _descriptionPatternMeta,
        ),
      );
    }
    if (data.containsKey('default_project_id')) {
      context.handle(
        _defaultProjectIdMeta,
        defaultProjectId.isAcceptableOrUnknown(
          data['default_project_id']!,
          _defaultProjectIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      amountPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount_pattern'],
      )!,
      descriptionPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_pattern'],
      ),
      defaultProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_project_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MessageRulesTable createAlias(String alias) {
    return $MessageRulesTable(attachedDatabase, alias);
  }
}

class MessageRule extends DataClass implements Insertable<MessageRule> {
  final String id;
  final String name;
  final String type;
  final String sender;
  final String pattern;
  final bool isActive;
  final String amountPattern;
  final String? descriptionPattern;
  final String? defaultProjectId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MessageRule({
    required this.id,
    required this.name,
    required this.type,
    required this.sender,
    required this.pattern,
    required this.isActive,
    required this.amountPattern,
    this.descriptionPattern,
    this.defaultProjectId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['sender'] = Variable<String>(sender);
    map['pattern'] = Variable<String>(pattern);
    map['is_active'] = Variable<bool>(isActive);
    map['amount_pattern'] = Variable<String>(amountPattern);
    if (!nullToAbsent || descriptionPattern != null) {
      map['description_pattern'] = Variable<String>(descriptionPattern);
    }
    if (!nullToAbsent || defaultProjectId != null) {
      map['default_project_id'] = Variable<String>(defaultProjectId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MessageRulesCompanion toCompanion(bool nullToAbsent) {
    return MessageRulesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      sender: Value(sender),
      pattern: Value(pattern),
      isActive: Value(isActive),
      amountPattern: Value(amountPattern),
      descriptionPattern: descriptionPattern == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionPattern),
      defaultProjectId: defaultProjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultProjectId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MessageRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageRule(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      sender: serializer.fromJson<String>(json['sender']),
      pattern: serializer.fromJson<String>(json['pattern']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      amountPattern: serializer.fromJson<String>(json['amountPattern']),
      descriptionPattern: serializer.fromJson<String?>(
        json['descriptionPattern'],
      ),
      defaultProjectId: serializer.fromJson<String?>(json['defaultProjectId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'sender': serializer.toJson<String>(sender),
      'pattern': serializer.toJson<String>(pattern),
      'isActive': serializer.toJson<bool>(isActive),
      'amountPattern': serializer.toJson<String>(amountPattern),
      'descriptionPattern': serializer.toJson<String?>(descriptionPattern),
      'defaultProjectId': serializer.toJson<String?>(defaultProjectId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MessageRule copyWith({
    String? id,
    String? name,
    String? type,
    String? sender,
    String? pattern,
    bool? isActive,
    String? amountPattern,
    Value<String?> descriptionPattern = const Value.absent(),
    Value<String?> defaultProjectId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MessageRule(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    sender: sender ?? this.sender,
    pattern: pattern ?? this.pattern,
    isActive: isActive ?? this.isActive,
    amountPattern: amountPattern ?? this.amountPattern,
    descriptionPattern: descriptionPattern.present
        ? descriptionPattern.value
        : this.descriptionPattern,
    defaultProjectId: defaultProjectId.present
        ? defaultProjectId.value
        : this.defaultProjectId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MessageRule copyWithCompanion(MessageRulesCompanion data) {
    return MessageRule(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      sender: data.sender.present ? data.sender.value : this.sender,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      amountPattern: data.amountPattern.present
          ? data.amountPattern.value
          : this.amountPattern,
      descriptionPattern: data.descriptionPattern.present
          ? data.descriptionPattern.value
          : this.descriptionPattern,
      defaultProjectId: data.defaultProjectId.present
          ? data.defaultProjectId.value
          : this.defaultProjectId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageRule(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('sender: $sender, ')
          ..write('pattern: $pattern, ')
          ..write('isActive: $isActive, ')
          ..write('amountPattern: $amountPattern, ')
          ..write('descriptionPattern: $descriptionPattern, ')
          ..write('defaultProjectId: $defaultProjectId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    sender,
    pattern,
    isActive,
    amountPattern,
    descriptionPattern,
    defaultProjectId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageRule &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.sender == this.sender &&
          other.pattern == this.pattern &&
          other.isActive == this.isActive &&
          other.amountPattern == this.amountPattern &&
          other.descriptionPattern == this.descriptionPattern &&
          other.defaultProjectId == this.defaultProjectId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MessageRulesCompanion extends UpdateCompanion<MessageRule> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> sender;
  final Value<String> pattern;
  final Value<bool> isActive;
  final Value<String> amountPattern;
  final Value<String?> descriptionPattern;
  final Value<String?> defaultProjectId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MessageRulesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.sender = const Value.absent(),
    this.pattern = const Value.absent(),
    this.isActive = const Value.absent(),
    this.amountPattern = const Value.absent(),
    this.descriptionPattern = const Value.absent(),
    this.defaultProjectId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageRulesCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String sender,
    required String pattern,
    this.isActive = const Value.absent(),
    required String amountPattern,
    this.descriptionPattern = const Value.absent(),
    this.defaultProjectId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       sender = Value(sender),
       pattern = Value(pattern),
       amountPattern = Value(amountPattern);
  static Insertable<MessageRule> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? sender,
    Expression<String>? pattern,
    Expression<bool>? isActive,
    Expression<String>? amountPattern,
    Expression<String>? descriptionPattern,
    Expression<String>? defaultProjectId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (sender != null) 'sender': sender,
      if (pattern != null) 'pattern': pattern,
      if (isActive != null) 'is_active': isActive,
      if (amountPattern != null) 'amount_pattern': amountPattern,
      if (descriptionPattern != null) 'description_pattern': descriptionPattern,
      if (defaultProjectId != null) 'default_project_id': defaultProjectId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? sender,
    Value<String>? pattern,
    Value<bool>? isActive,
    Value<String>? amountPattern,
    Value<String?>? descriptionPattern,
    Value<String?>? defaultProjectId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MessageRulesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      sender: sender ?? this.sender,
      pattern: pattern ?? this.pattern,
      isActive: isActive ?? this.isActive,
      amountPattern: amountPattern ?? this.amountPattern,
      descriptionPattern: descriptionPattern ?? this.descriptionPattern,
      defaultProjectId: defaultProjectId ?? this.defaultProjectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (amountPattern.present) {
      map['amount_pattern'] = Variable<String>(amountPattern.value);
    }
    if (descriptionPattern.present) {
      map['description_pattern'] = Variable<String>(descriptionPattern.value);
    }
    if (defaultProjectId.present) {
      map['default_project_id'] = Variable<String>(defaultProjectId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageRulesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('sender: $sender, ')
          ..write('pattern: $pattern, ')
          ..write('isActive: $isActive, ')
          ..write('amountPattern: $amountPattern, ')
          ..write('descriptionPattern: $descriptionPattern, ')
          ..write('defaultProjectId: $defaultProjectId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParsedMessagesTable extends ParsedMessages
    with TableInfo<$ParsedMessagesTable, ParsedMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParsedMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
    'rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawMessageMeta = const VerificationMeta(
    'rawMessage',
  );
  @override
  late final GeneratedColumn<String> rawMessage = GeneratedColumn<String>(
    'raw_message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _transactionTypeMeta = const VerificationMeta(
    'transactionType',
  );
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageDateMeta = const VerificationMeta(
    'messageDate',
  );
  @override
  late final GeneratedColumn<DateTime> messageDate = GeneratedColumn<DateTime>(
    'message_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isProcessedMeta = const VerificationMeta(
    'isProcessed',
  );
  @override
  late final GeneratedColumn<bool> isProcessed = GeneratedColumn<bool>(
    'is_processed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_processed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isConfirmedMeta = const VerificationMeta(
    'isConfirmed',
  );
  @override
  late final GeneratedColumn<bool> isConfirmed = GeneratedColumn<bool>(
    'is_confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_confirmed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdRecordIdMeta = const VerificationMeta(
    'createdRecordId',
  );
  @override
  late final GeneratedColumn<String> createdRecordId = GeneratedColumn<String>(
    'created_record_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordTypeMeta = const VerificationMeta(
    'recordType',
  );
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
    'record_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleId,
    rawMessage,
    sender,
    amount,
    description,
    transactionType,
    messageDate,
    isProcessed,
    isConfirmed,
    createdRecordId,
    recordType,
    projectId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parsed_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParsedMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    }
    if (data.containsKey('raw_message')) {
      context.handle(
        _rawMessageMeta,
        rawMessage.isAcceptableOrUnknown(data['raw_message']!, _rawMessageMeta),
      );
    } else if (isInserting) {
      context.missing(_rawMessageMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
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
    if (data.containsKey('transaction_type')) {
      context.handle(
        _transactionTypeMeta,
        transactionType.isAcceptableOrUnknown(
          data['transaction_type']!,
          _transactionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('message_date')) {
      context.handle(
        _messageDateMeta,
        messageDate.isAcceptableOrUnknown(
          data['message_date']!,
          _messageDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_messageDateMeta);
    }
    if (data.containsKey('is_processed')) {
      context.handle(
        _isProcessedMeta,
        isProcessed.isAcceptableOrUnknown(
          data['is_processed']!,
          _isProcessedMeta,
        ),
      );
    }
    if (data.containsKey('is_confirmed')) {
      context.handle(
        _isConfirmedMeta,
        isConfirmed.isAcceptableOrUnknown(
          data['is_confirmed']!,
          _isConfirmedMeta,
        ),
      );
    }
    if (data.containsKey('created_record_id')) {
      context.handle(
        _createdRecordIdMeta,
        createdRecordId.isAcceptableOrUnknown(
          data['created_record_id']!,
          _createdRecordIdMeta,
        ),
      );
    }
    if (data.containsKey('record_type')) {
      context.handle(
        _recordTypeMeta,
        recordType.isAcceptableOrUnknown(data['record_type']!, _recordTypeMeta),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParsedMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParsedMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_id'],
      ),
      rawMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_message'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      transactionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_type'],
      )!,
      messageDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}message_date'],
      )!,
      isProcessed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_processed'],
      )!,
      isConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_confirmed'],
      )!,
      createdRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_record_id'],
      ),
      recordType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_type'],
      ),
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ParsedMessagesTable createAlias(String alias) {
    return $ParsedMessagesTable(attachedDatabase, alias);
  }
}

class ParsedMessage extends DataClass implements Insertable<ParsedMessage> {
  final String id;
  final String? ruleId;
  final String rawMessage;
  final String sender;
  final int amount;
  final String? description;
  final String transactionType;
  final DateTime messageDate;
  final bool isProcessed;
  final bool isConfirmed;
  final String? createdRecordId;
  final String? recordType;
  final String? projectId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ParsedMessage({
    required this.id,
    this.ruleId,
    required this.rawMessage,
    required this.sender,
    required this.amount,
    this.description,
    required this.transactionType,
    required this.messageDate,
    required this.isProcessed,
    required this.isConfirmed,
    this.createdRecordId,
    this.recordType,
    this.projectId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<String>(ruleId);
    }
    map['raw_message'] = Variable<String>(rawMessage);
    map['sender'] = Variable<String>(sender);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['transaction_type'] = Variable<String>(transactionType);
    map['message_date'] = Variable<DateTime>(messageDate);
    map['is_processed'] = Variable<bool>(isProcessed);
    map['is_confirmed'] = Variable<bool>(isConfirmed);
    if (!nullToAbsent || createdRecordId != null) {
      map['created_record_id'] = Variable<String>(createdRecordId);
    }
    if (!nullToAbsent || recordType != null) {
      map['record_type'] = Variable<String>(recordType);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ParsedMessagesCompanion toCompanion(bool nullToAbsent) {
    return ParsedMessagesCompanion(
      id: Value(id),
      ruleId: ruleId == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleId),
      rawMessage: Value(rawMessage),
      sender: Value(sender),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      transactionType: Value(transactionType),
      messageDate: Value(messageDate),
      isProcessed: Value(isProcessed),
      isConfirmed: Value(isConfirmed),
      createdRecordId: createdRecordId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdRecordId),
      recordType: recordType == null && nullToAbsent
          ? const Value.absent()
          : Value(recordType),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ParsedMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParsedMessage(
      id: serializer.fromJson<String>(json['id']),
      ruleId: serializer.fromJson<String?>(json['ruleId']),
      rawMessage: serializer.fromJson<String>(json['rawMessage']),
      sender: serializer.fromJson<String>(json['sender']),
      amount: serializer.fromJson<int>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      messageDate: serializer.fromJson<DateTime>(json['messageDate']),
      isProcessed: serializer.fromJson<bool>(json['isProcessed']),
      isConfirmed: serializer.fromJson<bool>(json['isConfirmed']),
      createdRecordId: serializer.fromJson<String?>(json['createdRecordId']),
      recordType: serializer.fromJson<String?>(json['recordType']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleId': serializer.toJson<String?>(ruleId),
      'rawMessage': serializer.toJson<String>(rawMessage),
      'sender': serializer.toJson<String>(sender),
      'amount': serializer.toJson<int>(amount),
      'description': serializer.toJson<String?>(description),
      'transactionType': serializer.toJson<String>(transactionType),
      'messageDate': serializer.toJson<DateTime>(messageDate),
      'isProcessed': serializer.toJson<bool>(isProcessed),
      'isConfirmed': serializer.toJson<bool>(isConfirmed),
      'createdRecordId': serializer.toJson<String?>(createdRecordId),
      'recordType': serializer.toJson<String?>(recordType),
      'projectId': serializer.toJson<String?>(projectId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ParsedMessage copyWith({
    String? id,
    Value<String?> ruleId = const Value.absent(),
    String? rawMessage,
    String? sender,
    int? amount,
    Value<String?> description = const Value.absent(),
    String? transactionType,
    DateTime? messageDate,
    bool? isProcessed,
    bool? isConfirmed,
    Value<String?> createdRecordId = const Value.absent(),
    Value<String?> recordType = const Value.absent(),
    Value<String?> projectId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ParsedMessage(
    id: id ?? this.id,
    ruleId: ruleId.present ? ruleId.value : this.ruleId,
    rawMessage: rawMessage ?? this.rawMessage,
    sender: sender ?? this.sender,
    amount: amount ?? this.amount,
    description: description.present ? description.value : this.description,
    transactionType: transactionType ?? this.transactionType,
    messageDate: messageDate ?? this.messageDate,
    isProcessed: isProcessed ?? this.isProcessed,
    isConfirmed: isConfirmed ?? this.isConfirmed,
    createdRecordId: createdRecordId.present
        ? createdRecordId.value
        : this.createdRecordId,
    recordType: recordType.present ? recordType.value : this.recordType,
    projectId: projectId.present ? projectId.value : this.projectId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ParsedMessage copyWithCompanion(ParsedMessagesCompanion data) {
    return ParsedMessage(
      id: data.id.present ? data.id.value : this.id,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      rawMessage: data.rawMessage.present
          ? data.rawMessage.value
          : this.rawMessage,
      sender: data.sender.present ? data.sender.value : this.sender,
      amount: data.amount.present ? data.amount.value : this.amount,
      description: data.description.present
          ? data.description.value
          : this.description,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      messageDate: data.messageDate.present
          ? data.messageDate.value
          : this.messageDate,
      isProcessed: data.isProcessed.present
          ? data.isProcessed.value
          : this.isProcessed,
      isConfirmed: data.isConfirmed.present
          ? data.isConfirmed.value
          : this.isConfirmed,
      createdRecordId: data.createdRecordId.present
          ? data.createdRecordId.value
          : this.createdRecordId,
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParsedMessage(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('rawMessage: $rawMessage, ')
          ..write('sender: $sender, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('transactionType: $transactionType, ')
          ..write('messageDate: $messageDate, ')
          ..write('isProcessed: $isProcessed, ')
          ..write('isConfirmed: $isConfirmed, ')
          ..write('createdRecordId: $createdRecordId, ')
          ..write('recordType: $recordType, ')
          ..write('projectId: $projectId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ruleId,
    rawMessage,
    sender,
    amount,
    description,
    transactionType,
    messageDate,
    isProcessed,
    isConfirmed,
    createdRecordId,
    recordType,
    projectId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParsedMessage &&
          other.id == this.id &&
          other.ruleId == this.ruleId &&
          other.rawMessage == this.rawMessage &&
          other.sender == this.sender &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.transactionType == this.transactionType &&
          other.messageDate == this.messageDate &&
          other.isProcessed == this.isProcessed &&
          other.isConfirmed == this.isConfirmed &&
          other.createdRecordId == this.createdRecordId &&
          other.recordType == this.recordType &&
          other.projectId == this.projectId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ParsedMessagesCompanion extends UpdateCompanion<ParsedMessage> {
  final Value<String> id;
  final Value<String?> ruleId;
  final Value<String> rawMessage;
  final Value<String> sender;
  final Value<int> amount;
  final Value<String?> description;
  final Value<String> transactionType;
  final Value<DateTime> messageDate;
  final Value<bool> isProcessed;
  final Value<bool> isConfirmed;
  final Value<String?> createdRecordId;
  final Value<String?> recordType;
  final Value<String?> projectId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ParsedMessagesCompanion({
    this.id = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.rawMessage = const Value.absent(),
    this.sender = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.messageDate = const Value.absent(),
    this.isProcessed = const Value.absent(),
    this.isConfirmed = const Value.absent(),
    this.createdRecordId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.projectId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParsedMessagesCompanion.insert({
    required String id,
    this.ruleId = const Value.absent(),
    required String rawMessage,
    required String sender,
    required int amount,
    this.description = const Value.absent(),
    required String transactionType,
    required DateTime messageDate,
    this.isProcessed = const Value.absent(),
    this.isConfirmed = const Value.absent(),
    this.createdRecordId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.projectId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawMessage = Value(rawMessage),
       sender = Value(sender),
       amount = Value(amount),
       transactionType = Value(transactionType),
       messageDate = Value(messageDate);
  static Insertable<ParsedMessage> custom({
    Expression<String>? id,
    Expression<String>? ruleId,
    Expression<String>? rawMessage,
    Expression<String>? sender,
    Expression<int>? amount,
    Expression<String>? description,
    Expression<String>? transactionType,
    Expression<DateTime>? messageDate,
    Expression<bool>? isProcessed,
    Expression<bool>? isConfirmed,
    Expression<String>? createdRecordId,
    Expression<String>? recordType,
    Expression<String>? projectId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleId != null) 'rule_id': ruleId,
      if (rawMessage != null) 'raw_message': rawMessage,
      if (sender != null) 'sender': sender,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (transactionType != null) 'transaction_type': transactionType,
      if (messageDate != null) 'message_date': messageDate,
      if (isProcessed != null) 'is_processed': isProcessed,
      if (isConfirmed != null) 'is_confirmed': isConfirmed,
      if (createdRecordId != null) 'created_record_id': createdRecordId,
      if (recordType != null) 'record_type': recordType,
      if (projectId != null) 'project_id': projectId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParsedMessagesCompanion copyWith({
    Value<String>? id,
    Value<String?>? ruleId,
    Value<String>? rawMessage,
    Value<String>? sender,
    Value<int>? amount,
    Value<String?>? description,
    Value<String>? transactionType,
    Value<DateTime>? messageDate,
    Value<bool>? isProcessed,
    Value<bool>? isConfirmed,
    Value<String?>? createdRecordId,
    Value<String?>? recordType,
    Value<String?>? projectId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ParsedMessagesCompanion(
      id: id ?? this.id,
      ruleId: ruleId ?? this.ruleId,
      rawMessage: rawMessage ?? this.rawMessage,
      sender: sender ?? this.sender,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      transactionType: transactionType ?? this.transactionType,
      messageDate: messageDate ?? this.messageDate,
      isProcessed: isProcessed ?? this.isProcessed,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      createdRecordId: createdRecordId ?? this.createdRecordId,
      recordType: recordType ?? this.recordType,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (rawMessage.present) {
      map['raw_message'] = Variable<String>(rawMessage.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (messageDate.present) {
      map['message_date'] = Variable<DateTime>(messageDate.value);
    }
    if (isProcessed.present) {
      map['is_processed'] = Variable<bool>(isProcessed.value);
    }
    if (isConfirmed.present) {
      map['is_confirmed'] = Variable<bool>(isConfirmed.value);
    }
    if (createdRecordId.present) {
      map['created_record_id'] = Variable<String>(createdRecordId.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParsedMessagesCompanion(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('rawMessage: $rawMessage, ')
          ..write('sender: $sender, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('transactionType: $transactionType, ')
          ..write('messageDate: $messageDate, ')
          ..write('isProcessed: $isProcessed, ')
          ..write('isConfirmed: $isConfirmed, ')
          ..write('createdRecordId: $createdRecordId, ')
          ..write('recordType: $recordType, ')
          ..write('projectId: $projectId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdMappingsTable extends IdMappings
    with TableInfo<$IdMappingsTable, IdMapping> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalIdMeta = const VerificationMeta(
    'canonicalId',
  );
  @override
  late final GeneratedColumn<String> canonicalId = GeneratedColumn<String>(
    'canonical_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resourceTypeMeta = const VerificationMeta(
    'resourceType',
  );
  @override
  late final GeneratedColumn<String> resourceType = GeneratedColumn<String>(
    'resource_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mappedAtMeta = const VerificationMeta(
    'mappedAt',
  );
  @override
  late final GeneratedColumn<DateTime> mappedAt = GeneratedColumn<DateTime>(
    'mapped_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tempId,
    canonicalId,
    resourceType,
    mappedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'id_mappings';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdMapping> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tempIdMeta);
    }
    if (data.containsKey('canonical_id')) {
      context.handle(
        _canonicalIdMeta,
        canonicalId.isAcceptableOrUnknown(
          data['canonical_id']!,
          _canonicalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalIdMeta);
    }
    if (data.containsKey('resource_type')) {
      context.handle(
        _resourceTypeMeta,
        resourceType.isAcceptableOrUnknown(
          data['resource_type']!,
          _resourceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resourceTypeMeta);
    }
    if (data.containsKey('mapped_at')) {
      context.handle(
        _mappedAtMeta,
        mappedAt.isAcceptableOrUnknown(data['mapped_at']!, _mappedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tempId};
  @override
  IdMapping map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdMapping(
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      )!,
      canonicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_id'],
      )!,
      resourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resource_type'],
      )!,
      mappedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}mapped_at'],
      )!,
    );
  }

  @override
  $IdMappingsTable createAlias(String alias) {
    return $IdMappingsTable(attachedDatabase, alias);
  }
}

class IdMapping extends DataClass implements Insertable<IdMapping> {
  final String tempId;
  final String canonicalId;
  final String resourceType;
  final DateTime mappedAt;
  const IdMapping({
    required this.tempId,
    required this.canonicalId,
    required this.resourceType,
    required this.mappedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['temp_id'] = Variable<String>(tempId);
    map['canonical_id'] = Variable<String>(canonicalId);
    map['resource_type'] = Variable<String>(resourceType);
    map['mapped_at'] = Variable<DateTime>(mappedAt);
    return map;
  }

  IdMappingsCompanion toCompanion(bool nullToAbsent) {
    return IdMappingsCompanion(
      tempId: Value(tempId),
      canonicalId: Value(canonicalId),
      resourceType: Value(resourceType),
      mappedAt: Value(mappedAt),
    );
  }

  factory IdMapping.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdMapping(
      tempId: serializer.fromJson<String>(json['tempId']),
      canonicalId: serializer.fromJson<String>(json['canonicalId']),
      resourceType: serializer.fromJson<String>(json['resourceType']),
      mappedAt: serializer.fromJson<DateTime>(json['mappedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tempId': serializer.toJson<String>(tempId),
      'canonicalId': serializer.toJson<String>(canonicalId),
      'resourceType': serializer.toJson<String>(resourceType),
      'mappedAt': serializer.toJson<DateTime>(mappedAt),
    };
  }

  IdMapping copyWith({
    String? tempId,
    String? canonicalId,
    String? resourceType,
    DateTime? mappedAt,
  }) => IdMapping(
    tempId: tempId ?? this.tempId,
    canonicalId: canonicalId ?? this.canonicalId,
    resourceType: resourceType ?? this.resourceType,
    mappedAt: mappedAt ?? this.mappedAt,
  );
  IdMapping copyWithCompanion(IdMappingsCompanion data) {
    return IdMapping(
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      canonicalId: data.canonicalId.present
          ? data.canonicalId.value
          : this.canonicalId,
      resourceType: data.resourceType.present
          ? data.resourceType.value
          : this.resourceType,
      mappedAt: data.mappedAt.present ? data.mappedAt.value : this.mappedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdMapping(')
          ..write('tempId: $tempId, ')
          ..write('canonicalId: $canonicalId, ')
          ..write('resourceType: $resourceType, ')
          ..write('mappedAt: $mappedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tempId, canonicalId, resourceType, mappedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdMapping &&
          other.tempId == this.tempId &&
          other.canonicalId == this.canonicalId &&
          other.resourceType == this.resourceType &&
          other.mappedAt == this.mappedAt);
}

class IdMappingsCompanion extends UpdateCompanion<IdMapping> {
  final Value<String> tempId;
  final Value<String> canonicalId;
  final Value<String> resourceType;
  final Value<DateTime> mappedAt;
  final Value<int> rowid;
  const IdMappingsCompanion({
    this.tempId = const Value.absent(),
    this.canonicalId = const Value.absent(),
    this.resourceType = const Value.absent(),
    this.mappedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdMappingsCompanion.insert({
    required String tempId,
    required String canonicalId,
    required String resourceType,
    this.mappedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tempId = Value(tempId),
       canonicalId = Value(canonicalId),
       resourceType = Value(resourceType);
  static Insertable<IdMapping> custom({
    Expression<String>? tempId,
    Expression<String>? canonicalId,
    Expression<String>? resourceType,
    Expression<DateTime>? mappedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tempId != null) 'temp_id': tempId,
      if (canonicalId != null) 'canonical_id': canonicalId,
      if (resourceType != null) 'resource_type': resourceType,
      if (mappedAt != null) 'mapped_at': mappedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdMappingsCompanion copyWith({
    Value<String>? tempId,
    Value<String>? canonicalId,
    Value<String>? resourceType,
    Value<DateTime>? mappedAt,
    Value<int>? rowid,
  }) {
    return IdMappingsCompanion(
      tempId: tempId ?? this.tempId,
      canonicalId: canonicalId ?? this.canonicalId,
      resourceType: resourceType ?? this.resourceType,
      mappedAt: mappedAt ?? this.mappedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    if (canonicalId.present) {
      map['canonical_id'] = Variable<String>(canonicalId.value);
    }
    if (resourceType.present) {
      map['resource_type'] = Variable<String>(resourceType.value);
    }
    if (mappedAt.present) {
      map['mapped_at'] = Variable<DateTime>(mappedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdMappingsCompanion(')
          ..write('tempId: $tempId, ')
          ..write('canonicalId: $canonicalId, ')
          ..write('resourceType: $resourceType, ')
          ..write('mappedAt: $mappedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _parentCategoryIdMeta = const VerificationMeta(
    'parentCategoryId',
  );
  @override
  late final GeneratedColumn<String> parentCategoryId = GeneratedColumn<String>(
    'parent_category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<String> tempId = GeneratedColumn<String>(
    'temp_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    icon,
    color,
    isDefault,
    parentCategoryId,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('parent_category_id')) {
      context.handle(
        _parentCategoryIdMeta,
        parentCategoryId.isAcceptableOrUnknown(
          data['parent_category_id']!,
          _parentCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      parentCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_category_id'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final String type;
  final String? icon;
  final String? color;
  final bool isDefault;
  final String? parentCategoryId;
  final bool isSynced;
  final String? tempId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Category({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    required this.isDefault,
    this.parentCategoryId,
    required this.isSynced,
    this.tempId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || parentCategoryId != null) {
      map['parent_category_id'] = Variable<String>(parentCategoryId);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || tempId != null) {
      map['temp_id'] = Variable<String>(tempId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      isDefault: Value(isDefault),
      parentCategoryId: parentCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentCategoryId),
      isSynced: Value(isSynced),
      tempId: tempId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      parentCategoryId: serializer.fromJson<String?>(json['parentCategoryId']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      tempId: serializer.fromJson<String?>(json['tempId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'isDefault': serializer.toJson<bool>(isDefault),
      'parentCategoryId': serializer.toJson<String?>(parentCategoryId),
      'isSynced': serializer.toJson<bool>(isSynced),
      'tempId': serializer.toJson<String?>(tempId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? type,
    Value<String?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    bool? isDefault,
    Value<String?> parentCategoryId = const Value.absent(),
    bool? isSynced,
    Value<String?> tempId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
    isDefault: isDefault ?? this.isDefault,
    parentCategoryId: parentCategoryId.present
        ? parentCategoryId.value
        : this.parentCategoryId,
    isSynced: isSynced ?? this.isSynced,
    tempId: tempId.present ? tempId.value : this.tempId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      parentCategoryId: data.parentCategoryId.present
          ? data.parentCategoryId.value
          : this.parentCategoryId,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('parentCategoryId: $parentCategoryId, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    icon,
    color,
    isDefault,
    parentCategoryId,
    isSynced,
    tempId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isDefault == this.isDefault &&
          other.parentCategoryId == this.parentCategoryId &&
          other.isSynced == this.isSynced &&
          other.tempId == this.tempId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<bool> isDefault;
  final Value<String?> parentCategoryId;
  final Value<bool> isSynced;
  final Value<String?> tempId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.parentCategoryId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.parentCategoryId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tempId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<bool>? isDefault,
    Expression<String>? parentCategoryId,
    Expression<bool>? isSynced,
    Expression<String>? tempId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isDefault != null) 'is_default': isDefault,
      if (parentCategoryId != null) 'parent_category_id': parentCategoryId,
      if (isSynced != null) 'is_synced': isSynced,
      if (tempId != null) 'temp_id': tempId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? icon,
    Value<String?>? color,
    Value<bool>? isDefault,
    Value<String?>? parentCategoryId,
    Value<bool>? isSynced,
    Value<String?>? tempId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (parentCategoryId.present) {
      map['parent_category_id'] = Variable<String>(parentCategoryId.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<String>(tempId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('parentCategoryId: $parentCategoryId, ')
          ..write('isSynced: $isSynced, ')
          ..write('tempId: $tempId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $IncomeTable income = $IncomeTable(this);
  late final $TodoItemsTable todoItems = $TodoItemsTable(this);
  late final $ShoppingListsTable shoppingLists = $ShoppingListsTable(this);
  late final $ShoppingListItemsTable shoppingListItems =
      $ShoppingListItemsTable(this);
  late final $MessageRulesTable messageRules = $MessageRulesTable(this);
  late final $ParsedMessagesTable parsedMessages = $ParsedMessagesTable(this);
  late final $IdMappingsTable idMappings = $IdMappingsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    expenses,
    payments,
    income,
    todoItems,
    shoppingLists,
    shoppingListItems,
    messageRules,
    parsedMessages,
    idMappings,
    categories,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('income', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('todo_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_lists', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shopping_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_list_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<int?> budgetAmount,
      Value<String?> budgetType,
      Value<String?> budgetFrequency,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<int?> budgetAmount,
      Value<String?> budgetType,
      Value<String?> budgetFrequency,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(db.projects.id, db.expenses.projectId),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IncomeTable, List<IncomeData>> _incomeRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.income,
    aliasName: $_aliasNameGenerator(db.projects.id, db.income.projectId),
  );

  $$IncomeTableProcessedTableManager get incomeRefs {
    final manager = $$IncomeTableTableManager(
      $_db,
      $_db.income,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomeRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TodoItemsTable, List<TodoItem>>
  _todoItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.todoItems,
    aliasName: $_aliasNameGenerator(db.projects.id, db.todoItems.projectId),
  );

  $$TodoItemsTableProcessedTableManager get todoItemsRefs {
    final manager = $$TodoItemsTableTableManager(
      $_db,
      $_db.todoItems,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_todoItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShoppingListsTable, List<ShoppingList>>
  _shoppingListsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingLists,
    aliasName: $_aliasNameGenerator(db.projects.id, db.shoppingLists.projectId),
  );

  $$ShoppingListsTableProcessedTableManager get shoppingListsRefs {
    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shoppingListsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetAmount => $composableBuilder(
    column: $table.budgetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetType => $composableBuilder(
    column: $table.budgetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetFrequency => $composableBuilder(
    column: $table.budgetFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomeRefs(
    Expression<bool> Function($$IncomeTableFilterComposer f) f,
  ) {
    final $$IncomeTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.income,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeTableFilterComposer(
            $db: $db,
            $table: $db.income,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> todoItemsRefs(
    Expression<bool> Function($$TodoItemsTableFilterComposer f) f,
  ) {
    final $$TodoItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoItems,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoItemsTableFilterComposer(
            $db: $db,
            $table: $db.todoItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingListsRefs(
    Expression<bool> Function($$ShoppingListsTableFilterComposer f) f,
  ) {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetAmount => $composableBuilder(
    column: $table.budgetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetType => $composableBuilder(
    column: $table.budgetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetFrequency => $composableBuilder(
    column: $table.budgetFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get budgetAmount => $composableBuilder(
    column: $table.budgetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get budgetType => $composableBuilder(
    column: $table.budgetType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get budgetFrequency => $composableBuilder(
    column: $table.budgetFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomeRefs<T extends Object>(
    Expression<T> Function($$IncomeTableAnnotationComposer a) f,
  ) {
    final $$IncomeTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.income,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeTableAnnotationComposer(
            $db: $db,
            $table: $db.income,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> todoItemsRefs<T extends Object>(
    Expression<T> Function($$TodoItemsTableAnnotationComposer a) f,
  ) {
    final $$TodoItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoItems,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.todoItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shoppingListsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({
            bool expensesRefs,
            bool incomeRefs,
            bool todoItemsRefs,
            bool shoppingListsRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> budgetAmount = const Value.absent(),
                Value<String?> budgetType = const Value.absent(),
                Value<String?> budgetFrequency = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                description: description,
                budgetAmount: budgetAmount,
                budgetType: budgetType,
                budgetFrequency: budgetFrequency,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int?> budgetAmount = const Value.absent(),
                Value<String?> budgetType = const Value.absent(),
                Value<String?> budgetFrequency = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                description: description,
                budgetAmount: budgetAmount,
                budgetType: budgetType,
                budgetFrequency: budgetFrequency,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                expensesRefs = false,
                incomeRefs = false,
                todoItemsRefs = false,
                shoppingListsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (expensesRefs) db.expenses,
                    if (incomeRefs) db.income,
                    if (todoItemsRefs) db.todoItems,
                    if (shoppingListsRefs) db.shoppingLists,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Expense
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomeRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          IncomeData
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._incomeRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (todoItemsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          TodoItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._todoItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).todoItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shoppingListsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          ShoppingList
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._shoppingListsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingListsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({
        bool expensesRefs,
        bool incomeRefs,
        bool todoItemsRefs,
        bool shoppingListsRefs,
      })
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      required String id,
      required String projectId,
      required String name,
      required int expectedAmount,
      Value<String> currency,
      required String type,
      Value<String?> frequency,
      required DateTime startDate,
      Value<DateTime?> nextRenewalDate,
      Value<String?> categoryId,
      Value<String?> notes,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> name,
      Value<int> expectedAmount,
      Value<String> currency,
      Value<String> type,
      Value<String?> frequency,
      Value<DateTime> startDate,
      Value<DateTime?> nextRenewalDate,
      Value<String?> categoryId,
      Value<String?> notes,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.expenses.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRenewalDate => $composableBuilder(
    column: $table.nextRenewalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRenewalDate => $composableBuilder(
    column: $table.nextRenewalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRenewalDate => $composableBuilder(
    column: $table.nextRenewalDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({bool projectId})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> expectedAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> frequency = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> nextRenewalDate = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                projectId: projectId,
                name: name,
                expectedAmount: expectedAmount,
                currency: currency,
                type: type,
                frequency: frequency,
                startDate: startDate,
                nextRenewalDate: nextRenewalDate,
                categoryId: categoryId,
                notes: notes,
                isActive: isActive,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String name,
                required int expectedAmount,
                Value<String> currency = const Value.absent(),
                required String type,
                Value<String?> frequency = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> nextRenewalDate = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                expectedAmount: expectedAmount,
                currency: currency,
                type: type,
                frequency: frequency,
                startDate: startDate,
                nextRenewalDate: nextRenewalDate,
                categoryId: categoryId,
                notes: notes,
                isActive: isActive,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$ExpensesTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$ExpensesTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      required String id,
      required String paymentType,
      Value<String?> expenseId,
      Value<String?> incomeId,
      required int actualAmount,
      Value<String> currency,
      required DateTime paymentDate,
      Value<String> source,
      Value<bool> verified,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<String> id,
      Value<String> paymentType,
      Value<String?> expenseId,
      Value<String?> incomeId,
      Value<int> actualAmount,
      Value<String> currency,
      Value<DateTime> paymentDate,
      Value<String> source,
      Value<bool> verified,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expenseId => $composableBuilder(
    column: $table.expenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incomeId => $composableBuilder(
    column: $table.incomeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expenseId => $composableBuilder(
    column: $table.expenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incomeId => $composableBuilder(
    column: $table.incomeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expenseId =>
      $composableBuilder(column: $table.expenseId, builder: (column) => column);

  GeneratedColumn<String> get incomeId =>
      $composableBuilder(column: $table.incomeId, builder: (column) => column);

  GeneratedColumn<int> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
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
                Value<String> id = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<String?> expenseId = const Value.absent(),
                Value<String?> incomeId = const Value.absent(),
                Value<int> actualAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                paymentType: paymentType,
                expenseId: expenseId,
                incomeId: incomeId,
                actualAmount: actualAmount,
                currency: currency,
                paymentDate: paymentDate,
                source: source,
                verified: verified,
                notes: notes,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String paymentType,
                Value<String?> expenseId = const Value.absent(),
                Value<String?> incomeId = const Value.absent(),
                required int actualAmount,
                Value<String> currency = const Value.absent(),
                required DateTime paymentDate,
                Value<String> source = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                paymentType: paymentType,
                expenseId: expenseId,
                incomeId: incomeId,
                actualAmount: actualAmount,
                currency: currency,
                paymentDate: paymentDate,
                source: source,
                verified: verified,
                notes: notes,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
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
typedef $$IncomeTableCreateCompanionBuilder =
    IncomeCompanion Function({
      required String id,
      required String projectId,
      required String description,
      required int expectedAmount,
      Value<String> currency,
      required String type,
      Value<String?> frequency,
      required DateTime startDate,
      Value<DateTime?> nextExpectedDate,
      Value<String?> categoryId,
      Value<String?> invoiceNumber,
      Value<String?> notes,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$IncomeTableUpdateCompanionBuilder =
    IncomeCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> description,
      Value<int> expectedAmount,
      Value<String> currency,
      Value<String> type,
      Value<String?> frequency,
      Value<DateTime> startDate,
      Value<DateTime?> nextExpectedDate,
      Value<String?> categoryId,
      Value<String?> invoiceNumber,
      Value<String?> notes,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$IncomeTableReferences
    extends BaseReferences<_$AppDatabase, $IncomeTable, IncomeData> {
  $$IncomeTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.income.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IncomeTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeTable> {
  $$IncomeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextExpectedDate => $composableBuilder(
    column: $table.nextExpectedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeTable> {
  $$IncomeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextExpectedDate => $composableBuilder(
    column: $table.nextExpectedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeTable> {
  $$IncomeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextExpectedDate => $composableBuilder(
    column: $table.nextExpectedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeTable,
          IncomeData,
          $$IncomeTableFilterComposer,
          $$IncomeTableOrderingComposer,
          $$IncomeTableAnnotationComposer,
          $$IncomeTableCreateCompanionBuilder,
          $$IncomeTableUpdateCompanionBuilder,
          (IncomeData, $$IncomeTableReferences),
          IncomeData,
          PrefetchHooks Function({bool projectId})
        > {
  $$IncomeTableTableManager(_$AppDatabase db, $IncomeTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> expectedAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> frequency = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> nextExpectedDate = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeCompanion(
                id: id,
                projectId: projectId,
                description: description,
                expectedAmount: expectedAmount,
                currency: currency,
                type: type,
                frequency: frequency,
                startDate: startDate,
                nextExpectedDate: nextExpectedDate,
                categoryId: categoryId,
                invoiceNumber: invoiceNumber,
                notes: notes,
                isActive: isActive,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String description,
                required int expectedAmount,
                Value<String> currency = const Value.absent(),
                required String type,
                Value<String?> frequency = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> nextExpectedDate = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeCompanion.insert(
                id: id,
                projectId: projectId,
                description: description,
                expectedAmount: expectedAmount,
                currency: currency,
                type: type,
                frequency: frequency,
                startDate: startDate,
                nextExpectedDate: nextExpectedDate,
                categoryId: categoryId,
                invoiceNumber: invoiceNumber,
                notes: notes,
                isActive: isActive,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$IncomeTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$IncomeTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$IncomeTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IncomeTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeTable,
      IncomeData,
      $$IncomeTableFilterComposer,
      $$IncomeTableOrderingComposer,
      $$IncomeTableAnnotationComposer,
      $$IncomeTableCreateCompanionBuilder,
      $$IncomeTableUpdateCompanionBuilder,
      (IncomeData, $$IncomeTableReferences),
      IncomeData,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$TodoItemsTableCreateCompanionBuilder =
    TodoItemsCompanion Function({
      required String id,
      required String projectId,
      required String title,
      Value<String?> description,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<int?> directExpenseAmount,
      Value<String?> directExpenseCurrency,
      Value<String?> directExpenseType,
      Value<String?> directExpenseFrequency,
      Value<String?> directExpenseDescription,
      Value<String?> createdExpenseId,
      Value<String?> createdPaymentId,
      Value<String?> linkedShoppingListId,
      Value<String?> parentTodoId,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TodoItemsTableUpdateCompanionBuilder =
    TodoItemsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> title,
      Value<String?> description,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<int?> directExpenseAmount,
      Value<String?> directExpenseCurrency,
      Value<String?> directExpenseType,
      Value<String?> directExpenseFrequency,
      Value<String?> directExpenseDescription,
      Value<String?> createdExpenseId,
      Value<String?> createdPaymentId,
      Value<String?> linkedShoppingListId,
      Value<String?> parentTodoId,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TodoItemsTableReferences
    extends BaseReferences<_$AppDatabase, $TodoItemsTable, TodoItem> {
  $$TodoItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.todoItems.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TodoItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get directExpenseAmount => $composableBuilder(
    column: $table.directExpenseAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directExpenseCurrency => $composableBuilder(
    column: $table.directExpenseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directExpenseType => $composableBuilder(
    column: $table.directExpenseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directExpenseFrequency => $composableBuilder(
    column: $table.directExpenseFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directExpenseDescription => $composableBuilder(
    column: $table.directExpenseDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdExpenseId => $composableBuilder(
    column: $table.createdExpenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdPaymentId => $composableBuilder(
    column: $table.createdPaymentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedShoppingListId => $composableBuilder(
    column: $table.linkedShoppingListId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentTodoId => $composableBuilder(
    column: $table.parentTodoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get directExpenseAmount => $composableBuilder(
    column: $table.directExpenseAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directExpenseCurrency => $composableBuilder(
    column: $table.directExpenseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directExpenseType => $composableBuilder(
    column: $table.directExpenseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directExpenseFrequency => $composableBuilder(
    column: $table.directExpenseFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directExpenseDescription => $composableBuilder(
    column: $table.directExpenseDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdExpenseId => $composableBuilder(
    column: $table.createdExpenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdPaymentId => $composableBuilder(
    column: $table.createdPaymentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedShoppingListId => $composableBuilder(
    column: $table.linkedShoppingListId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentTodoId => $composableBuilder(
    column: $table.parentTodoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get directExpenseAmount => $composableBuilder(
    column: $table.directExpenseAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directExpenseCurrency => $composableBuilder(
    column: $table.directExpenseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directExpenseType => $composableBuilder(
    column: $table.directExpenseType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directExpenseFrequency => $composableBuilder(
    column: $table.directExpenseFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directExpenseDescription => $composableBuilder(
    column: $table.directExpenseDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdExpenseId => $composableBuilder(
    column: $table.createdExpenseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdPaymentId => $composableBuilder(
    column: $table.createdPaymentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedShoppingListId => $composableBuilder(
    column: $table.linkedShoppingListId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentTodoId => $composableBuilder(
    column: $table.parentTodoId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoItemsTable,
          TodoItem,
          $$TodoItemsTableFilterComposer,
          $$TodoItemsTableOrderingComposer,
          $$TodoItemsTableAnnotationComposer,
          $$TodoItemsTableCreateCompanionBuilder,
          $$TodoItemsTableUpdateCompanionBuilder,
          (TodoItem, $$TodoItemsTableReferences),
          TodoItem,
          PrefetchHooks Function({bool projectId})
        > {
  $$TodoItemsTableTableManager(_$AppDatabase db, $TodoItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> directExpenseAmount = const Value.absent(),
                Value<String?> directExpenseCurrency = const Value.absent(),
                Value<String?> directExpenseType = const Value.absent(),
                Value<String?> directExpenseFrequency = const Value.absent(),
                Value<String?> directExpenseDescription = const Value.absent(),
                Value<String?> createdExpenseId = const Value.absent(),
                Value<String?> createdPaymentId = const Value.absent(),
                Value<String?> linkedShoppingListId = const Value.absent(),
                Value<String?> parentTodoId = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodoItemsCompanion(
                id: id,
                projectId: projectId,
                title: title,
                description: description,
                isCompleted: isCompleted,
                completedAt: completedAt,
                directExpenseAmount: directExpenseAmount,
                directExpenseCurrency: directExpenseCurrency,
                directExpenseType: directExpenseType,
                directExpenseFrequency: directExpenseFrequency,
                directExpenseDescription: directExpenseDescription,
                createdExpenseId: createdExpenseId,
                createdPaymentId: createdPaymentId,
                linkedShoppingListId: linkedShoppingListId,
                parentTodoId: parentTodoId,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> directExpenseAmount = const Value.absent(),
                Value<String?> directExpenseCurrency = const Value.absent(),
                Value<String?> directExpenseType = const Value.absent(),
                Value<String?> directExpenseFrequency = const Value.absent(),
                Value<String?> directExpenseDescription = const Value.absent(),
                Value<String?> createdExpenseId = const Value.absent(),
                Value<String?> createdPaymentId = const Value.absent(),
                Value<String?> linkedShoppingListId = const Value.absent(),
                Value<String?> parentTodoId = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodoItemsCompanion.insert(
                id: id,
                projectId: projectId,
                title: title,
                description: description,
                isCompleted: isCompleted,
                completedAt: completedAt,
                directExpenseAmount: directExpenseAmount,
                directExpenseCurrency: directExpenseCurrency,
                directExpenseType: directExpenseType,
                directExpenseFrequency: directExpenseFrequency,
                directExpenseDescription: directExpenseDescription,
                createdExpenseId: createdExpenseId,
                createdPaymentId: createdPaymentId,
                linkedShoppingListId: linkedShoppingListId,
                parentTodoId: parentTodoId,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TodoItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$TodoItemsTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$TodoItemsTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TodoItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoItemsTable,
      TodoItem,
      $$TodoItemsTableFilterComposer,
      $$TodoItemsTableOrderingComposer,
      $$TodoItemsTableAnnotationComposer,
      $$TodoItemsTableCreateCompanionBuilder,
      $$TodoItemsTableUpdateCompanionBuilder,
      (TodoItem, $$TodoItemsTableReferences),
      TodoItem,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$ShoppingListsTableCreateCompanionBuilder =
    ShoppingListsCompanion Function({
      required String id,
      required String projectId,
      required String name,
      Value<String?> description,
      Value<String?> linkedExpenseId,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ShoppingListsTableUpdateCompanionBuilder =
    ShoppingListsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> name,
      Value<String?> description,
      Value<String?> linkedExpenseId,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ShoppingListsTableReferences
    extends BaseReferences<_$AppDatabase, $ShoppingListsTable, ShoppingList> {
  $$ShoppingListsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.shoppingLists.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
  _shoppingListItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shoppingListItems,
        aliasName: $_aliasNameGenerator(
          db.shoppingLists.id,
          db.shoppingListItems.shoppingListId,
        ),
      );

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager = $$ShoppingListItemsTableTableManager(
      $_db,
      $_db.shoppingListItems,
    ).filter((f) => f.shoppingListId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShoppingListsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedExpenseId => $composableBuilder(
    column: $table.linkedExpenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> shoppingListItemsRefs(
    Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f,
  ) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingListItems,
      getReferencedColumn: (t) => t.shoppingListId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingListsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedExpenseId => $composableBuilder(
    column: $table.linkedExpenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedExpenseId => $composableBuilder(
    column: $table.linkedExpenseId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> shoppingListItemsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shoppingListItems,
          getReferencedColumn: (t) => t.shoppingListId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingListItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingListItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShoppingListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListsTable,
          ShoppingList,
          $$ShoppingListsTableFilterComposer,
          $$ShoppingListsTableOrderingComposer,
          $$ShoppingListsTableAnnotationComposer,
          $$ShoppingListsTableCreateCompanionBuilder,
          $$ShoppingListsTableUpdateCompanionBuilder,
          (ShoppingList, $$ShoppingListsTableReferences),
          ShoppingList,
          PrefetchHooks Function({bool projectId, bool shoppingListItemsRefs})
        > {
  $$ShoppingListsTableTableManager(_$AppDatabase db, $ShoppingListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> linkedExpenseId = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion(
                id: id,
                projectId: projectId,
                name: name,
                description: description,
                linkedExpenseId: linkedExpenseId,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> linkedExpenseId = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                description: description,
                linkedExpenseId: linkedExpenseId,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShoppingListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, shoppingListItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shoppingListItemsRefs) db.shoppingListItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$ShoppingListsTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$ShoppingListsTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shoppingListItemsRefs)
                        await $_getPrefetchedData<
                          ShoppingList,
                          $ShoppingListsTable,
                          ShoppingListItem
                        >(
                          currentTable: table,
                          referencedTable: $$ShoppingListsTableReferences
                              ._shoppingListItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShoppingListsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingListItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shoppingListId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShoppingListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListsTable,
      ShoppingList,
      $$ShoppingListsTableFilterComposer,
      $$ShoppingListsTableOrderingComposer,
      $$ShoppingListsTableAnnotationComposer,
      $$ShoppingListsTableCreateCompanionBuilder,
      $$ShoppingListsTableUpdateCompanionBuilder,
      (ShoppingList, $$ShoppingListsTableReferences),
      ShoppingList,
      PrefetchHooks Function({bool projectId, bool shoppingListItemsRefs})
    >;
typedef $$ShoppingListItemsTableCreateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      required String id,
      required String shoppingListId,
      required String name,
      Value<int?> estimatedAmount,
      Value<int?> actualAmount,
      Value<String> currency,
      Value<int> quantity,
      Value<bool> isPurchased,
      Value<DateTime?> purchasedAt,
      Value<String?> notes,
      Value<String?> createdExpenseId,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ShoppingListItemsTableUpdateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      Value<String> id,
      Value<String> shoppingListId,
      Value<String> name,
      Value<int?> estimatedAmount,
      Value<int?> actualAmount,
      Value<String> currency,
      Value<int> quantity,
      Value<bool> isPurchased,
      Value<DateTime?> purchasedAt,
      Value<String?> notes,
      Value<String?> createdExpenseId,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ShoppingListItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem
        > {
  $$ShoppingListItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShoppingListsTable _shoppingListIdTable(_$AppDatabase db) =>
      db.shoppingLists.createAlias(
        $_aliasNameGenerator(
          db.shoppingListItems.shoppingListId,
          db.shoppingLists.id,
        ),
      );

  $$ShoppingListsTableProcessedTableManager get shoppingListId {
    final $_column = $_itemColumn<String>('shopping_list_id')!;

    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoppingListIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShoppingListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedAmount => $composableBuilder(
    column: $table.estimatedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdExpenseId => $composableBuilder(
    column: $table.createdExpenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShoppingListsTableFilterComposer get shoppingListId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedAmount => $composableBuilder(
    column: $table.estimatedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdExpenseId => $composableBuilder(
    column: $table.createdExpenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShoppingListsTableOrderingComposer get shoppingListId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableOrderingComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get estimatedAmount => $composableBuilder(
    column: $table.estimatedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualAmount => $composableBuilder(
    column: $table.actualAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdExpenseId => $composableBuilder(
    column: $table.createdExpenseId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get shoppingListId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem,
          $$ShoppingListItemsTableFilterComposer,
          $$ShoppingListItemsTableOrderingComposer,
          $$ShoppingListItemsTableAnnotationComposer,
          $$ShoppingListItemsTableCreateCompanionBuilder,
          $$ShoppingListItemsTableUpdateCompanionBuilder,
          (ShoppingListItem, $$ShoppingListItemsTableReferences),
          ShoppingListItem,
          PrefetchHooks Function({bool shoppingListId})
        > {
  $$ShoppingListItemsTableTableManager(
    _$AppDatabase db,
    $ShoppingListItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shoppingListId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> estimatedAmount = const Value.absent(),
                Value<int?> actualAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<bool> isPurchased = const Value.absent(),
                Value<DateTime?> purchasedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> createdExpenseId = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion(
                id: id,
                shoppingListId: shoppingListId,
                name: name,
                estimatedAmount: estimatedAmount,
                actualAmount: actualAmount,
                currency: currency,
                quantity: quantity,
                isPurchased: isPurchased,
                purchasedAt: purchasedAt,
                notes: notes,
                createdExpenseId: createdExpenseId,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String shoppingListId,
                required String name,
                Value<int?> estimatedAmount = const Value.absent(),
                Value<int?> actualAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<bool> isPurchased = const Value.absent(),
                Value<DateTime?> purchasedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> createdExpenseId = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion.insert(
                id: id,
                shoppingListId: shoppingListId,
                name: name,
                estimatedAmount: estimatedAmount,
                actualAmount: actualAmount,
                currency: currency,
                quantity: quantity,
                isPurchased: isPurchased,
                purchasedAt: purchasedAt,
                notes: notes,
                createdExpenseId: createdExpenseId,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShoppingListItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shoppingListId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (shoppingListId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.shoppingListId,
                                referencedTable:
                                    $$ShoppingListItemsTableReferences
                                        ._shoppingListIdTable(db),
                                referencedColumn:
                                    $$ShoppingListItemsTableReferences
                                        ._shoppingListIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListItemsTable,
      ShoppingListItem,
      $$ShoppingListItemsTableFilterComposer,
      $$ShoppingListItemsTableOrderingComposer,
      $$ShoppingListItemsTableAnnotationComposer,
      $$ShoppingListItemsTableCreateCompanionBuilder,
      $$ShoppingListItemsTableUpdateCompanionBuilder,
      (ShoppingListItem, $$ShoppingListItemsTableReferences),
      ShoppingListItem,
      PrefetchHooks Function({bool shoppingListId})
    >;
typedef $$MessageRulesTableCreateCompanionBuilder =
    MessageRulesCompanion Function({
      required String id,
      required String name,
      required String type,
      required String sender,
      required String pattern,
      Value<bool> isActive,
      required String amountPattern,
      Value<String?> descriptionPattern,
      Value<String?> defaultProjectId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$MessageRulesTableUpdateCompanionBuilder =
    MessageRulesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String> sender,
      Value<String> pattern,
      Value<bool> isActive,
      Value<String> amountPattern,
      Value<String?> descriptionPattern,
      Value<String?> defaultProjectId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MessageRulesTableFilterComposer
    extends Composer<_$AppDatabase, $MessageRulesTable> {
  $$MessageRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amountPattern => $composableBuilder(
    column: $table.amountPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionPattern => $composableBuilder(
    column: $table.descriptionPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultProjectId => $composableBuilder(
    column: $table.defaultProjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessageRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageRulesTable> {
  $$MessageRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amountPattern => $composableBuilder(
    column: $table.amountPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionPattern => $composableBuilder(
    column: $table.descriptionPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultProjectId => $composableBuilder(
    column: $table.defaultProjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessageRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageRulesTable> {
  $$MessageRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get amountPattern => $composableBuilder(
    column: $table.amountPattern,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionPattern => $composableBuilder(
    column: $table.descriptionPattern,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultProjectId => $composableBuilder(
    column: $table.defaultProjectId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MessageRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessageRulesTable,
          MessageRule,
          $$MessageRulesTableFilterComposer,
          $$MessageRulesTableOrderingComposer,
          $$MessageRulesTableAnnotationComposer,
          $$MessageRulesTableCreateCompanionBuilder,
          $$MessageRulesTableUpdateCompanionBuilder,
          (
            MessageRule,
            BaseReferences<_$AppDatabase, $MessageRulesTable, MessageRule>,
          ),
          MessageRule,
          PrefetchHooks Function()
        > {
  $$MessageRulesTableTableManager(_$AppDatabase db, $MessageRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> amountPattern = const Value.absent(),
                Value<String?> descriptionPattern = const Value.absent(),
                Value<String?> defaultProjectId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessageRulesCompanion(
                id: id,
                name: name,
                type: type,
                sender: sender,
                pattern: pattern,
                isActive: isActive,
                amountPattern: amountPattern,
                descriptionPattern: descriptionPattern,
                defaultProjectId: defaultProjectId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required String sender,
                required String pattern,
                Value<bool> isActive = const Value.absent(),
                required String amountPattern,
                Value<String?> descriptionPattern = const Value.absent(),
                Value<String?> defaultProjectId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessageRulesCompanion.insert(
                id: id,
                name: name,
                type: type,
                sender: sender,
                pattern: pattern,
                isActive: isActive,
                amountPattern: amountPattern,
                descriptionPattern: descriptionPattern,
                defaultProjectId: defaultProjectId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessageRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessageRulesTable,
      MessageRule,
      $$MessageRulesTableFilterComposer,
      $$MessageRulesTableOrderingComposer,
      $$MessageRulesTableAnnotationComposer,
      $$MessageRulesTableCreateCompanionBuilder,
      $$MessageRulesTableUpdateCompanionBuilder,
      (
        MessageRule,
        BaseReferences<_$AppDatabase, $MessageRulesTable, MessageRule>,
      ),
      MessageRule,
      PrefetchHooks Function()
    >;
typedef $$ParsedMessagesTableCreateCompanionBuilder =
    ParsedMessagesCompanion Function({
      required String id,
      Value<String?> ruleId,
      required String rawMessage,
      required String sender,
      required int amount,
      Value<String?> description,
      required String transactionType,
      required DateTime messageDate,
      Value<bool> isProcessed,
      Value<bool> isConfirmed,
      Value<String?> createdRecordId,
      Value<String?> recordType,
      Value<String?> projectId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ParsedMessagesTableUpdateCompanionBuilder =
    ParsedMessagesCompanion Function({
      Value<String> id,
      Value<String?> ruleId,
      Value<String> rawMessage,
      Value<String> sender,
      Value<int> amount,
      Value<String?> description,
      Value<String> transactionType,
      Value<DateTime> messageDate,
      Value<bool> isProcessed,
      Value<bool> isConfirmed,
      Value<String?> createdRecordId,
      Value<String?> recordType,
      Value<String?> projectId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ParsedMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ParsedMessagesTable> {
  $$ParsedMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawMessage => $composableBuilder(
    column: $table.rawMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get messageDate => $composableBuilder(
    column: $table.messageDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdRecordId => $composableBuilder(
    column: $table.createdRecordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParsedMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ParsedMessagesTable> {
  $$ParsedMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawMessage => $composableBuilder(
    column: $table.rawMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get messageDate => $composableBuilder(
    column: $table.messageDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdRecordId => $composableBuilder(
    column: $table.createdRecordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParsedMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParsedMessagesTable> {
  $$ParsedMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<String> get rawMessage => $composableBuilder(
    column: $table.rawMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get messageDate => $composableBuilder(
    column: $table.messageDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isConfirmed => $composableBuilder(
    column: $table.isConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdRecordId => $composableBuilder(
    column: $table.createdRecordId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ParsedMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParsedMessagesTable,
          ParsedMessage,
          $$ParsedMessagesTableFilterComposer,
          $$ParsedMessagesTableOrderingComposer,
          $$ParsedMessagesTableAnnotationComposer,
          $$ParsedMessagesTableCreateCompanionBuilder,
          $$ParsedMessagesTableUpdateCompanionBuilder,
          (
            ParsedMessage,
            BaseReferences<_$AppDatabase, $ParsedMessagesTable, ParsedMessage>,
          ),
          ParsedMessage,
          PrefetchHooks Function()
        > {
  $$ParsedMessagesTableTableManager(
    _$AppDatabase db,
    $ParsedMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParsedMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParsedMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParsedMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> ruleId = const Value.absent(),
                Value<String> rawMessage = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<DateTime> messageDate = const Value.absent(),
                Value<bool> isProcessed = const Value.absent(),
                Value<bool> isConfirmed = const Value.absent(),
                Value<String?> createdRecordId = const Value.absent(),
                Value<String?> recordType = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParsedMessagesCompanion(
                id: id,
                ruleId: ruleId,
                rawMessage: rawMessage,
                sender: sender,
                amount: amount,
                description: description,
                transactionType: transactionType,
                messageDate: messageDate,
                isProcessed: isProcessed,
                isConfirmed: isConfirmed,
                createdRecordId: createdRecordId,
                recordType: recordType,
                projectId: projectId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> ruleId = const Value.absent(),
                required String rawMessage,
                required String sender,
                required int amount,
                Value<String?> description = const Value.absent(),
                required String transactionType,
                required DateTime messageDate,
                Value<bool> isProcessed = const Value.absent(),
                Value<bool> isConfirmed = const Value.absent(),
                Value<String?> createdRecordId = const Value.absent(),
                Value<String?> recordType = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParsedMessagesCompanion.insert(
                id: id,
                ruleId: ruleId,
                rawMessage: rawMessage,
                sender: sender,
                amount: amount,
                description: description,
                transactionType: transactionType,
                messageDate: messageDate,
                isProcessed: isProcessed,
                isConfirmed: isConfirmed,
                createdRecordId: createdRecordId,
                recordType: recordType,
                projectId: projectId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParsedMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParsedMessagesTable,
      ParsedMessage,
      $$ParsedMessagesTableFilterComposer,
      $$ParsedMessagesTableOrderingComposer,
      $$ParsedMessagesTableAnnotationComposer,
      $$ParsedMessagesTableCreateCompanionBuilder,
      $$ParsedMessagesTableUpdateCompanionBuilder,
      (
        ParsedMessage,
        BaseReferences<_$AppDatabase, $ParsedMessagesTable, ParsedMessage>,
      ),
      ParsedMessage,
      PrefetchHooks Function()
    >;
typedef $$IdMappingsTableCreateCompanionBuilder =
    IdMappingsCompanion Function({
      required String tempId,
      required String canonicalId,
      required String resourceType,
      Value<DateTime> mappedAt,
      Value<int> rowid,
    });
typedef $$IdMappingsTableUpdateCompanionBuilder =
    IdMappingsCompanion Function({
      Value<String> tempId,
      Value<String> canonicalId,
      Value<String> resourceType,
      Value<DateTime> mappedAt,
      Value<int> rowid,
    });

class $$IdMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $IdMappingsTable> {
  $$IdMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalId => $composableBuilder(
    column: $table.canonicalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resourceType => $composableBuilder(
    column: $table.resourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get mappedAt => $composableBuilder(
    column: $table.mappedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IdMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $IdMappingsTable> {
  $$IdMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalId => $composableBuilder(
    column: $table.canonicalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resourceType => $composableBuilder(
    column: $table.resourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get mappedAt => $composableBuilder(
    column: $table.mappedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IdMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdMappingsTable> {
  $$IdMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<String> get canonicalId => $composableBuilder(
    column: $table.canonicalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resourceType => $composableBuilder(
    column: $table.resourceType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get mappedAt =>
      $composableBuilder(column: $table.mappedAt, builder: (column) => column);
}

class $$IdMappingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdMappingsTable,
          IdMapping,
          $$IdMappingsTableFilterComposer,
          $$IdMappingsTableOrderingComposer,
          $$IdMappingsTableAnnotationComposer,
          $$IdMappingsTableCreateCompanionBuilder,
          $$IdMappingsTableUpdateCompanionBuilder,
          (
            IdMapping,
            BaseReferences<_$AppDatabase, $IdMappingsTable, IdMapping>,
          ),
          IdMapping,
          PrefetchHooks Function()
        > {
  $$IdMappingsTableTableManager(_$AppDatabase db, $IdMappingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdMappingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tempId = const Value.absent(),
                Value<String> canonicalId = const Value.absent(),
                Value<String> resourceType = const Value.absent(),
                Value<DateTime> mappedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdMappingsCompanion(
                tempId: tempId,
                canonicalId: canonicalId,
                resourceType: resourceType,
                mappedAt: mappedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tempId,
                required String canonicalId,
                required String resourceType,
                Value<DateTime> mappedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdMappingsCompanion.insert(
                tempId: tempId,
                canonicalId: canonicalId,
                resourceType: resourceType,
                mappedAt: mappedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IdMappingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdMappingsTable,
      IdMapping,
      $$IdMappingsTableFilterComposer,
      $$IdMappingsTableOrderingComposer,
      $$IdMappingsTableAnnotationComposer,
      $$IdMappingsTableCreateCompanionBuilder,
      $$IdMappingsTableUpdateCompanionBuilder,
      (IdMapping, BaseReferences<_$AppDatabase, $IdMappingsTable, IdMapping>),
      IdMapping,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      required String type,
      Value<String?> icon,
      Value<String?> color,
      Value<bool> isDefault,
      Value<String?> parentCategoryId,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String?> icon,
      Value<String?> color,
      Value<bool> isDefault,
      Value<String?> parentCategoryId,
      Value<bool> isSynced,
      Value<String?> tempId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentCategoryId => $composableBuilder(
    column: $table.parentCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentCategoryId => $composableBuilder(
    column: $table.parentCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<String> get parentCategoryId => $composableBuilder(
    column: $table.parentCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String?> parentCategoryId = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                type: type,
                icon: icon,
                color: color,
                isDefault: isDefault,
                parentCategoryId: parentCategoryId,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String?> parentCategoryId = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> tempId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                type: type,
                icon: icon,
                color: color,
                isDefault: isDefault,
                parentCategoryId: parentCategoryId,
                isSynced: isSynced,
                tempId: tempId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$IncomeTableTableManager get income =>
      $$IncomeTableTableManager(_db, _db.income);
  $$TodoItemsTableTableManager get todoItems =>
      $$TodoItemsTableTableManager(_db, _db.todoItems);
  $$ShoppingListsTableTableManager get shoppingLists =>
      $$ShoppingListsTableTableManager(_db, _db.shoppingLists);
  $$ShoppingListItemsTableTableManager get shoppingListItems =>
      $$ShoppingListItemsTableTableManager(_db, _db.shoppingListItems);
  $$MessageRulesTableTableManager get messageRules =>
      $$MessageRulesTableTableManager(_db, _db.messageRules);
  $$ParsedMessagesTableTableManager get parsedMessages =>
      $$ParsedMessagesTableTableManager(_db, _db.parsedMessages);
  $$IdMappingsTableTableManager get idMappings =>
      $$IdMappingsTableTableManager(_db, _db.idMappings);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
}
