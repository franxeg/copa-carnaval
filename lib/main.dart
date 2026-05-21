import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'services/ad_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDOH19OS8ao8zsaTUQ1on7EdQA9XiksiH8',
          authDomain: 'copa-carnaval.firebaseapp.com',
          projectId: 'copa-carnaval',
          storageBucket: 'copa-carnaval.firebasestorage.app',
          messagingSenderId: '869667772790',
          appId: '1:869667772790:web:ffbeeb437305aa5a190257',
          measurementId: 'G-PVFRTJ2TCW',
        ),
      );
    } else {
      await Firebase.initializeApp();
      await AdService().initialize();
    }
  } catch (e) {
    debugPrint('Firebase error: $e');
  }
  runApp(const CopaCarnavalApp());
}
