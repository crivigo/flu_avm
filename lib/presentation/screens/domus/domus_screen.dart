import 'package:flu_avm/config/menu/menu_item.dart';
import 'package:flu_avm/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';

class DomusScreen extends ConsumerWidget {
  const DomusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool estTenebrisModus = ref.watch(estTenebrisModusProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Flu Avm App'),
        actions: [IconButton(
          onPressed: () {
            ref.read(estTenebrisModusProvider.notifier).state = !estTenebrisModus;
          }, 
          icon: Icon(
            estTenebrisModus 
            ? Icons.dark_mode_outlined 
            : Icons.light_mode_outlined
            )

          )
        ],
      ),
      body: _DomusView()
    );
  }
}

class _DomusView extends StatelessWidget {
  const _DomusView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appMenuItems.length,
      itemBuilder: (context, index) {
        final menuItem = appMenuItems[index];
      return _PropiumListTile(menuItem: menuItem);
    });
  }
}

class _PropiumListTile extends StatelessWidget {
  final MenuItem menuItem;

  const _PropiumListTile({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final colorum = Theme.of(context).colorScheme.primary;
    return ListTile(
      title: Text(menuItem.titulus),
      subtitle: Text(menuItem.subtitulus),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: colorum,),
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(100, math.Random().nextInt(255), math.Random().nextInt(255), math.Random().nextInt(255)),
          child: Icon(menuItem.icon, color: Colors.black,),

      ),
     onTap: () {
        context.push(menuItem.link);
      },
    );
  }
}