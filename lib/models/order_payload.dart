class OrderPayload {
  const OrderPayload({
    required this.thirdparty,
    required this.contact,
    required this.order,
    required this.product,
    required this.lines,
  });

  final Map<String, dynamic> thirdparty;
  final Map<String, dynamic> contact;
  final Map<String, dynamic> order;
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> lines;

  factory OrderPayload.fromJson(Map<String, dynamic> json) => OrderPayload(
        thirdparty: Map<String, dynamic>.from(json['thirdparty'] as Map),
        contact: Map<String, dynamic>.from(json['contact'] as Map),
        order: Map<String, dynamic>.from(json['order'] as Map),
        product: Map<String, dynamic>.from(json['product'] as Map),
        lines: (json['lines'] as List? ?? [json['product']]).map((line) => Map<String, dynamic>.from(line as Map)).toList(),
      );
}
