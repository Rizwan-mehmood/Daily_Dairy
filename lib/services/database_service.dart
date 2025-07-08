import 'package:cloud_firestore/cloud_firestore.dart';
import '../data_schema.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Products
  Stream<List<ProductModel>> getProducts() {
    return _firestore
        .collection('products')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ProductModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Future<ProductModel?> getProduct(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  // Admin Product Management
  Stream<List<ProductModel>> getAllProducts() {
    return _firestore
        .collection('products')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ProductModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Future<String?> addProduct(ProductModel product) async {
    try {
      final docRef = await _firestore
          .collection('products')
          .add(product.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error adding product: $e');
      return null;
    }
  }

  Future<void> updateProduct(String productId, ProductModel product) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .update(product.toFirestore());
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }

  Future<void> toggleProductAvailability(
    String productId,
    bool isAvailable,
  ) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'isAvailable': isAvailable,
      });
    } catch (e) {
      print('Error toggling product availability: $e');
      throw e;
    }
  }

  // Orders
  Future<String?> createOrder(OrderModel order) async {
    try {
      final docRef = await _firestore
          .collection('orders')
          .add(order.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => OrderModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Stream<List<OrderModel>> getAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => OrderModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  // Subscriptions
  Future<String?> createSubscription(SubscriptionModel subscription) async {
    try {
      final docRef = await _firestore
          .collection('subscriptions')
          .add(subscription.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error creating subscription: $e');
      return null;
    }
  }

  Stream<List<SubscriptionModel>> getUserSubscriptions(String userId) {
    return _firestore
        .collection('subscriptions')
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => SubscriptionModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Stream<List<SubscriptionModel>> getAllSubscriptions() {
    return _firestore
        .collection('subscriptions')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => SubscriptionModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    try {
      await _firestore.collection('subscriptions').doc(subscriptionId).update({
        'isActive': false,
        'endDate': Timestamp.now(),
      });
    } catch (e) {
      print('Error cancelling subscription: $e');
    }
  }

  Future<void> updateSubscription(
    String subscriptionId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _firestore
          .collection('subscriptions')
          .doc(subscriptionId)
          .update(updates);
    } catch (e) {
      print('Error updating subscription: $e');
    }
  }

  // Daily Adjustments
  Future<String?> createDailyAdjustment(DailyAdjustmentModel adjustment) async {
    try {
      final docRef = await _firestore
          .collection('daily_adjustments')
          .add(adjustment.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error creating daily adjustment: $e');
      return null;
    }
  }

  Stream<List<DailyAdjustmentModel>> getUserDailyAdjustments(String userId) {
    return _firestore
        .collection('daily_adjustments')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => DailyAdjustmentModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Future<DailyAdjustmentModel?> getDailyAdjustment(
    String userId,
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final query =
          await _firestore
              .collection('daily_adjustments')
              .where('userId', isEqualTo: userId)
              .where(
                'date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
              )
              .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
              .get();

      if (query.docs.isNotEmpty) {
        return DailyAdjustmentModel.fromFirestore(query.docs.first);
      }
      return null;
    } catch (e) {
      print('Error getting daily adjustment: $e');
      return null;
    }
  }

  // Users (Admin)
  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList(),
        );
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Analytics (Admin)
  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final ordersSnapshot = await _firestore.collection('orders').get();
      final usersSnapshot = await _firestore.collection('users').get();
      final subscriptionsSnapshot =
          await _firestore
              .collection('subscriptions')
              .where('isActive', isEqualTo: true)
              .get();

      double totalRevenue = 0;
      int pendingOrders = 0;
      int completedOrders = 0;

      for (var doc in ordersSnapshot.docs) {
        final order = OrderModel.fromFirestore(doc);
        totalRevenue += order.totalAmount;
        if (order.status == 'pending' || order.status == 'confirmed') {
          pendingOrders++;
        } else if (order.status == 'delivered') {
          completedOrders++;
        }
      }

      return {
        'totalUsers': usersSnapshot.docs.length,
        'totalOrders': ordersSnapshot.docs.length,
        'activeSubscriptions': subscriptionsSnapshot.docs.length,
        'totalRevenue': totalRevenue,
        'pendingOrders': pendingOrders,
        'completedOrders': completedOrders,
      };
    } catch (e) {
      print('Error getting analytics: $e');
      return {};
    }
  }
}
