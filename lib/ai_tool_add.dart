import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'ai_tool_model.dart'; // تأكد من استيراد النموذج

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // دالة لتحميل البيانات من JSON إلى Firestore
  Future<void> uploadJsonToFirestore() async {
    try {
      // قراءة ملف JSON
      String jsonString = await rootBundle.loadString('assets/Ai-tools.json');
      List<dynamic> jsonList = json.decode(jsonString);

      // تحويل JSON إلى كائنات AiTool
      List<AiTool> aiTools =
          jsonList.map((json) => AiTool.fromJson(json)).toList();

      // تحميل البيانات إلى Firestore
      for (var tool in aiTools) {
        await _firestore.collection('ai_tools').add({
          'Title': tool.title,
          'Image_Url': tool.imageUrl,
          'Descripe': tool.description,
          'Website_Url': tool.websiteUrl,
          'PropertyName2': tool.propertyName2,
          'Category': tool.category,
        });
      }

      print('تم تحميل البيانات إلى Firestore بنجاح!');
    } catch (e) {
      print('حدث خطأ أثناء تحميل البيانات: $e');
    }
  }
}
