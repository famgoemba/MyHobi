import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(color: Colors.blueAccent),
  );
}

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({super.key, required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Text("Waduh! $message", style: const TextStyle(color: Colors.red)),
  );
}