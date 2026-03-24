import Foundation
import Observation

@Observable
@MainActor
final class CartViewModel {
    private(set) var items: [String: CartItem] = [:]

    var itemsCount: Int {
        items.count
    }

    var itemList: [CartItem] {
        items.values.sorted { $0.name < $1.name }
    }

    var totalAmount: Double {
        items.values.reduce(0) { $0 + $1.subtotal }
    }

    func add(_ product: Product) {
        if var existing = items[product.id] {
            existing.quantity += 1
            items[product.id] = existing
        } else {
            items[product.id] = CartItem(
                id: UUID(),
                productId: product.id,
                name: product.name,
                price: product.price,
                quantity: 1
            )
        }
    }

    func remove(productId: String) {
        items.removeValue(forKey: productId)
    }

    func clear() {
        items.removeAll()
    }
}
