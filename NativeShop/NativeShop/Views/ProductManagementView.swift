import SwiftUI

struct ProductManagementView: View {
    @Environment(ProductListViewModel.self) private var productListViewModel
    @State private var viewModel = ProductManagementViewModel(service: ProductService())
    @State private var isPresentingCreate = false

    var body: some View {
        @Bindable var viewModel = viewModel

        List {
            Section("Produtos Atuais") {
                if viewModel.activeProducts.isEmpty {
                    Text("Nenhum produto ativo.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.activeProducts) { product in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.headline)
                            Text(product.price, format: .currency(code: "BRL"))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    let removed = await viewModel.removeProduct(product)
                                    if removed {
                                        productListViewModel.markProductAsDeleted(id: product.id)
                                    }
                                }
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                        }
                    }
                }
            }

            Section("Produtos Excluídos") {
                if viewModel.deletedProducts.isEmpty {
                    Text("Nenhum produto excluído.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.deletedProducts) { product in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.headline)
                            Text("Excluído")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Carregando...")
            }
        }
        .navigationTitle("Gerenciar Produtos")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresentingCreate = true
                } label: {
                    Label("Cadastrar", systemImage: "plus")
                }
                .disabled(viewModel.isSaving)
            }
        }
        .sheet(isPresented: $isPresentingCreate) {
            NavigationStack {
                ProductFormView(isSaving: viewModel.isSaving) { name, description, price, imageURL in
                    guard let created = await viewModel.createProduct(
                        name: name,
                        description: description,
                        price: price,
                        imageURL: imageURL
                    ) else {
                        return false
                    }

                    productListViewModel.appendCreatedProduct(created)
                    return true
                }
            }
        }
        .task {
            await viewModel.loadProducts()
        }
        .refreshable {
            await viewModel.loadProducts(forceReload: true)
        }
        .alert("Erro", isPresented: Binding(get: {
            viewModel.errorMessage != nil
        }, set: { newValue in
            if !newValue {
                viewModel.errorMessage = nil
            }
        })) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    NavigationStack {
        ProductManagementView()
            .environment(ProductListViewModel(service: ProductService()))
    }
}
