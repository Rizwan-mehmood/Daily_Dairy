import 'package:cloud_firestore/cloud_firestore.dart';

// User model
class UserModel {
  final String id;
  final String email;
  final String name;
  final String role; // 'admin' or 'customer'
  final String? phone;
  final String? address;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.address,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'customer',
      phone: data['phone'],
      address: data['address'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'phone': phone,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

// Product model
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit; // 'liters' or 'kg'
  final String category;
  final String imageUrl;
  final bool isAvailable;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      unit: data['unit'] ?? 'liters',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }
}

// Order model
class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // 'pending', 'confirmed', 'delivered', 'cancelled'
  final String deliveryAddress;
  final DateTime deliveryDate;
  final DateTime createdAt;
  final String? notes;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.createdAt,
    this.notes,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items:
          (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ??
          [],
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      deliveryAddress: data['deliveryAddress'] ?? '',
      deliveryDate: (data['deliveryDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'deliveryDate': Timestamp.fromDate(deliveryDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'notes': notes,
    };
  }
}

// Order item model
class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      unitPrice: (data['unitPrice'] ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }
}

// Subscription model
class SubscriptionModel {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final int quantity;
  final String frequency; // 'daily', 'weekly', 'monthly'
  final double totalAmount;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.frequency,
    required this.totalAmount,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.createdAt,
  });

  factory SubscriptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubscriptionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      frequency: data['frequency'] ?? 'daily',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate:
          data['endDate'] != null
              ? (data['endDate'] as Timestamp).toDate()
              : null,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'frequency': frequency,
      'totalAmount': totalAmount,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

// Daily adjustment model
class DailyAdjustmentModel {
  final String id;
  final String userId;
  final String subscriptionId;
  final DateTime date;
  final int originalQuantity;
  final int adjustedQuantity;
  final double additionalAmount;
  final DateTime createdAt;

  DailyAdjustmentModel({
    required this.id,
    required this.userId,
    required this.subscriptionId,
    required this.date,
    required this.originalQuantity,
    required this.adjustedQuantity,
    required this.additionalAmount,
    required this.createdAt,
  });

  factory DailyAdjustmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyAdjustmentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      subscriptionId: data['subscriptionId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      originalQuantity: data['originalQuantity'] ?? 0,
      adjustedQuantity: data['adjustedQuantity'] ?? 0,
      additionalAmount: (data['additionalAmount'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'subscriptionId': subscriptionId,
      'date': Timestamp.fromDate(date),
      'originalQuantity': originalQuantity,
      'adjustedQuantity': adjustedQuantity,
      'additionalAmount': additionalAmount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
