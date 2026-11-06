import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MawasApp());
}

class MawasApp extends StatelessWidget {
  const MawasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مواس',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090713),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B5CFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class BotFile {
  String name;
  String? path;
  bool running = false;

  BotFile(this.name, this.path);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<BotFile> files = [];
  final TextEditingController durationController =
      TextEditingController(text: '1');

  String durationUnit = 'ساعة';
  bool permanent = false;
  int selectedPage = 0;

  static const purple = Color(0xFF9B5CFF);
  static const background = Color(0xFF090713);

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      final file = result.files.first;

      setState(() {
        files.add(BotFile(file.name, file.path));
      });

      message('تمت إضافة الملف بنجاح');
    }
  }

  void message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, textAlign: TextAlign.center),
        backgroundColor: purple,
      ),
    );
  }

  void startBot(BotFile file) {
    message('تم تجهيز ${file.name}، محرك التشغيل نضيفه بالمرحلة القادمة');
  }

  void stopBot(BotFile file) {
    setState(() {
      file.running = false;
    });
  }

  Future<void> contactDeveloper() async {
    final url = Uri.parse('https://t.me/jdvk7');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Widget panel({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF171126),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: purple.withOpacity(0.22)),
        boxShadow: [
          BoxShadow(
            color: purple.withOpacity(0.06),
            blurRadius: 18,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget heading(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: purple, size: 22),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget statCard(String title, String number, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF171126),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: purple.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: purple, size: 25),
            const SizedBox(height: 8),
            Text(
              number,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF482078),
                Color(0xFF19102D),
                Color(0xFF110C20),
              ],
            ),
            border: Border.all(color: purple.withOpacity(0.4)),
          ),
          child: const Column(
            children: [
              Icon(Icons.workspace_premium,
                  color: Color(0xFFD9B5FF), size: 48),
              SizedBox(height: 8),
              Text(
                'مـواس',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'منصة إدارة واستضافة ملفات البوتات',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: Colors.greenAccent, size: 9),
                  SizedBox(width: 7),
                  Text('مرحباً بك في مواس'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            statCard('كل الملفات', '${files.length}', Icons.folder),
            statCard(
              'قيد التشغيل',
              '${files.where((f) => f.running).length}',
              Icons.play_circle,
            ),
            statCard('المحرك', 'قريباً', Icons.memory),
          ],
        ),

        const SizedBox(height: 24),

        heading('إضافة ملف جديد', Icons.upload_file),
        const SizedBox(height: 12),

        panel(
          child: Column(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                color: purple,
                size: 55,
              ),
              const SizedBox(height: 10),
              const Text(
                'ارفع ملفات البوتات الخاصة بك',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Python و JavaScript وملفات أخرى',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: pickFile,
                  icon: const Icon(Icons.add),
                  label: const Text('اختيار ملف من الهاتف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        heading('مدة الاستضافة', Icons.timer_outlined),
        const SizedBox(height: 12),

        panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('حدد مدة تشغيل البوت'),
              const SizedBox(height: 13),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                enabled: !permanent,
                decoration: InputDecoration(
                  hintText: 'أدخل المدة',
                  filled: true,
                  fillColor: background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: durationUnit,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  'ثانية',
                  'دقيقة',
                  'ساعة',
                  'يوم',
                  'شهر',
                  'سنة',
                ].map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: permanent
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => durationUnit = value);
                        }
                      },
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                value: permanent,
                activeColor: purple,
                contentPadding: EdgeInsets.zero,
                title: const Text('استضافة دائمة'),
                onChanged: (value) {
                  setState(() => permanent = value ?? false);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        heading('ملفاتي', Icons.folder_open),
        const SizedBox(height: 12),

        if (files.isEmpty)
          panel(
            child: const Column(
              children: [
                Icon(Icons.insert_drive_file_outlined,
                    color: Colors.white38, size: 40),
                SizedBox(height: 10),
                Text(
                  'لا توجد ملفات حتى الآن',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),

        ...files.map((file) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF171126),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: purple.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.description,
                    color: purple, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => startBot(file),
                  icon: const Icon(Icons.play_arrow,
                      color: Colors.greenAccent),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => files.remove(file));
                  },
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.redAccent),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 20),

        panel(
          child: Column(
            children: [
              const Icon(Icons.support_agent,
                  color: purple, size: 35),
              const SizedBox(height: 8),
              const Text(
                'الدعم الفني ومطور التطبيق',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 7),
              const Text(
                '@jdvk7',
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: contactDeveloper,
                icon: const Icon(Icons.telegram),
                label: const Text('تواصل مع المطور'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        const Center(
          child: Text(
            'مواس © 2026',
            style: TextStyle(color: Colors.white30),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: background,
          title: const Text(
            'مواس',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          leading: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.diamond_outlined, color: purple),
          ),
          actions: [
            IconButton(
              onPressed: () => message('مرحباً بك في مواس'),
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: homePage(),
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF171126),
          indicatorColor: purple.withOpacity(0.25),
          selectedIndex: selectedPage,
          onDestinationSelected: (index) {
            setState(() => selectedPage = index);
            if (index != 0) {
              message('هذا القسم نضيفه بالمرحلة القادمة');
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              label: 'الملفات',
            ),
            NavigationDestination(
              icon: Icon(Icons.terminal),
              label: 'السجل',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}
