import SwiftUI

@main
struct NativeShopApp: App {
    @State private var productListViewModel = ProductListViewModel(service: ProductService())
    @State private var cartViewModel = CartViewModel()

    var body: some Scene {
        WindowGroup {
            ProductListView()
                .environment(productListViewModel)
                .environment(cartViewModel)
        }
    }
}
