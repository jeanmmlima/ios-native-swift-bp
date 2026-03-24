import Foundation

struct CartItem: Identifiable, Hashable {
    let id: UUID
    let productId: String
    let name: String
    let price: Double
    var quantity: Int

    var subtotal: Double {
        price * Double(quantity)
    }
}
