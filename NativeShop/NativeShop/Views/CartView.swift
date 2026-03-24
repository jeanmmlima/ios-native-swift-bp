import SwiftUI

struct CartView: View {
    @Environment(CartViewModel.self) private var cartViewModel

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 10) {
                HStack {
                    Text("Total")
                        .font(.title3)
                    Spacer()
                    Text(cartViewModel.totalAmount, format: .currency(code: "BRL"))
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.pink)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }

                HStack {
                    Spacer()
                    Button("COMPRAR") {
                        cartViewModel.clear()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            if cartViewModel.itemList.isEmpty {
                ContentUnavailableView("Carrinho vazio", systemImage: "cart")
            } else {
                List {
                    ForEach(cartViewModel.itemList) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.name)
                                .font(.headline)
                            Text("Total: \(item.subtotal, format: .currency(code: "BRL"))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .overlay(alignment: .trailing) {
                            Text("\(item.quantity)x")
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                cartViewModel.remove(productId: item.productId)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Carrinho")
    }
}
