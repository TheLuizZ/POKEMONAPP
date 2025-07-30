import Foundation
import SwiftUI
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024  // 50MB
    }
    
    func set(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

struct CachedAsyncImage<Content: View>: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    @State private var phase: AsyncImagePhase = .empty
    
    init(url: URL, scale: CGFloat = 1.0, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        content(phase)
            .onAppear {
                loadImage(from: url)
            }
    }
    
    private func loadImage(from url: URL) {
        let urlString = url.absoluteString
        
        // Check cache first
        if let cachedImage = ImageCache.shared.get(forKey: urlString) {
            withTransaction(transaction) {
                phase = .success(Image(uiImage: cachedImage))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    withTransaction(transaction) {
                        phase = .failure(error)
                    }
                }
                return
            }
            
            guard let data = data, let uiImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    withTransaction(transaction) {
                        phase = .failure(URLError(.badServerResponse))
                    }
                }
                return
            }
            
            ImageCache.shared.set(image: uiImage, forKey: urlString)
            
            DispatchQueue.main.async {
                withTransaction(transaction) {
                    phase = .success(Image(uiImage: uiImage))
                }
            }
        }.resume()
    }
}

