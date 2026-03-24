import SwiftUI

struct ProductCardView: View {
    @Environment(ProductListViewModel.self) private var productListViewModel
    @Environment(CartViewModel.self) private var cartViewModel

    let product: Product

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: product.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 120)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 120)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 120)
                @unknown default:
                    EmptyView()
                }
            }

            HStack {
                Button {
                    productListViewModel.toggleFavorite(for: product)
                } label: {
                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(.orange)
                }

                Spacer()

                Text(product.name)
                    .font(.headline)
                    .lineLimit(1)

                Spacer()

                Button {
                    cartViewModel.add(product)
                } label: {
                    Image(systemName: "cart.badge.plus")
                        .foregroundStyle(.orange)
                }
            }
            .padding(10)
            .background(Color.black.opacity(0.85))
            .foregroundStyle(.white)
        }
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
