import 'package:flutter/material.dart';
import '../model/pontos_turisticos.dart';

class DetalhesPontosPage extends StatefulWidget {
  final PontosTuristicos pontosTuristicos;

  const DetalhesPontosPage ({Key? key, required this.pontosTuristicos }) : super(key: key);

  @override
  _DetalhesPontosPageState createState() => _DetalhesPontosPageState();
}

class _DetalhesPontosPageState extends State<DetalhesPontosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Ponto Turistico'),
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() => Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            Campo(descricao: 'Código: '),
            Valor(valor: '${widget.pontosTuristicos.id}'),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Descrição: '),
            Valor(valor: widget.pontosTuristicos.descricao),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Prazo: '),
            Valor(valor: widget.pontosTuristicos.prazoFormatado),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Finalizada: '),
            Valor(valor: widget.pontosTuristicos.finalizada ? 'Sim' : 'Não'),
          ],
        ),
      ],
    ),
  );
}

class Campo extends StatelessWidget {
  final String descricao;

  const Campo({Key? key, required this.descricao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
        descricao,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Valor extends StatelessWidget {
  final String valor;

  const Valor({Key? key, required this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}