import SwiftUI

struct CardView: View {
    let pokemon: PokemonListItem
    @State private var imageData: Data? = nil
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .frame(height: 160)
                
                VStack {
                    // Pokemon Number
                    HStack {
                        Spacer()
                        Text(String(format: "#%03d", pokemon.id))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .padding(.trailing, 10)
                    }
                    
                    if let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                            case .failure:
                                Image(systemName: "questionmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    // Pokemon Name
                    Text(pokemon.name.capitalized)
                    // .font(.headline)
                        .foregroundStyle(Color.blueDark)
                        .lineLimit(1)
                }
                .padding(.bottom, 8)
            }
        }
    }
}
