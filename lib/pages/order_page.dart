import 'package:dailydairy/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../data_schema.dart';
import '../theme.dart';

class OrderPage extends StatefulWidget {
  final bool isSubscription;

  const OrderPage({super.key, this.isSubscription = false});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService();
  final List<CartItem> _cartItems = [];
  bool _isSubscription = false;
  String _selectedFrequency = 'weekly';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;
  int _daysInFrequency = 7;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _isSubscription = widget.isSubscription;
    _tabController = TabController(length: 2, vsync: this);
    if (_isSubscription) {
      _tabController.index = 1;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateFrequencyMultiplier() {
    setState(() {
      _daysInFrequency = _selectedFrequency == 'weekly' ? 7 : 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white, // white background for status bar
        statusBarIconBrightness: Brightness.dark, // black icons
        statusBarBrightness:
            Brightness.light, // for iOS (white background => dark text)
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: const Text('Place Order'),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.shopping_cart), text: 'One-time Order'),
              Tab(icon: Icon(Icons.subscriptions), text: 'Subscription'),
            ],
            onTap: (index) {
              setState(() {
                _isSubscription = index == 1;
              });
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_buildOrderTab(), _buildSubscriptionTab()],
        ),
      ),
    );
  }

  Widget _buildOrderTab() {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              _buildProductsList(),
              if (_cartItems.isNotEmpty) _buildOrderSummary(),
            ],
          ),
        ),
        if (_cartItems.isNotEmpty) _buildBottomCheckout(),
      ],
    );
  }

  Widget _buildSubscriptionTab() {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              _buildSubscriptionOptions(),
              _buildProductsList(),
              if (_cartItems.isNotEmpty) _buildSubscriptionSummary(),
            ],
          ),
        ),
        if (_cartItems.isNotEmpty) _buildBottomCheckout(),
      ],
    );
  }

  Widget _buildSubscriptionOptions() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.subscriptions,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Subscription Plans',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Choose your delivery frequency:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                _buildFrequencyChip('weekly', 'Weekly', Icons.date_range),
                _buildFrequencyChip('monthly', 'Monthly', Icons.calendar_month),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Subscriptions can be cancelled or modified anytime. Save up to 15% on regular orders!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyChip(String value, String label, IconData icon) {
    final isSelected = _selectedFrequency == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFrequency = value;
          _updateFrequencyMultiplier();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Products',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<ProductModel>>(
              stream: _databaseService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No products available'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final cartItem = _cartItems.firstWhere(
                      (item) => item.product.id == product.id,
                      orElse: () => CartItem(product: product, quantity: 0),
                    );
                    return _buildProductCard(product, cartItem);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, CartItem cartItem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            product.imageUrl == null || product.imageUrl!.isEmpty
                ? Image.asset('assets/default.png', fit: BoxFit.cover)
                : Image.network(
                  product.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/default.png', fit: BoxFit.cover);
                  },
                ),

            // Dark Overlay
            Container(color: Colors.black.withOpacity(0.4)),

            // Foreground Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    'Rs ${product.price.toStringAsFixed(0)} per ${product.unit}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Positioned Quantity Selector at Bottom Right
            Positioned(
              bottom: 12,
              right: 12,
              child: _buildQuantitySelector(product, cartItem),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(ProductModel product, CartItem cartItem) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), // semi-transparent background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: Colors.white),
            onPressed:
                cartItem.quantity > 0
                    ? () => _updateCartItem(product, cartItem.quantity - 1)
                    : null,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              cartItem.quantity.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _updateCartItem(product, cartItem.quantity + 1),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._cartItems.map((item) => _buildSummaryItem(item)),
            const Divider(),
            _buildDeliveryDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionSummary() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subscription Summary',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Frequency: ${_selectedFrequency.toUpperCase()}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ..._cartItems.map((item) => _buildSummaryItem(item)),
            const Divider(),
            _buildDeliveryDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(CartItem item, {bool isSubscription = false}) {
    double total = item.product.price * item.quantity;
    if (isSubscription) {
      total *= _daysInFrequency; // APPLY FREQUENCY MULTIPLIER
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${item.product.name} x${item.quantity}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            'Rs ${total.toStringAsFixed(0)}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Details',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _isSubscription
                      ? 'Start Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}'
                      : 'Delivery Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Delivery Address',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Special Instructions (Optional)',
            prefixIcon: Icon(Icons.note),
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildBottomCheckout() {
    double totalAmount = _cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    if (_isSubscription) {
      totalAmount *= _daysInFrequency;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    'Rs ${totalAmount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isSubscription)
                    Text(
                      'per ${_selectedFrequency}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isSubscription
                                  ? Icons.subscriptions
                                  : Icons.shopping_cart,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isSubscription ? 'Subscribe' : 'Place Order',
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateCartItem(ProductModel product, int quantity) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (quantity <= 0) {
        if (existingIndex != -1) {
          _cartItems.removeAt(existingIndex);
        }
      } else {
        if (existingIndex != -1) {
          _cartItems[existingIndex] = CartItem(
            product: product,
            quantity: quantity,
          );
        } else {
          _cartItems.add(CartItem(product: product, quantity: quantity));
        }
      }
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _placeOrder() async {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one product')),
      );
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.currentUser!.uid;


      if (_isSubscription) {
        for (final cartItem in _cartItems) {
          final subscriptionTotal =
              cartItem.product.price * cartItem.quantity * _daysInFrequency;
          final subscription = SubscriptionModel(
            id: '',
            userId: userId,
            productId: cartItem.product.id,
            productName: cartItem.product.name,
            quantity: cartItem.quantity,
            frequency: _selectedFrequency,
            totalAmount: subscriptionTotal,
            startDate: _selectedDate,
            isActive: true,
            createdAt: DateTime.now(),
          );

          await _databaseService.createSubscription(subscription);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Subscription created successfully!'),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
        }
      } else {
        final orderItems =
            _cartItems.map((cartItem) {
              return OrderItem(
                productId: cartItem.product.id,
                productName: cartItem.product.name,
                quantity: cartItem.quantity,
                unitPrice: cartItem.product.price,
                totalPrice: cartItem.product.price * cartItem.quantity,
              );
            }).toList();

        final totalAmount = orderItems.fold<double>(
          0,
          (sum, item) => sum + item.totalPrice,
        );

        final order = OrderModel(
          id: '',
          userId: userId,
          items: orderItems,
          totalAmount: totalAmount,
          status: 'pending',
          deliveryAddress: _addressController.text.trim(),
          deliveryDate: _selectedDate,
          createdAt: DateTime.now(),
          notes:
              _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
        );

        await _databaseService.createOrder(order);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Order placed successfully!'),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
        }
      }

      // Clear state in one batch
      setState(() {
        _cartItems.clear();
        _addressController.clear();
        _notesController.clear();
        _isLoading = false;
      });

      // Delay pop slightly to avoid black screen
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}

class CartItem {
  final ProductModel product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}
