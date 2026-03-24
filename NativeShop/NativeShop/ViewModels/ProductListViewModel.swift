import Foundation
import Observation

@Observable
@MainActor
final class ProductListViewModel {
    private let service: ProductServiceProtocol

    var products: [Product] = []
    var showOnlyFavorites = false
    var isLoading = false
    var errorMessage: String?

    init(service: ProductServiceProtocol) {
        self.service = service
    }

    var filteredProducts: [Product] {
        showOnlyFavorites ? products.filter(\.isFavorite) : products
    }

    func loadProducts() async {
        guard products.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            // Chamada assíncrona para buscar a lista de produtos no service.
            products = try await service.fetchProducts()
        } catch {
            errorMessage = "Falha ao carregar produtos. Tente novamente."
        }

        isLoading = false
    }

    func toggleFavorite(for product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index].isFavorite.toggle()
    }
}
