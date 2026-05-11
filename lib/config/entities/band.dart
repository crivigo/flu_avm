class Band {
  String id;

  String nomen;

  int numerusVotum;

  Band({
    required this.id,
    required this.nomen,
    required this.numerusVotum,
  });
}


List<Band> bands = [
  Band(id: '1', nomen: 'Metallica', numerusVotum: 5),
  Band(id: '2', nomen: 'Queen', numerusVotum: 1),
  Band(id: '3', nomen: 'Héroes del silencio', numerusVotum: 2),
  Band(id: '4', nomen: 'Bon Jovi', numerusVotum: 5)  
];