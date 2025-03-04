import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد حزمة Firestore للتعامل مع قاعدة البيانات
import 'package:flutter/material.dart';
import 'package:helloworld/ai_tool_add.dart'; // استيراد ملف يحتوي على واجهة إضافة أدوات الذكاء الاصطناعي
import 'package:url_launcher/url_launcher.dart'; // استيراد حزمة لفتح الروابط في المتصفح
import 'ai_tool_model.dart'; // استيراد ملف يحتوي على نموذج بيانات أدوات الذكاء الاصطناعي
import 'package:helloworld/ai_tool_home.dart'; // استيراد ملف يحتوي على واجهة الصفحة الرئيسية

class AiToolHome extends StatefulWidget {
  @override
  _AiToolHomeState createState() => _AiToolHomeState(); // إنشاء حالة للواجهة
}

class _AiToolHomeState extends State<AiToolHome> {
  List<AiTool> aiTools = []; // قائمة لتخزين جميع أدوات الذكاء الاصطناعي
  List<AiTool> filteredTools = []; // قائمة لتخزين الأدوات المفلترة بناءً على البحث والفئة
  String searchQuery = ''; // متغير لتخزين نص البحث
  String selectedCategory = 'All'; // متغير لتخزين الفئة المحددة
  bool isCategorySelected = false; // متغير لتحديد ما إذا كانت فئة محددة قد تم اختيارها

  @override
  void initState() {
    super.initState();
    _fetchAiTools(); // استدعاء دالة لجلب البيانات من Firestore عند تهيئة الحالة
  }

  Future<void> _fetchAiTools() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ai_tools') // جلب البيانات من مجموعة 'ai_tools' في Firestore
          .get();

      List<AiTool> tools = [];
      for (var doc in querySnapshot.docs) {
        tools.add(AiTool.fromJson(doc.data() as Map<String, dynamic>)); // تحويل البيانات إلى نموذج AiTool
      }

      setState(() {
        aiTools = tools; // تحديث قائمة الأدوات
        filteredTools = tools; // تحديث قائمة الأدوات المفلترة
      });
    } catch (e) {
      print('Error fetching data: $e'); // طباعة خطأ في حالة فشل جلب البيانات
    }
  }

  void filterTools(String query, String category) {
    setState(() {
      searchQuery = query; // تحديث نص البحث
      selectedCategory = category; // تحديث الفئة المحددة
      filteredTools = aiTools.where((tool) {
        final matchesQuery =
        tool.title.toLowerCase().contains(query.toLowerCase()); // التحقق من تطابق العنوان مع نص البحث
        final matchesCategory = category == 'All' || tool.category == category; // التحقق من تطابق الفئة
        return matchesQuery && matchesCategory; // إرجاع الأدوات التي تطابق البحث والفئة
      }).toList();
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url); // تحويل الرابط إلى كائن Uri
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url'); // إطلاق استثناء في حالة فشل فتح الرابط
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ABDSH_SOFT'), // عنوان التطبيق
            SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: AssetImage('assets/m.jpg'), // صورة المستخدم
              radius: 20,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent], // تدرج لوني لخلفية AppBar
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: isCategorySelected
            ? IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // زر الرجوع عند اختيار فئة
          onPressed: () {
            setState(() {
              isCategorySelected = false; // إعادة تعيين حالة اختيار الفئة
              selectedCategory = 'All'; // إعادة تعيين الفئة المحددة إلى 'All'
              filterTools(searchQuery, 'All'); // تصفية الأدوات بناءً على البحث والفئة 'All'
            });
          },
        )
            : null,
      ),
      body: isCategorySelected
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textDirection: TextDirection.rtl, // اتجاه النص من اليمين إلى اليسار
              decoration: InputDecoration(
                hintText: 'Search...', // نص تلميحي لحقل البحث
                prefixIcon: Icon(Icons.search), // أيقونة البحث
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // حواف مستديرة لحقل البحث
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9), // لون خلفية حقل البحث
              ),
              onChanged: (value) {
                filterTools(value, selectedCategory); // تصفية الأدوات عند تغيير نص البحث
              },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTools.length, // عدد الأدوات المفلترة
              itemBuilder: (context, index) {
                AiTool tool = filteredTools[index]; // الحصول على الأداة الحالية
                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 4,
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://cdn.prod.website-files.com/63994dae1033718bee6949ce/${tool.imageUrl}", // عرض صورة الأداة
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      tool.title, // عنوان الأداة
                      textDirection: TextDirection.rtl,
                    ),
                    subtitle: Text(
                      tool.description, // وصف الأداة
                      textDirection: TextDirection.rtl,
                    ),
                    trailing: Text(
                      tool.category, // فئة الأداة
                      textDirection: TextDirection.rtl,
                    ),
                    onTap: () {
                      _launchUrl(tool.websiteUrl); // فتح رابط الأداة عند النقر
                    },
                  ),
                );
              },
            ),
          ),
        ],
      )
          : GridView.count(
        crossAxisCount: 2, // عدد الأعمدة في الشبكة
        padding: EdgeInsets.all(16),
        crossAxisSpacing: 16, // المسافة بين الأعمدة
        mainAxisSpacing: 16, // المسافة بين الصفوف
        children: [
          _buildCategoryCard(
              'All', [Colors.blueAccent, Colors.purpleAccent]), // بطاقة الفئة 'All'
          _buildCategoryCard(
              'Generative Code', [Colors.purple, Colors.deepPurple]), // بطاقة فئة 'Generative Code'
          _buildCategoryCard(
              'Podcasting', [Colors.orange, Colors.deepOrange]), // بطاقة فئة 'Podcasting'
          _buildCategoryCard(
              'Productivity', [Colors.green, Colors.lightGreen]), // بطاقة فئة 'Productivity'
          _buildCategoryCard('Image Scanning', [Colors.red, Colors.pink]), // بطاقة فئة 'Image Scanning'
          _buildCategoryCard('Video Editing', [Colors.teal, Colors.cyan]), // بطاقة فئة 'Video Editing'
          _buildCategoryCard(
              'Speech.To.Text', [Colors.pinkAccent, Colors.purpleAccent]), // بطاقة فئة 'Speech.To.Text'
          _buildCategoryCard('Marketing', [Colors.indigo, Colors.blue]), // بطاقة فئة 'Marketing'
          _buildCategoryCard(
              'Self.Improvement', [Colors.cyan, Colors.teal]), // بطاقة فئة 'Self.Improvement'
          _buildCategoryCard(
              'Generative Art', [Colors.amber, Colors.orange]), // بطاقة فئة 'Generative Art'
          _buildCategoryCard(
              'Generative Video', [Colors.deepPurple, Colors.purple]), // بطاقة فئة 'Generative Video'
          _buildCategoryCard('Chat', [Colors.lightBlue, Colors.blue]), // بطاقة فئة 'Chat'
          _buildCategoryCard(
              'Social Media', [Colors.lightGreen, Colors.green]), // بطاقة فئة 'Social Media'
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, List<Color> gradientColors) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category; // تحديث الفئة المحددة
          isCategorySelected = true; // تحديث حالة اختيار الفئة
          filterTools(searchQuery, category); // تصفية الأدوات بناءً على الفئة المحددة
        });
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // حواف مستديرة للبطاقة
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: gradientColors, // تدرج لوني للبطاقة
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              category, // نص الفئة
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl, // اتجاه النص من اليمين إلى اليسار
            ),
          ),
        ),
      ),
    );
  }
}