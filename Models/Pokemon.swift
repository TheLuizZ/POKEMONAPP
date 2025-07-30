import Foundation
import SwiftUI

struct Pokemon: Identifiable, Decodable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let sprites: Sprites
    let weight: Int
    let height: Int
    let stats: [Stat]
    
    var formattedId: String {
        String(format: "#%03d", id)
    }
    
    var imageUrl: URL? {
        URL(string: sprites.other.officialArtwork.frontDefault)
    }
    
    var backgroundColor: Color {
        if let firstType = types.first {
            return firstType.type.color
        }
        return .gray
    }
    
    var formattedWeight: String {
        let weightInKg = Double(weight) / 10.0
        return String(format: "%.1f kg", weightInKg)
    }
    
    var formattedHeight: String {
        let heightInMeters = Double(height) / 10.0
        return String(format: "%.1f m", heightInMeters)
    }
    
    var description: String {
        // This would be filled with actual data from the API
        // For demo purposes, we'll return a placeholder
        return "Este Pokémon tiene características especiales que lo distinguen."
    }
}

struct Sprites: Decodable {
    let frontDefault: String
    let other: OtherSprites
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

struct OtherSprites: Decodable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonType: Decodable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Decodable {
    let name: String
    let url: String
    
    var color: Color {
        switch name {
        case "normal": return Color(hex: "#7C7C7C")
        case "fire": return Color(hex: "#FF4210")
        case "water": return Color(hex: "#005FFF")
        case "electric": return Color(hex: "#FFC600")
        case "grass": return Color(hex: "#65D498")
        case "ice": return Color(hex: "#9BB8D3")
        case "fighting": return Color(hex: "#FFA800")
        case "poison": return Color(hex: "#760EFC")
        case "ground": return Color(hex: "#4D3030")
        case "flying": return Color(hex: "#FF94F2")
        case "psychic": return Color(hex: "FF94F2")
        case "bug": return Color(hex: "#779161")
        case "rock": return Color(hex: "#584087")
        case "ghost": return Color(hex: "#584087")
        case "dragon": return Color(hex: "#596CC2")
        case "dark": return Color(hex: "#404040")
        case "steel": return Color(hex: "#59BDC2")
        case "fairy": return Color(hex: "#E8D6FF")
        default: return Color.gray
        }
    }
    
    var displayName: String {
        switch name {
        case "normal": return "Normal"
        case "fire": return "Fuego"
        case "water": return "Agua"
        case "electric": return "Eléctrico"
        case "grass": return "Planta"
        case "ice": return "Hielo"
        case "fighting": return "Lucha"
        case "poison": return "Veneno"
        case "ground": return "Tierra"
        case "flying": return "Volador"
        case "psychic": return "Psíquico"
        case "bug": return "Bicho"
        case "rock": return "Roca"
        case "ghost": return "Fantasma"
        case "dragon": return "Dragón"
        case "dark": return "Siniestro"
        case "steel": return "Acero"
        case "fairy": return "Hada"
        default: return name.capitalized
        }
    }
}

struct Stat: Decodable {
    let baseStat: Int
    let stat: StatInfo
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
    
    var displayName: String {
        switch stat.name {
        case "hp": return "HP"
        case "attack": return "Ataque"
        case "defense": return "Defensa"
        case "special-attack": return "Ataque especial"
        case "special-defense": return "Defensa especial"
        case "speed": return "Velocidad"
        default: return stat.name.capitalized
        }
    }
    
    var formattedStat: String {
        return String(format: "%03d", baseStat)
    }
    
    var normalizedValue: CGFloat {
        return CGFloat(baseStat) / 255.0
    }
}

struct StatInfo: Decodable {
    let name: String
}

// Response models for the API
struct PokemonListResponse: Decodable {
    let count: Int
    let results: [PokemonListItem]
}

struct PokemonListItem: Decodable {
    let name: String
    let url: String
    
    var id: Int {
        guard let idString = url.split(separator: "/").last else { return 0 }
        return Int(idString) ?? 0
    }
}

struct PokemonSpeciesResponse: Decodable {
    let flavorTextEntries: [FlavorTextEntry]
    
    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
    }
}

struct FlavorTextEntry: Decodable {
    let flavorText: String
    let language: Language
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
}

struct Language: Decodable {
    let name: String
}
