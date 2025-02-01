class Product {
  String id;
  String name;
  String categoryId;
  String color;
  double purchasePrice;
  double salePrice;
  double averageCost;
  String size;
  int stockQuantity;
  String supplierId;
  int initialQuantity;
  String note;
  String unit;
  double lastPurchasePrice;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.color,
    required this.purchasePrice,
    required this.salePrice,
    required this.averageCost,
    required this.size,
    required this.stockQuantity,
    required this.supplierId,
    required this.initialQuantity,
    required this.note,
    required this.lastPurchasePrice,
    required this.unit,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
        id: id,
        name: data['name'] ?? '',
        categoryId: data['category_id'] ?? '',
        color: data['color'] ?? '',
        purchasePrice: data['purchase_price'] ?? 0.0,
        salePrice: data['sale_price'] ?? 0.0,
        averageCost: data['average_cost'] ?? 0.0,
        size: data['size'] ?? '',
        stockQuantity: data['stock_quantity'] ?? 0,
        supplierId: data['supplier_id'] ?? '',
        initialQuantity: data['initial_quantity'] ?? 0,
        note: data['note'] ?? '',
        lastPurchasePrice: data['last_purchase_price'] ?? 0.0,
        unit: data['unit'] ?? '');
  }
}
