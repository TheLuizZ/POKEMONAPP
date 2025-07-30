import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    @Environment(\.presentationMode) var presentationMode
    let pokemonId: Int
    
    var body: some View {
        ScrollView {
            if let pokemon = viewModel.selectedPokemon {
                
                // Pokemon Image
                ZStack(alignment: .top) {
                    VStack(alignment: .trailing) {
                        Rectangle()
                            .fill(pokemon.backgroundColor)
                            .frame( maxWidth: 300)
                            .frame( height: 200)
                            .cornerRadius(25, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                    }
                    .padding(.top, 150)
                    
                    // Back button
                    VStack {
                        HStack {
                            Button(action: {
                                viewModel.resetSelectedPokemon()
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 20, weight: .semibold))
                                    .padding(8)
                                    .background(Color.white.opacity(0.3))
                                    .clipShape(Circle())
                            }
                            .padding(.leading)
                            
                            Text(pokemon.name.capitalized)
                                .font(.body)
                                .foregroundStyle(Color.blueDark)
                            
                            Spacer()
                            
                            Text(pokemon.formattedId)
                                .font(.headline)
                                .foregroundStyle(.gray)
                                .padding(.trailing)
                        }
                        .padding(.top)
                        
                        // Pokemon Image
                        if let imageUrl = pokemon.imageUrl {
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 200, height: 200)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 200)
                                        .padding(.top, 10)
                                case .failure:
                                    Image(systemName: "questionmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 200)
                                        .foregroundStyle(.white)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        // Title Pill
                        HStack {
                            ForEach(pokemon.types, id: \.slot) { type in
                                TitlePillView(type: type.type)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                
                // Physical attributes
                HStack(spacing: 20) {
                    VStack {
                        HStack {
                            Image(systemName: "scalemass")
                                .foregroundStyle(Color.blueSemiDark)
                            Text(pokemon.formattedWeight)
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.blueDark)
                        }
                        Text("Peso")
                            .font(.subheadline)
                            .foregroundStyle(Color.blueSemiDark)
                    }
                    .frame(maxWidth: .infinity)
                    //.background(Color(.gray))
                    .cornerRadius(10)
                    
                    Divider()
                        .frame(height: 50)
                        .background(Color.gray)
                    
                    VStack {
                        HStack {
                            Image(systemName: "ruler")
                                .foregroundStyle(Color.blueSemiDark)
                            Text(pokemon.formattedHeight)
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.blueDark)
                        }
                        Text("Altura")
                            .font(.subheadline)
                            .foregroundStyle(Color.blueSemiDark)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(.white))
                .frame(maxWidth: 300, maxHeight: 80)
                .cornerRadius(25, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                .padding(.bottom, 15)
                
                // Description
                VStack(alignment: .leading) {
                    Text(viewModel.pokemonDescription)
                        .padding(.horizontal, 3)
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Stats
                VStack(alignment: .leading) {
                    Text("Estadísticas")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top)
                        .foregroundStyle(Color.blueDark)
                    
                    ForEach(pokemon.stats, id: \.stat.name) { stat in
                        StatRowView(stat: stat, barColor: pokemon.backgroundColor)
                    }
                }
                .padding(.bottom, 20)
                
            } else {
                VStack {
                    ProgressView("Cargando datos...")
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
        .background(Color.whiteScreen)
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await viewModel.loadPokemonDetail(for: pokemonId)
            }
        }
    }
}




