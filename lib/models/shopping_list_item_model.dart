import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'currency_model.dart';
import 'payment_model.dart';
import 'shopping_list_model.dart';
import 'user_model.dart';

class ShoppingListItemModel {
  final String? id;
  final String? name;
  final String? description;
  final String? tempId;
  final Map<String, dynamic>? metadata;
  final String? user;
  final UserModel? userData;
  final String? shoppingList;
  final ShoppingListModel? shoppingListData;
  final int? estimatedAmount;
  final int? actualAmount;
  final String? currency;
  final CurrencyModel? currencyData;
  final int? quantity;
  final bool? isPurchased;
  final DateTime? purchasedAt;
  final String? payment;
  final PaymentModel? paymentData;
  final bool? isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShoppingListItemModel({
    this.id,
    this.name,
    this.description,
    this.tempId,
    this.metadata,
    this.user,
    this.userData,
    this.shoppingList,
    this.shoppingListData,
    this.estimatedAmount,
    this.actualAmount,
    this.currency,
    this.currencyData,
    this.quantity,
    this.isPurchased,
    this.purchasedAt,
    this.payment,
    this.paymentData,
    this.isSynced,
    this.createdAt,
    this.updatedAt,
  });

  factory ShoppingListItemModel.fromJson(Map<String, dynamic> json) {
    return ShoppingListItemModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      tempId: json['tempId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      shoppingList: json['shoppingList'] as String?,
      shoppingListData: json['expand']?['shoppingList'] != null
          ? ShoppingListModel.fromJson(json['expand']['shoppingList'] as Map<String, dynamic>)
          : null,
      estimatedAmount: json['estimatedAmount'] as int?,
      actualAmount: json['actualAmount'] as int?,
      currency: json['currency'] as String?,
      currencyData: json['expand']?['currency'] != null
          ? CurrencyModel.fromJson(json['expand']['currency'] as Map<String, dynamic>)
          : null,
      quantity: json['quantity'] as int?,
      isPurchased: json['isPurchased'] as bool?,
      purchasedAt: json['purchasedAt'] != null
          ? DateTime.parse(json['purchasedAt'] as String)
          : null,
      payment: json['payment'] as String?,
      paymentData: json['expand']?['payment'] != null
          ? PaymentModel.fromJson(json['expand']['payment'] as Map<String, dynamic>)
          : null,
      isSynced: json['isSynced'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tempId': tempId,
      'metadata': metadata,
      'user': user,
      'shoppingList': shoppingList,
      'estimatedAmount': estimatedAmount,
      'actualAmount': actualAmount,
      'currency': currency,
      'quantity': quantity,
      'isPurchased': isPurchased,
      'purchasedAt': purchasedAt?.toIso8601String(),
      'payment': payment,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  ShoppingListItemsCompanion toCompanion({
    String? id,
    String? name,
    String? description,
    String? tempId,
    String? user,
    UserModel? userData,
    String? shoppingList,
    ShoppingListModel? shoppingListData,
    int? estimatedAmount,
    int? actualAmount,
    String? currency,
    CurrencyModel? currencyData,
    int? quantity,
    bool? isPurchased,
    DateTime? purchasedAt,
    String? payment,
    PaymentModel? paymentData,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingListItemsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      description: description != null ? Value(description) : (this.description != null ? Value(this.description!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      shoppingListId: shoppingList != null ? Value(shoppingList) : (this.shoppingList != null ? Value(this.shoppingList!) : const Value.absent()),
      // shoppingListData: shoppingListData != null ? Value(shoppingListData) : (this.shoppingListData != null ? Value(this.shoppingListData!) : const Value.absent()),
      estimatedAmount: estimatedAmount != null ? Value(estimatedAmount) : (this.estimatedAmount != null ? Value(this.estimatedAmount!) : const Value.absent()),
      actualAmount: actualAmount != null ? Value(actualAmount) : (this.actualAmount != null ? Value(this.actualAmount!) : const Value.absent()),
      currency: currency != null ? Value(currency) : (this.currency != null ? Value(this.currency!) : const Value.absent()),
      // currencyData: currencyData != null ? Value(currencyData) : (this.currencyData != null ? Value(this.currencyData!) : const Value.absent()),
      quantity: quantity != null ? Value(quantity) : (this.quantity != null ? Value(this.quantity!) : const Value.absent()),
      isPurchased: isPurchased != null ? Value(isPurchased) : (this.isPurchased != null ? Value(this.isPurchased!) : const Value.absent()),
      purchasedAt: purchasedAt != null ? Value(purchasedAt) : (this.purchasedAt != null ? Value(this.purchasedAt!) : const Value.absent()),
      paymentId: payment != null ? Value(payment) : (this.payment != null ? Value(this.payment!) : const Value.absent()),
      // paymentData: paymentData != null ? Value(paymentData) : (this.paymentData != null ? Value(this.paymentData!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }
}
