import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: product.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 240)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, minHeight: 240)
                    @unknown default:
                        EmptyView()
                    }
                }

                Text(product.name)
                    .font(.title2.bold())

                Text(product.description)
                    .font(.body)
                    .foregroundStyle(.secondary)

                Text(product.price, format: .currency(code: "BRL"))
                    .font(.headline)
                    .foregroundStyle(.orange)
            }
            .padding()
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
