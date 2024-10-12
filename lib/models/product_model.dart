class Product {
  final String id;
  final String name;
  final String categoryId;
  final String color;
  final double purchasePrice;
  final double salePrice;
  final double averageCost;
  final String size;
  final int stockQuantity;
  final String supplierId;
  final int initialQuantity;
  final String note;

  // Constructor
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
  });

  // Factory method to convert Firestore data to a Product object
  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? 'لا يوجد اسم',
      categoryId: data['category_id'] ?? 'لا يوجد تصنيف',
      color: data['color'] ?? 'لا يوجد لون',
      purchasePrice: (data['purchase_price'] != null)
          ? data['purchase_price'].toDouble()
          : 0.0,
      salePrice:
          (data['sale_price'] != null) ? data['sale_price'].toDouble() : 0.0,
      averageCost: (data['average_cost'] != null)
          ? data['average_cost'].toDouble()
          : 0.0,
      size: data['size'] ?? 'لا يوجد حجم',
      stockQuantity:
          (data['stock_quantity'] != null) ? data['stock_quantity'].toInt() : 0,
      supplierId: data['supplier_id'] ?? 'لا يوجد مورد',
      initialQuantity: (data['initial_quantity'] != null)
          ? data['initial_quantity'].toInt()
          : 0,
      note: data['note'] ?? 'لا يوجد ملاحظة',
    );
  }
}
