import Foundation

protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
    func createProduct(name: String, description: String, price: Double, imageURL: URL) async throws -> Product
    func removeProduct(id: String) async throws
}

struct ProductService: ProductServiceProtocol {
    private let baseURL = URL(string: "https://swiftcap-2713f-default-rtdb.firebaseio.com/")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchProducts() async throws -> [Product] {
        let url = baseURL.appending(path: "products.json")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await session.data(for: request)
        try validate(response: response)

        let decoder = JSONDecoder()
        let dictionary = try decoder.decode([String: FirebaseProductDTO]?.self, from: data) ?? [:]

        return dictionary.compactMap { id, dto in
            guard let imageURL = URL(string: dto.imageURL) else { return nil }
            return Product(
                id: id,
                name: dto.name,
                description: dto.description,
                price: dto.price,
                imageURL: imageURL,
                isFavorite: false,
                isDeleted: dto.isDeleted
            )
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func createProduct(name: String, description: String, price: Double, imageURL: URL) async throws -> Product {
        let url = baseURL.appending(path: "products.json")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = FirebaseCreateProductDTO(
            name: name,
            description: description,
            price: price,
            imageURL: imageURL.absoluteString,
            isDeleted: false
        )
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await session.data(for: request)
        try validate(response: response)

        let result = try JSONDecoder().decode(FirebaseCreateProductResponse.self, from: data)
        guard !result.name.isEmpty else { throw ProductServiceError.invalidResponse }

        return Product(
            id: result.name,
            name: name,
            description: description,
            price: price,
            imageURL: imageURL,
            isFavorite: false,
            isDeleted: false
        )
    }

    func removeProduct(id: String) async throws {
        let url = baseURL.appending(path: "products/\(id).json")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(FirebaseDeletePayload(isDeleted: true))

        let (_, response) = try await session.data(for: request)
        try validate(response: response)
    }
}

private extension ProductService {
    func validate(response: URLResponse) throws {
        guard
            let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            throw ProductServiceError.invalidResponse
        }
    }
}

private enum ProductServiceError: Error {
    case invalidResponse
}

private struct FirebaseProductDTO: Codable {
    let name: String
    let description: String
    let price: Double
    let imageURL: String
    let isDeleted: Bool

    init(name: String, description: String, price: Double, imageURL: String, isDeleted: Bool = false) {
        self.name = name
        self.description = description
        self.price = price
        self.imageURL = imageURL
        self.isDeleted = isDeleted
    }
}

private struct FirebaseCreateProductDTO: Codable {
    let name: String
    let description: String
    let price: Double
    let imageURL: String
    let isDeleted: Bool
}

private struct FirebaseCreateProductResponse: Codable {
    let name: String
}

private struct FirebaseDeletePayload: Codable {
    let isDeleted: Bool
}
