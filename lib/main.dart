import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'core/design/tokens.dart';
import 'features/dashboard/dashboard_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await pdfrxFlutterInitialize();
  runApp(const ProviderScope(child: ComicReaderApp()));
}

class ComicReaderApp extends StatelessWidget {
  const ComicReaderApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Comic Reader',
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
    home: const DashboardShell(),
  );
}
