import 'package:flutter/material.dart';

class Person {
  final String id;
  final String firstname;
  final String lastname;

  Person({required this.id, required this.firstname, required this.lastname});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}

class MultiSelect extends StatefulWidget {
  const MultiSelect({Key? key, required this.persons}) : super(key: key);
  @override
  final List<Person> persons;
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];
  void _itemChange(String itemId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemId);
      } else {
        _selectedItems.remove(itemId);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sélectionnez des utilisateurs'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.persons
              .map((person) => CheckboxListTile(
                    value: _selectedItems.contains(person.id),
                    title: Text('${person.firstname} ${person.lastname}'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) =>
                        _itemChange(person.id, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Valider'),
        ),
      ],
    );
  }
}
