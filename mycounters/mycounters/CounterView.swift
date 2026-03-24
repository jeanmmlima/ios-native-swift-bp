//
//  CounterView.swift
//  mycounters
//
//  Created by Jean Mário Moreira de Lima on 22/03/26.
//
import SwiftUI

struct CounterView: View {
    @State private var count: Int = 0

    var body: some View {
        VStack(spacing: 15) {
            Text("Valor: \(count)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            HStack(spacing: 20) {
                Button(action: {
                    count -= 1
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button(action: {
                    count += 1
                }) {
                    Text("Aumentar")
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color.secondary.opacity(0.1)))
    }
}

#Preview {
    CounterView()
}
