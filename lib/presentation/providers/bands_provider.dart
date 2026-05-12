import 'package:flu_avm/config/config.dart';
import 'package:flutter_riverpod/legacy.dart';

final bandsProvider = StateNotifierProvider<BandsNotifier, List<Band>>((ref) => BandsNotifier());

class BandsNotifier extends StateNotifier<List<Band>> {
  BandsNotifier() : super([

  Band(id: '1', nomen: 'Metallica', numerusVotum: 5),
  Band(id: '2', nomen: 'Queen', numerusVotum: 1),
  Band(id: '3', nomen: 'Héroes del silencio', numerusVotum: 2),
  Band(id: '4', nomen: 'Bon Jovi', numerusVotum: 5)  
  ]);

void addereBand(Band band){ 
  
 //final newBand = Band(id: DateTime.now().toString(), nomen: nomen, numerusVotum: 0);
  state = [...state, band];
}

  void delereBand(Band band){
    state = state.where((b) => b.id != band.id).toList();
  
  }

  void addereVotum(Band band){
    state = state.map((b) {
      return b.id == band.id ? 
      b.copyWith(numerusVotum: b.numerusVotum + 1) 
      : b;
    }).toList();

  }
}