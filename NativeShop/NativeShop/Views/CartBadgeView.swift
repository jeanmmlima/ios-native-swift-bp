import SwiftUI

struct CartBadgeView: View {
    let count: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart")
                .font(.title3)

            if count > 0 {
                Text("\(count)")
                    .font(.caption2.bold())
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(.orange)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .offset(x: 10, y: -6)
            }
        }
        .accessibilityLabel("Carrinho com \(count) itens")
    }
}
