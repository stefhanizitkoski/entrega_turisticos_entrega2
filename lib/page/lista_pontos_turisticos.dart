import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dao/dao_pontos_turisticos.dart';
import '../model/pontos_turisticos.dart';
import 'conteudo_form_dialogo.dart';
import 'detalhe_page.dart';
import 'filtro_page.dart';

class ListaPontosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListaPontosPageState();
}

class _ListaPontosPageState extends State<ListaPontosPage> {
  static const acaoEditar = 'editar';
  static const acaoExcluir = 'excluir';
  static const acaoVisualizar = 'visualizar';

  final _pontos = <PontosTuristicos>[];
  final _dao = PontosTuristicosDao();
  var _carregando = false;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo Ponto turistico',
        child: Icon(Icons.add),
        onPressed: _abrirForm,
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      title: Text('Pontos Turisticos'),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          tooltip: 'Filtro e Ordenação',
          onPressed: _abrirPaginaFiltro,
        ),
      ],
    );
  }

  Widget _criarBody() {
    if (_carregando) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Carregando pontos turisticos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (_pontos.isEmpty) {
      return Center(
        child: Text(
          'Nenhum ponto turistico cadastrado',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _pontos.length,
      itemBuilder: (BuildContext context, int index) {
        final pontos = _pontos [index];
        return PopupMenuButton<String>(
          child: ListTile(
            leading: Checkbox(
              value: pontos.finalizada,
              onChanged: (bool? checked) {
                setState(() {
                  pontos.finalizada = checked == true;
                });
                _dao.salvar(pontos);
              },
            ),
            title: Text(
              '${pontos.id} - ${pontos.descricao}',
              style: TextStyle(
                decoration:
                pontos.finalizada ? TextDecoration.lineThrough : null,
                color: pontos.finalizada ? Colors.grey : null,
              ),
            ),
            subtitle: Text(pontos.prazo == null ? 'Pontos sem prazo definido' : 'Pontos - ${pontos.prazoFormatado}',
              style: TextStyle(
                decoration:
                pontos.finalizada ? TextDecoration.lineThrough : null,
                color: pontos.finalizada ? Colors.grey : null,
              ),
            ),
          ),
          itemBuilder: (_) => _criarItensMenuPopup(),
          onSelected: (String valorSelecionado) {
            if (valorSelecionado == acaoEditar) {
              _abrirForm(pontosTuristicos: pontos);
            } else if (valorSelecionado == acaoExcluir) {
              _excluir(pontos);
            } else {
              _abrirPaginaDetalhesPontos(pontos);
            }
          },
        );
      },
      separatorBuilder: (_, __) => Divider(),
    );
  }

  List<PopupMenuEntry<String>> _criarItensMenuPopup() => [
    PopupMenuItem(
      value: acaoEditar,
      child: Row(
        children: const [
          Icon(Icons.edit, color: Colors.black),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('Editar'),
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: acaoExcluir,
      child: Row(
        children: const [
          Icon(Icons.delete, color: Colors.red),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('Excluir'),
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: acaoVisualizar,
      child: Row(
        children: const [
          Icon(Icons.info, color: Colors.blue),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('Visualizar'),
          ),
        ],
      ),
    ),
  ];

  void _abrirForm({PontosTuristicos? pontosTuristicos}) {
    final key = GlobalKey<ConteudoDialogFormState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          pontosTuristicos == null ? 'Novo Ponto Turistico' : 'Alterar Ponto Turistico ${pontosTuristicos.id}',
        ),
        content: ConteudoDialogForm(
          key: key,
          pontosTuristicos: pontosTuristicos,
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Salvar'),
            onPressed: () {
              if (key.currentState?.dadosValidos() != true) {
                return;
              }
              Navigator.of(context).pop();
              final novoPonto = key.currentState!.novoPonto;
              _dao.salvar(novoPonto).then((success) {
                if (success) {
                  _atualizarLista();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _excluir(PontosTuristicos pontosTuristicos) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Atenção'),
            ),
          ],
        ),
        content: Text('Esse registro será removido definitivamente.'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              if (pontosTuristicos.id == null) {
                return;
              }
              _dao.remover(pontosTuristicos.id!).then((success) {
                if (success) {
                  _atualizarLista();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _abrirPaginaFiltro() async {
    final navigator = Navigator.of(context);
    final alterouValores = await navigator.pushNamed(FiltroPage.routeName);
    if (alterouValores == true) {
      _atualizarLista();
    }
  }

  void _abrirPaginaDetalhesPontos(PontosTuristicos pontosTuristicos) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalhesPontosPage (
            pontosTuristicos : pontosTuristicos,
          ),
        ));
  }

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });
    // Carregar os valores do SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao =
        prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? PontosTuristicos.campoId;
    final usarOrdemDecrescente =
        prefs.getBool(FiltroPage.chaveUsarOrdemDecrescente) == true;
    final filtroDescricao =
        prefs.getString(FiltroPage.chaveCampoDescricao) ?? '';
    final pontosturisticos = await _dao.listar(
      filtro: filtroDescricao,
      campoOrdenacao: campoOrdenacao,
      usarOrdemDecrescente: usarOrdemDecrescente,
    );
    setState(() {
      _carregando = false;
      _pontos.clear();
      if (pontosturisticos.isNotEmpty) {
        _pontos.addAll(pontosturisticos);
      }
    });
  }
}