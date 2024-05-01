import 'package:flutter/material.dart';

class MultiSelectSignaledReason extends StatefulWidget {
  const MultiSelectSignaledReason({Key? key}) : super(key: key);
  @override
  State<MultiSelectSignaledReason> createState() => _MultiSelectSignaledState();
}

class _MultiSelectSignaledState extends State<MultiSelectSignaledReason> {
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
    /*OTHER: 'other',
  BULLYING: 'bullying',
  BADCOMPORTMENT: 'badcomportment',
  SPAM: 'spam'*/ 
    List<List<String>> categoriesTable = [
      ["Harcèlement", "Description du harcèlement"],
      ["Contenu offensant", "Description du contenu offensant"],
      ["Spam", "Description du spam"],
      ["Autre", "Autre description"]
    ];
    return AlertDialog(
      title: const Text('Sélectionnez une raisons de signalement'),
      content: SingleChildScrollView(
        child: ListBody(
          children: List.generate(categoriesTable.length, (index) {
            return CheckboxListTile(
              title: Text(categoriesTable[index][0]),
              value: _selectedItems.contains(categoriesTable[index]
                  [0]), // Utilisez la catégorie comme identifiant
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked!) {
                    _selectedItems.add(categoriesTable[index]
                        [0]); // Ajoutez la catégorie aux élémens sélectionnés
                  } else {
                    _selectedItems.remove(categoriesTable[index][0]);
                  }
                });
              },
            );
          }),
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
