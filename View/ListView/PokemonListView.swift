import SwiftUI

struct PokemonListView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    @Environment(\.colorScheme) var colorScheme
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image("IconPokeball")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.blue)
                    .padding(.trailing,10)
                
                Text("Pokédex")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color(hex: "#005FFF"))
                
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 20)
            
            // Welcome message
            HStack {
                Text("¡Hola, ")
                    .font(.title2)
                    .foregroundStyle(Color.blueDark)
                
                Text("bienvenido!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.blueDark)
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                TextField("", text: $viewModel.searchText)
                    .placeholder(when: viewModel.searchText.isEmpty) {
                        Text("Buscar")
                            .foregroundStyle(.gray)
                    }
                    .foregroundStyle(.black)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.black)
                    }
                }
                ZStack{
                    Circle()
                        .fill(.yellow)
                        .frame(height: 30)
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.blueDark)
                }
                .padding(.trailing, -10)
            }
            .frame(maxHeight: 10)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(.gray), lineWidth: 1)
                    )
            )
            .padding(.horizontal)
            
            if !viewModel.searchText.isEmpty {
                Text("Resultado de búsqueda")
                    .foregroundStyle(.gray)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
            }
            
            if viewModel.isLoading && viewModel.pokemonList.isEmpty {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                VStack {
                    Text("Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)
                    
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Reintentar") {
                        Task {
                            await viewModel.loadAllPokemon()
                        }
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                Spacer()
            } else {
                // Pokemon Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.filteredPokemonList, id: \.id) { pokemon in
                            NavigationLink(destination: {
                                PokemonDetailView(pokemonId: pokemon.id)
                                    .environmentObject(viewModel)
                            }) {
                                CardView(pokemon: pokemon)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
            
            // Message results found
            if viewModel.filteredPokemonList.isEmpty && !viewModel.pokemonList.isEmpty {
                Spacer()
                Text("No se encontraron resultados")
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .padding()
                Spacer()
            }
        }
        .background(Color.whiteScreen)
        .navigationBarHidden(true)
        .onAppear {
            // Reset any previously selected Pokemon
            viewModel.resetSelectedPokemon()
        }
    }
}
