import Foundation

protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
}

struct ProductService: ProductServiceProtocol {
    func fetchProducts() async throws -> [Product] {
        // Chamada assíncrona simulando uma requisição de rede antes de retornar os produtos.
        try await Task.sleep(for: .milliseconds(500))

        return [
            Product(
                id: "p1",
                name: "Red Shirt",
                description: "A red shirt - it is pretty red!",
                price: 29.99,
                imageURL: URL(string: "https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg")!
            ),
            Product(
                id: "p2",
                name: "Trousers",
                description: "A nice pair of trousers.",
                price: 59.99,
                imageURL: URL(string: "https://5.imimg.com/data5/LN/PI/JS/SELLER-3749501/corparate-trouser-500x500.jpg")!
            ),
            Product(
                id: "p3",
                name: "Yellow Scarf",
                description: "Warm and cozy - exactly what you need for the winter.",
                price: 19.99,
                imageURL: URL(string: "https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg")!
            ),
            Product(
                id: "p4",
                name: "A Pan",
                description: "Prepare any meal you want.",
                price: 49.99,
                imageURL: URL(string: "https://www.telegraph.co.uk/content/dam/food-and-drink/2018/10/19/Solidteknics_frying-pan_recommended_trans_NvBQzQNjv4BqqVzuuqpFlyLIwiB6NTmJwfSVWeZ_vEN7c6bHu2jJnT8.png?imwidth=960")!
            )
        ]
    }
}
