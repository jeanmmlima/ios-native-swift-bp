import SwiftUI

struct ProductListView: View {
    @Environment(ProductListViewModel.self) private var productListViewModel
    @Environment(CartViewModel.self) private var cartViewModel
    @State private var isPresentingCreateProduct = false
    @State private var isCreatingProduct = false

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
                    HStack(spacing: 8) {
                        Menu {
                            Button("Cadastrar Produto", systemImage: "plus.circle") {
                                isPresentingCreateProduct = true
                            }
                            NavigationLink("Gerenciar Produtos", destination: ProductManagementView())
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }

                        NavigationLink {
                            CartView()
                        } label: {
                            CartBadgeView(count: cartViewModel.itemsCount)
                        }
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .sheet(isPresented: $isPresentingCreateProduct) {
                NavigationStack {
                    ProductFormView(isSaving: isCreatingProduct) { name, description, price, imageURL in
                        isCreatingProduct = true
                        defer { isCreatingProduct = false }

                        return await productListViewModel.createProduct(
                            name: name,
                            description: description,
                            price: price,
                            imageURL: imageURL
                        )
                    }
                }
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
