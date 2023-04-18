import '../database/database_provider.dart';
import '../model/pontos_turisticos.dart';

class PontosTuristicosDao {
  final databaseProvider = DatabaseProvider.instance;


  Future<bool> salvar(PontosTuristicos pontosTuristicos) async {
    final database = await databaseProvider.database;
    final valores = pontosTuristicos.toMap();
    if (pontosTuristicos.id == null) {
      pontosTuristicos.id = await database.insert(PontosTuristicos.nomeTabela, valores);
      return true;
    } else {
      final registrosAtualizados = await database.update(
        PontosTuristicos.nomeTabela,
        valores,
        where: '${PontosTuristicos.campoId} = ?',
        whereArgs: [pontosTuristicos.id],
      );
      return registrosAtualizados > 0;
    }
  }


  Future<bool> remover(int id) async {
    final database = await databaseProvider.database;
    final registrosAtualizados = await database.delete(
      PontosTuristicos.nomeTabela,
      where: '${PontosTuristicos.campoId} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }

  Future<List<PontosTuristicos>> listar({
    String filtro = '',
    String campoOrdenacao = PontosTuristicos.campoId,
    bool usarOrdemDecrescente = false,
  }) async {
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${PontosTuristicos.campoDescricao}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }

    final database = await databaseProvider.database;
    final resultado = await database.query(
      PontosTuristicos.nomeTabela,
      columns: [
        PontosTuristicos.campoId,
        PontosTuristicos.campoDescricao,
        PontosTuristicos.campoPrazo,
        PontosTuristicos.campoFinalizada
      ],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => PontosTuristicos.fromMap(m)).toList();
  }
}