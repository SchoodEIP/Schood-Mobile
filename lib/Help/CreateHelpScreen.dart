import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;
import 'package:collection/collection.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:flutter/services.dart';

class CreateHelpScreen extends StatefulWidget {
  const CreateHelpScreen({Key? key}) : super(key: key);

  @override
  _CreateHelpScreenState createState() => _CreateHelpScreenState();
}

class _CreateHelpScreenState extends State<CreateHelpScreen> {
  List<Map<String, dynamic>> categories = [];
  String? selectedCategory;
  String? selectedCategoryId;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController newCategoryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getcategory();
  }
_createhelp() async {
  if (!_formKey.currentState!.validate()) {
    // Affiche une alerte si le formulaire n'est pas valide
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erreur"),
          content: Text("Veuillez remplir tous les champs correctement"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return; // Arrêter la fonction si le formulaire n'est pas valide
  }

  // Si l'utilisateur a saisi une nouvelle catégorie
  if (newCategoryController.text.isNotEmpty) {
    // Vérifier si la catégorie existe déjà avant de créer une nouvelle
    bool categoryExists = await _checkIfCategoryExists(newCategoryController.text);
    
    if (categoryExists) {
      // Si la catégorie existe, afficher un message d'alerte
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Cette catégorie existe déjà"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Arrêter la création si la catégorie existe
    } else {
      // Si la catégorie n'existe pas, la créer
      await _createcategoryhelp();
    }
  } else if (selectedCategoryId == null) {
    // Si aucune catégorie n'est sélectionnée
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erreur"),
          content: Text("Veuillez sélectionner une catégorie"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return; // Arrêter la création si aucune catégorie n'est sélectionnée
  }

  // Si tout est correct, procéder à la création
  print("Selected Category ID: $selectedCategoryId");

  var data = {
    "email": emailController.text,
    "name": nameController.text,
    "telephone": telephoneController.text,
    "helpNumbersCategory": selectedCategoryId, // Utilise l'ID de la catégorie sélectionnée
    "description": descriptionController.text
  };

  // Envoyer la requête pour créer l'entrée d'aide
  final postdata = PostClass();
  final response = await postdata.postDataAuth(context, data, "adm/helpNumber/register");
  print(response.statusCode);

  if (response.statusCode == 200) { // Vérifiez si la réponse indique une création réussie
    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aide créée avec succès !'),
      ),
    );
    // Réinitialiser les champs du formulaire après la création réussie
    _resetForm();
                  Navigator.of(context).pop();
  } else {
    // Gérer les erreurs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur lors de la création de l’aide.'),
      ),
    );
  }
}

void _resetForm() {
  // Réinitialiser les contrôleurs et autres champs du formulaire
  emailController.clear();
  nameController.clear();
  telephoneController.clear();
  descriptionController.clear();
  newCategoryController.clear();
  setState(() {
    selectedCategoryId = null;
    selectedCategory = null;
  });
}

_checkIfCategoryExists(String categoryName) async {
  // Récupérer la liste des catégories
  final getdata = GetClass();
  final response = await getdata.getData(global.globalToken, "user/helpNumbersCategories");
  
  if (response.statusCode == 200) {
    List<dynamic> categories = jsonDecode(response.body);
    // Vérifier si le nom de la catégorie existe déjà
    for (var category in categories) {
      if (category['name'] == categoryName) {
        return true; // La catégorie existe déjà
      }
    }
  }
  return false; // La catégorie n'existe pas
}

_createcategoryhelp() async {
  // Étape 1: Envoyer les données pour créer la nouvelle catégorie
  final postdata = PostClass();
  var data = {
    'name': newCategoryController.text
  };
  
  final response = await postdata.postDataAuth(context, data, "adm/helpNumbersCategory/register");

  // Étape 2: Récupérer la liste des catégories après l'ajout
  final getdata = GetClass();
  final response2 = await getdata.getData(global.globalToken, "user/helpNumbersCategories");

  // Étape 3: Extraire les catégories du corps de la réponse
  List<dynamic> categories = jsonDecode(response2.body);

  // Étape 4: Trouver la catégorie qui correspond au nom ajouté
  for (var category in categories) {
    if (category['name'] == newCategoryController.text) {
      // Étape 5: Stocker l'ID de la catégorie dans la variable selectedCategoryId
      selectedCategoryId = category['_id'];
      print("ID de la nouvelle catégorie sélectionnée: $selectedCategoryId");
      break; // Quitter la boucle après avoir trouvé la catégorie
    }
  }
}



  _getcategory() async {
    final getdata = GetClass();
    final response = await getdata.getData(global.globalToken, "user/helpNumbersCategories");

    if (response.statusCode == 200) {
      setState(() {
        categories = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }

  _addNewCategory(BuildContext context) {
  // Avant d'ouvrir la boîte de dialogue, vérifier si une nouvelle catégorie a déjà été ajoutée
  setState(() {
    if (categories.isNotEmpty && categories.last['isNew'] == true) {
      // Si la dernière catégorie a été marquée comme nouvelle, on la retire
      categories.removeLast();
    }
  });

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Ajouter une catégorie"),
        content: TextField(
          controller: newCategoryController,
          decoration: InputDecoration(
            labelText: 'Nom de la catégorie',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Ajouter"),
            onPressed: () {
              setState(() {
                String newCategory = newCategoryController.text;
                if (newCategory.isNotEmpty) {
                  // Vérifier si le nom existe déjà
                  var existingCategory = categories.firstWhere(
                    (category) => category['name'] == newCategory,
                    orElse: () => {}, // Retourner une map vide plutôt que null
                  );

                  // Utiliser isNotEmpty pour vérifier l'existence de la catégorie
                  if (existingCategory.isNotEmpty) {
                    // Afficher un message si la catégorie existe déjà
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cette catégorie existe déjà'),
                      ),
                    );
                  } else {
                    // Ajouter une nouvelle catégorie avec un ID unique et marquer comme nouvelle
                    String newCategoryId = DateTime.now().millisecondsSinceEpoch.toString();
                    categories.add({
                      '_id': newCategoryId,
                      'name': newCategory,
                      'isNew': true, // Marquer cette catégorie comme nouvelle
                    });
                    
                    // Mettre à jour selectedCategoryId après l'ajout de la nouvelle catégorie
                    selectedCategoryId = newCategoryId;
                    selectedCategory = newCategory;  // Mettre à jour le nom également
                  }
                }
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
selectedCategoryId = "";
selectedCategory = "";
newCategoryController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.arrow_back,
                color: AppColors.purpleSchood,
              ),
              SizedBox(width: 8),
              H4TextApp(
                text: "Retour",
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const H1TextApp(text: "Créer une aide"),
                const SizedBox(height: 20.0),
               DropdownButtonFormField<String>(
  dropdownColor: themeProvider.getBackgroundColor(),
  value: categories.any((cat) => cat['_id'] == selectedCategoryId) ? selectedCategoryId : null, // Vérifie que l'ID est valide
  onChanged: (String? value) {
    setState(() {
      if (value != null) {
        if (value == 'add_new_category') {
          _addNewCategory(context);
        } else {
          selectedCategoryId = value;
          var selectedCat = categories.firstWhereOrNull((cat) => cat['_id'] == selectedCategoryId);
          print(selectedCat);
          if (selectedCat != null) {
            selectedCategory = selectedCat['name'];
          }
        }
      }
    });
  },
  items: [
    ...categories.map((category) {
      return DropdownMenuItem<String>(
        value: category['_id'], // Utiliser l'ID comme valeur unique
        child: H4TextApp(text: category['name']),
      );
    }).toList(),
    DropdownMenuItem<String>(
      value: 'add_new_category',
      child: H4TextApp(text: "Ajouter une catégorie"),
    ),
  ],
  decoration: InputDecoration(
    labelText: 'Catégorie',
    labelStyle: GoogleFonts.inter(
      color: themeProvider.getTextColor(),
      fontSize: 18,
    ),
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez sélectionner une catégorie';
    }
    return null;
  },
),

                const SizedBox(height: 20.0),
                TextFormField(
                  controller: emailController,
                  style: TextStyle(color: AppColors.backgroundDarkmode),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: themeProvider.backgroundDarkMode),
                    fillColor: AppColors.pinkSchood,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: nameController,
                  style: TextStyle(color: AppColors.backgroundDarkmode),
                  decoration: InputDecoration(
                    hintText: 'Nom',
                    hintStyle: TextStyle(color: themeProvider.backgroundDarkMode),
                    fillColor: AppColors.pinkSchood,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: telephoneController,
                  style: TextStyle(color: AppColors.backgroundDarkmode),
                  decoration: InputDecoration(
                    hintText: 'Numéro téléphone',
                    hintStyle: TextStyle(color: themeProvider.backgroundDarkMode),
                    fillColor: AppColors.pinkSchood,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le numéro de téléphone';
                    }
                    if (value.length != 10) {
                      return 'Le numéro de téléphone doit contenir exactement 10 chiffres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: descriptionController,
                  style: TextStyle(color: AppColors.backgroundDarkmode),
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: themeProvider.backgroundDarkMode),
                    fillColor: AppColors.pinkSchood,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                   onPressed: _createhelp,
                   child: H4TextApp(text: "Créer", color: AppColors.textDarkmode,),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purpleSchood,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),)
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
