import SwiftUI

@main
struct PokemonApp: App {
    @StateObject private var viewModel = PokemonViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PokemonListView()
                    .navigationBarHidden(true)
                    .environmentObject(viewModel)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


