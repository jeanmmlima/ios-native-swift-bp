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

    private var activeProducts: [Product] {
        products.filter { !$0.isDeleted }
    }

    var filteredProducts: [Product] {
        showOnlyFavorites ? activeProducts.filter(\.isFavorite) : activeProducts
    }

    func loadProducts(forceReload: Bool = false) async {
        guard forceReload || products.isEmpty else { return }

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

    func appendCreatedProduct(_ product: Product) {
        products.append(product)
    }

    func createProduct(name: String, description: String, price: Double, imageURL: URL) async -> Bool {
        errorMessage = nil

        do {
            let created = try await service.createProduct(
                name: name,
                description: description,
                price: price,
                imageURL: imageURL
            )
            products.append(created)
            return true
        } catch {
            errorMessage = "Não foi possível cadastrar o produto."
            return false
        }
    }

    func markProductAsDeleted(id: String) {
        guard let index = products.firstIndex(where: { $0.id == id }) else { return }
        products[index].isDeleted = true
    }

    func toggleFavorite(for product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index].isFavorite.toggle()
    }
}
