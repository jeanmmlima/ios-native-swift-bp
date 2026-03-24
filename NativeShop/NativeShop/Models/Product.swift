import Foundation

struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageURL: URL
    var isFavorite: Bool = false
}
