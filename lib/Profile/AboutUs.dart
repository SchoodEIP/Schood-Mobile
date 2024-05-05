import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Profile/ContactPage.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.purpleSchood),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:  SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const H1TextApp(
              text: "À propos de nous",
            ),
             Padding(
              padding: const EdgeInsets.all(16),
              child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const H4TextApp(
                text:
"Schood a pour objectif est de mettre en place une écoute et une synthèse des ressentis des jeunes de manière hebdomadaire et accessible."              ),
              SizedBox(height: 30,),
              H2TextApp(text: "L'équipe:"),
            Center(child:Container(
        width: 150, // Largeur du conteneur
        height: 150, // Hauteur du conteneur
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('lib/assets/Adrien.png'), // Chemin de l'image
            fit: BoxFit.cover, // Ajustement de l'image pour couvrir le conteneur
          ),
        ),)),
    const Center(child:H3TextApp(text: "Adrien BUSNEL", color: AppColors.purpleSchood,)),
            const Center(child:H4TextApp(text: "Développeur Web",color: AppColors.purpleSchood)),
        
                        SizedBox(height: 30,),
            Center(child:Container(
        width: 150, // Largeur du conteneur
        height: 150, // Hauteur du conteneur
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('lib/assets/Eleonore.png'), // Chemin de l'image
            fit: BoxFit.cover, // Ajustement de l'image pour couvrir le conteneur
          ),
        ),)), 
    const Center(child:H3TextApp(text: "Eléonore Wichegrod", color: AppColors.purpleSchood,)),
            const Center(child:H4TextApp(text: "Développeur Web",color: AppColors.purpleSchood)),
        
  SizedBox(height: 30,),
            Center(child:Container(
        width: 150, // Largeur du conteneur
        height: 150, // Hauteur du conteneur
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('lib/assets/Nathan.png'), // Chemin de l'image
            fit: BoxFit.cover, // Ajustement de l'image pour couvrir le conteneur
          ),
        ),)),
    const Center(child:H3TextApp(text: "Nathan DUCHESNE", color: AppColors.purpleSchood,)),
            const Center(child:H4TextApp(text: "Développeur Back-end",color: AppColors.purpleSchood)),
        
SizedBox(height: 30,),
            Center(child:Container(
        width: 150, // Largeur du conteneur
        height: 150, // Hauteur du conteneur
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('lib/assets/Quentin.png'), // Chemin de l'image
            fit: BoxFit.cover, // Ajustement de l'image pour couvrir le conteneur
          ),
        ),)),
    const Center(child:H3TextApp(text: "Quentin MANANES", color: AppColors.purpleSchood,)),
            const Center(child:H4TextApp(text: "Développeur Back-end",color: AppColors.purpleSchood)),
        
            SizedBox(height: 30,),
            Center(child:Container(
        width: 150, // Largeur du conteneur
        height: 150, // Hauteur du conteneur
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('lib/assets/Mateo.png'), // Chemin de l'image
            fit: BoxFit.cover, // Ajustement de l'image pour couvrir le conteneur
          ),
        ),)),
    const Center(child:H3TextApp(text: "Matéo DEROCHE", color: AppColors.purpleSchood,)),
            const Center(child:H4TextApp(text: "Développeur Mobile et Desktop",color: AppColors.purpleSchood)),
        
SizedBox(height: 30,),
            Center(child:Container(
        width: 150, // Largeur du conteneur
        height: 150, // Hauteur du conteneur
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('lib/assets/Axel.png'), // Chemin de l'image
            fit: BoxFit.cover, // Ajustement de l'image pour couvrir le conteneur
          ),
        ),)),

            const Center(child:H3TextApp(text: "Axel LEBLOND", color: AppColors.purpleSchood,)),
            const Center(child:H4TextApp(text: "Développeur Mobile",color: AppColors.purpleSchood)),
            
        ]))],
        ),
      ),
    );
  }
}
