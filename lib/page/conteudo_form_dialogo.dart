import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/pontos_turisticos.dart';



class ConteudoDialogForm extends StatefulWidget {
  final PontosTuristicos? pontosTuristicos;

  ConteudoDialogForm({Key? key, this.pontosTuristicos}) : super(key: key);

  void init() {}

  @override
  State<StatefulWidget> createState() => ConteudoDialogFormState();
}

class ConteudoDialogFormState extends State<ConteudoDialogForm> {
  final _diferenciaisController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _prazoController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (widget.pontosTuristicos != null) {
      _nomeController.text = widget.pontosTuristicos!.nome;
      _diferenciaisController.text = widget.pontosTuristicos!.diferenciais;
      _descricaoController.text = widget.pontosTuristicos!.descricao;
      _prazoController.text = widget.pontosTuristicos!.prazoFormatado;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: InputDecoration(
              labelText: 'Nome',
            ),
            validator: (String? valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Informe o nome';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _diferenciaisController,
            decoration: InputDecoration(
              labelText: 'Diferenciais',
            ),
            validator: (String? valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Informe o diferencial';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descricaoController,
            decoration: InputDecoration(
              labelText: 'Descrição',
            ),
            validator: (String? valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Informe a descrição';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _prazoController,
            decoration: InputDecoration(
              labelText: 'Prazo',
              prefixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _mostrarCalendario,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => _prazoController.clear(),
              ),
            ),
            readOnly: true,
          ),
        ],
      ),
    );
  }


  void _mostrarCalendario() async {
    final dataFormatada = _prazoController.text;
    DateTime data;
    if (dataFormatada.trim().isNotEmpty) {
      data = _dateFormat.parse(dataFormatada);
    } else {
      data = DateTime.now();
    }
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime.now().subtract(Duration(days: 5 * 365)),
      lastDate: DateTime.now().add(Duration(days: 5 * 365)),
    );
    if (dataSelecionada != null) {
      _prazoController.text = _dateFormat.format(dataSelecionada);
    }
  }


  bool dadosValidos() => _formKey.currentState?.validate() == true;

  PontosTuristicos get novoPonto => PontosTuristicos(
    id: widget.pontosTuristicos?.id,
    nome: _nomeController.text,
    diferenciais: _diferenciaisController.text,
    descricao: _descricaoController.text,
    prazo: _prazoController.text.isEmpty
        ? null
        : _dateFormat.parse(_prazoController.text),
  );

}