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
}
