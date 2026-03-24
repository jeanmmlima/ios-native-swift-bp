import SwiftUI

struct ProductListView: View {
    @Environment(ProductListViewModel.self) private var productListViewModel
    @Environment(CartViewModel.self) private var cartViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        @Bindable var productListViewModel = productListViewModel

        NavigationStack {
            Group {
                if productListViewModel.isLoading {
                    ProgressView("Carregando produtos...")
                } else if let message = productListViewModel.errorMessage {
                    ContentUnavailableView("Erro", systemImage: "exclamationmark.triangle", description: Text(message))
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(productListViewModel.filteredProducts) { product in
                                NavigationLink(value: product) {
                                    ProductCardView(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(10)
                    }
                }
            }
            .navigationTitle("Minha Loja")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Filtro") {
                        Button("Somente Favoritos") {
                            productListViewModel.showOnlyFavorites = true
                        }
                        Button("Todos") {
                            productListViewModel.showOnlyFavorites = false
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CartView()
                    } label: {
                        CartBadgeView(count: cartViewModel.itemsCount)
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .task {
                // Chamada assíncrona de carregamento inicial da vitrine de produtos.
                await productListViewModel.loadProducts()
            }
        }
    }
}

#Preview {
    ProductListView()
        .environment(ProductListViewModel(service: ProductService()))
        .environment(CartViewModel())
}
