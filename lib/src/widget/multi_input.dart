import 'package:flutter/material.dart';

class MultiInput extends StatefulWidget {
  final Function(List<String>) onChanged;
  final List<String> initialValue;
  final String title;

  const MultiInput({
    Key key,
    @required this.onChanged,
    @required this.title,
    this.initialValue = const [],
  }) : super(key: key);

  @override
  _MultiInputState createState() => _MultiInputState();
}

class _MultiInputState extends State<MultiInput> {
  List<String> _inputs;

  @override
  void initState() {
    _inputs = List.from(widget.initialValue);
    super.initState();
  }

  List<Widget> getForm() {
    List<Widget> _widgets = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _inputs.add('');
              });
            },
          ),
        ],
      )
    ];
    for (int i = 0; i < _inputs.length; i++) {
      _widgets.add(
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                initialValue: _inputs[i],
                onChanged: (s) {
                  _inputs[i] = s;
                  widget.onChanged(_inputs);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                _inputs.removeAt(i);
                widget.onChanged(_inputs);
                setState(() {});
              },
            ),
          ],
        ),
      );
      _widgets.add(SizedBox(height: 8));
    }
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: getForm(),
    );
  }
}
