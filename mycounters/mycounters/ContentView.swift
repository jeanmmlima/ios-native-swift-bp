//
//  ContentView.swift
//  mycounters
//
//  Created by Jean Mário Moreira de Lima on 22/03/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            VStack {
                Text("Meus Contadores")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                Spacer()

                VStack(spacing: 30) {
                    CounterView()
                    CounterView()
                    CounterView()
                }
                .padding()

                Spacer()
            }
        }
}

#Preview {
    ContentView()
}
