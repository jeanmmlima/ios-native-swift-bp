import Foundation
import Observation

@Observable
@MainActor
final class ProductManagementViewModel {
    private let service: ProductServiceProtocol

    var products: [Product] = []
    var isLoading = false
    var isSaving = false
    var errorMessage: String?

    init(service: ProductServiceProtocol) {
        self.service = service
    }

    var activeProducts: [Product] {
        products
            .filter { !$0.isDeleted }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var deletedProducts: [Product] {
        products
            .filter(\.isDeleted)
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func loadProducts(forceReload: Bool = false) async {
        guard forceReload || products.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            products = try await service.fetchProducts()
        } catch {
            errorMessage = "Falha ao carregar produtos."
        }

        isLoading = false
    }

    func createProduct(name: String, description: String, price: Double, imageURL: URL) async -> Product? {
        isSaving = true
        errorMessage = nil

        defer { isSaving = false }

        do {
            let created = try await service.createProduct(
                name: name,
                description: description,
                price: price,
                imageURL: imageURL
            )
            products.append(created)
            return created
        } catch {
            errorMessage = "Não foi possível cadastrar o produto."
            return nil
        }
    }

    func removeProduct(_ product: Product) async -> Bool {
        isSaving = true
        errorMessage = nil

        defer { isSaving = false }

        do {
            try await service.removeProduct(id: product.id)
            guard let index = products.firstIndex(where: { $0.id == product.id }) else { return true }
            products[index].isDeleted = true
            return true
        } catch {
            errorMessage = "Não foi possível remover o produto."
            return false
        }
    }
}
