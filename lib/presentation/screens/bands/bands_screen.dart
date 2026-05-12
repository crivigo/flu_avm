import 'package:flu_avm/config/entities/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';

class BandsScreen extends ConsumerWidget {
  const BandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bands = ref.watch(bandsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas'),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder:(context, i){
            return _bandTile(context, ref,bands[i]);
        }   
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addereNovumBand(context, ref),
      ),
    );
  }

Widget _bandTile(BuildContext context, WidgetRef ref, Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        ref.read(bandsProvider.notifier).delereBand(band);
      } ,
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Text('Delete Band', style: TextStyle(color: Colors.white),),
      ),
      child: ListTile(
            leading: CircleAvatar(
            child: Text(band.nomen.substring(0,2).toUpperCase()), 
            ),
            title: Text(band.nomen),
            trailing: Text('${band.numerusVotum}', style: TextStyle(fontSize:20),),
            onTap: () {
              ref.read(bandsProvider.notifier).addereVotum(band);
            },
            ),
    );
  }
addereNovumBand(BuildContext context, WidgetRef ref) {
  final TextEditingController textumController = TextEditingController();



  // showDialog(
  //   context: context, 
  //   builder: (context){
  //     return AlertDialog(
  //       title: Text('New Band Name'),
  //       content: TextField(
  //         controller: textumController,
  //       ),
  //       actions: [
  //         MaterialButton(onPressed: () => addereBandAdCollecione(textumController.text, context), textColor: Colors.blue, elevation:5, child: Text('Add')),
  //         //MaterialButton(onPressed: () => Navigator.pop(context), textColor: Colors.blue, elevation:5, child: Text('Cancel')),
  //       ],
  //     );
  //   }
  // );

  showCupertinoDialog(
  context: context, 
  builder: ( BuildContext context ) => CupertinoAlertDialog(
    title: const Text('New band name'),
    content:  CupertinoTextField(
      controller: textumController,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.white 
          : Colors.black
        )
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Add'),
          onPressed: () {
            addereBandAdCollectione(context, ref, textumController.text);
            context.pop();
          }
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Close'),
          onPressed: () => context.pop()
        ),
      ],
   )
);
}
void addereBandAdCollectione(BuildContext context, WidgetRef ref, String nomen){
  
  if(nomen.length > 1)
  {
  ref.read(bandsProvider.notifier).addereBand(
    Band(id: DateTime.now().toString(), 
    nomen: nomen, 
    numerusVotum: 0)
  );
  }

}

}