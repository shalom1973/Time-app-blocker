import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Blocker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // מתחילים ישירות במסך הבית החדש
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // משתמשים ב-FutureBuilder כדי לטפל בטעינה הא-סינכרונית של רשימת האפליקציות
  late Future<List<Application>> _appsFuture;

  @override
  void initState() {
    super.initState();
    _appsFuture = _getInstalledApps();
  }
  
  // פונקציה שמחזירה את רשימת האפליקציות מהמכשיר
  Future<List<Application>> _getInstalledApps() async {
    // מבקשים את רשימת האפליקציות, לא כולל אפליקציות מערכת
    return await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("בחר אפליקציות לחסימה"),
      ),
      body: FutureBuilder<List<Application>>(
        future: _appsFuture,
        builder: (context, snapshot) {
          // בזמן שהרשימה נטענת, נציג אנימציית טעינה
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // אם יש שגיאה בטעינה
          if (snapshot.hasError) {
            return Center(child: Text("שגיאה בטעינת אפליקציות: ${snapshot.error}"));
          }

          // אם אין נתונים (נדיר, אבל אפשרי)
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("לא נמצאו אפליקציות מותקנות."));
          }

          // אם הטעינה הצליחה, נציג את הרשימה
          final apps = snapshot.data!;
          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              // ApplicationWithIcon הוא סוג שיש לו גם תמונה
              final icon = app is ApplicationWithIcon ? app.icon : null;

              return ListTile(
                // מציגים את האייקון של האפליקציה
                leading: icon != null
                    ? Image.memory(icon, width: 40, height: 40)
                    : const Icon(Icons.apps, size: 40),
                // מציגים את שם האפליקציה
                title: Text(app.appName),
                // מציגים את שם החבילה (למשל com.whatsapp)
                subtitle: Text(app.packageName),
                onTap: () {
                  // כאן תוכל להוסיף לוגיקה למה שקורה כשלוחצים על אפליקציה
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('בחרת ב: ${app.appName}')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}