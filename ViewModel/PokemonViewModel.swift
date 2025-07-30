import Foundation
import SwiftUI
import Combine

class PokemonViewModel: ObservableObject {
    @Published var pokemonList: [PokemonListItem] = []
    @Published var filteredPokemonList: [PokemonListItem] = []
    @Published var selectedPokemon: Pokemon? = nil
    @Published var pokemonDescription: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    
    private let pokemonService = PokemonService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchSubscription()
        Task {
            await loadAllPokemon()
        }
    }
    
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterPokemon(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterPokemon(with searchText: String) {
        guard !searchText.isEmpty else {
            filteredPokemonList = pokemonList
            return
        }
        
        let lowercasedSearchText = searchText.lowercased()
        
        filteredPokemonList = pokemonList.filter { pokemon in
            // Search by name
            if pokemon.name.lowercased().contains(lowercasedSearchText) {
                return true
            }
            
            // Search by ID
            if let searchId = Int(searchText), pokemon.id == searchId {
                return true
            }
            
            return false
        }
    }
    
    @MainActor
    func loadAllPokemon() async {
        isLoading = true
        errorMessage = nil
        
        do {
            pokemonList = try await pokemonService.fetchAllPokemon()
            filteredPokemonList = pokemonList
        } catch let error as NetworkError {
            errorMessage = error.message
        } catch {
            errorMessage = "Unknown error: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    @MainActor
    func loadPokemonDetail(for id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let pokemon = try await pokemonService.fetchPokemonDetail(id: id)
            self.selectedPokemon = pokemon
            
            // Load the description after loading the Pokemon details
            loadPokemonDescription(for: id)
        } catch let error as NetworkError {
            errorMessage = error.message
        } catch {
            errorMessage = "Unknown error: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    @MainActor
    private func loadPokemonDescription(for id: Int) {
        Task {
            do {
                let description = try await pokemonService.fetchPokemonSpecies(id: id)
                self.pokemonDescription = description
            } catch {
                self.pokemonDescription = "The description could not be loaded."
            }
        }
    }
    
    func resetSelectedPokemon() {
        selectedPokemon = nil
        pokemonDescription = ""
    }
}

