import 'package:flu_avm/presentation/providers/providers.dart';
import 'package:flu_avm/presentation/providers/siiii_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class SiiiiScreen extends ConsumerWidget {
 
   const SiiiiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final clickSiiii = ref.watch(siiiiProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Siiii Screen'),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(siiiiProvider.notifier).state++;
          //ref.read(siiiiProvider.notifier).update((state) => state + 1);
        },
        child: Icon(Icons.spoke),
      ),
    );
  }
}