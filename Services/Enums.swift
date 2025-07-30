import SwiftUI

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(String)
    case unknown
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError(let message):
            return "Error decoding data: \(message)"
        case .unknown:
            return "Unknown error"
        }
    }
}
