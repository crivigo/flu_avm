import 'package:flu_avm/config/entities/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BandsScreen extends StatelessWidget {
  const BandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas'),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder:(context, i){
            return _bandTile(bands[i]);
        }   
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addereNovumBand(context),
      ),
    );
  }

  ListTile _bandTile(Band band) {
    return ListTile(
          leading: CircleAvatar(
          child: Text(band.nomen.substring(0,2).toUpperCase()), 
          ),
          title: Text(band.nomen),
          trailing: Text('${band.numerusVotum}', style: TextStyle(fontSize:20),),
          onTap: () => print(band.nomen),
          );
  }
addereNovumBand(BuildContext context){
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
            addereBandAdCollectione(context, textumController.text);
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
void addereBandAdCollectione(BuildContext context, String nomen){
  context.pop();

}

}