# POKEMONAPP
Una App Pokédex desarrollada en Swift que muestra los 151 Pokémon de la primera generación utilizando la PokeAPI.

## 📋 Descripción
Lista de los 151 Pokémon originales
Búsqueda por nombre o ID
Vista detallada de cada Pokémon
Estadísticas visuales de cada Pokémon
Información detallada (peso, altura, descripción)
Interfaz en español

## 🖥️ Tecnologías utilizadas:
Swift 5.5+
SwiftUI para la interfaz de usuario
UIKit para componentes específicos
Autolayout para una interfaz adaptable
Arquitectura MVVM (Model-View-ViewModel)
Async/Await para llamadas asíncronas a la API
PokeAPI como fuente de datos

## 🗂️ Estructura del proyecto
PokemonApp/
├── Assets.xcassets/
│   ├── AppIcon.appiconset/
│   │    └── AppIcon.png
│   └── IconPokeball.imageset/
│        └── Componente de imagen.heic
├── Models/
│   └── Pokemon.swift
├── Views/
│   ├── DetailView/
│   │     ├── PokemonListView.swift
│   │     └── CardView.swift
│   └── ListView/
│         ├── PokemonDetailView.swift
│         ├── StatRowView.swift
│         └── TitlePillView.swift
├── ViewModels/
│   └── PokemonViewModel.swift
├── Services/
│   ├── PokemonService.swift
│   └── Enums.swift
├── Utils/
│   ├── Color+Extensions.swift
│   └── ImageCache.swift
└── PokemonApp.swift

## ✅ Requisitos
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## 🚀 Instalación
1. Clona el repositorio
2. Abre el proyecto en Xcode
3. Selecciona un simulador o dispositivo iOS
4. Presiona ⌘+R para ejecutar la aplicación

## ⚙️ Funcionamiento
La pantalla principal muestra una lista de los 151 Pokémon originales
Usa la barra de búsqueda para buscar por nombre o número de Pokémon
Toca en cualquier Pokémon para ver sus detalles
En la vista detallada, puedes ver:
Imagen oficial del Pokémon
Tipo(s) del Pokémon
Peso y altura
Descripción
Estadísticas con barras visuales

## 👨‍💻 Autor
Luiz Martinez -  [@TheLuizz](https://github.com/TheLuizz)
