//
//  ContentView.swift
//  TestePay
//
//  Created by Jean Mário Moreira de Lima on 01/04/26.
//

import SwiftUI

struct ContentView: View {
    @State private var paymentManager = PaymentManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "contactless.payment.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.blue)

                Text("Tap to Pay Prototype")
                    .font(.title.bold())

                VStack(alignment: .leading, spacing: 12) {
                    Text("Token da sessão")
                        .font(.headline)
                    TextField("Cole aqui o token retornado pelo PSP", text: $paymentManager.token)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    Text("Valor")
                        .font(.headline)
                    TextField("5.00", text: $paymentManager.amountText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Status")
                        .font(.headline)
                    Text(paymentManager.statusText)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Evento")
                        .font(.headline)
                        .padding(.top, 8)
                    Text(paymentManager.eventText)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                Button(action: paymentManager.processPayment) {
                    if paymentManager.isReading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Iniciar pagamento")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!paymentManager.canStartPayment)

                Button("Cancelar leitura", role: .destructive, action: paymentManager.cancelCurrentRead)
                    .disabled(!paymentManager.isReading)
            }
            .padding()
            .navigationTitle("TestePay")
        }
    }
}

#Preview {
    ContentView()
}
