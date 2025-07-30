import Foundation

class PokemonService {
    private let baseUrl = "https://pokeapi.co/api/v2"
    
    // Pokemon Gen 1
    func fetchAllPokemon() async throws -> [PokemonListItem] {
        guard let url = URL(string: "\(baseUrl)/pokemon?limit=151") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(PokemonListResponse.self, from: data)
            return result.results
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
    
    // Pokemon details
    func fetchPokemonDetail(id: Int) async throws -> Pokemon {
        guard let url = URL(string: "\(baseUrl)/pokemon/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Pokemon.self, from: data)
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
    
    // Pokemon descriptions
    func fetchPokemonSpecies(id: Int) async throws -> String {
        guard let url = URL(string: "\(baseUrl)/pokemon-species/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let speciesData = try decoder.decode(PokemonSpeciesResponse.self, from: data)
            
            if let spanishEntry = speciesData.flavorTextEntries.first(where: { $0.language.name == "es" }) {
                return spanishEntry.flavorText.replacingOccurrences(of: "\n", with: " ")
            }
            
            if let englishEntry = speciesData.flavorTextEntries.first(where: { $0.language.name == "en" }) {
                return englishEntry.flavorText.replacingOccurrences(of: "\n", with: " ")
            }
            
            return "There is no description available for this Pokémon."
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
}
