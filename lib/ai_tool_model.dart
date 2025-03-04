class AiTool {
  final String title;
  final String imageUrl;
  final String description;
  final String websiteUrl;
  final double propertyName2; // تغيير النوع إلى double
  final String category;

  AiTool({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.websiteUrl,
    required this.propertyName2,
    required this.category,
  });

  factory AiTool.fromJson(Map<String, dynamic> json) {
    return AiTool(
      title: json['Title'],
      imageUrl: json['Image_Url'],
      description: json['Descripe'],
      websiteUrl: json['Website_Url'],
      propertyName2: json['PropertyName2'].toDouble(), // تحويل إلى double
      category: json['Category'],
    );
  }
}
