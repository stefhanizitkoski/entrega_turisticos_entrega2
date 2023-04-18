import 'package:intl/intl.dart';

class PontosTuristicos {
  static const campoPrazo = 'prazo';
  static const campoFinalizada = 'finalizada';
  static const campoNome = 'nome';
  static const campoDiferenciais = 'diferenciais';
  static const nomeTabela = 'Pontos';
  static const campoId = '_id';
  static const campoDescricao = 'descricao';


  int? id;
  bool finalizada;
  String diferenciais;
  String nome;
  String descricao;
  DateTime? prazo;



  PontosTuristicos({
    this.id,
    required this.nome,
    required this.diferenciais,
    required this.descricao,
    this.prazo,
    this.finalizada = false,
  });

  String get prazoFormatado {
    if (prazo == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(prazo!);
  }

  Map<String, dynamic> toMap() => {
    campoId: id,
    campoDescricao: descricao,
    campoPrazo:
    prazo == null ? null : DateFormat("yyyy-MM-dd").format(prazo!),
    campoFinalizada: finalizada ? 1 : 0,
    campoNome: nome,
    campoDiferenciais: diferenciais,
  };

  factory PontosTuristicos.fromMap(Map<String, dynamic> map) => PontosTuristicos(
    id: map[campoId] is int ? map[campoId] : null,
    nome: map[campoNome] is String ? map[campoNome] : null,
    diferenciais: map[campoDiferenciais] is String ? map[campoDiferenciais] : null,
    descricao: map[campoDescricao] is String ? map[campoDescricao] : '',
    prazo: map[campoPrazo] is String
        ? DateFormat("yyyy-MM-dd").parse(map[campoPrazo])
        : null,
    finalizada: map[campoFinalizada] == 1,
  );
}