//
//  ContentView.swift
//  NativeRes
//
//  Created by Jean Mário Moreira de Lima on 26/03/26.
//

import SwiftUI
import UIKit
import Combine

struct ContentView: View {
    @StateObject private var proximity = ProximitySensorModel()

    var body: some View {
        VStack(spacing: 16) {
            Text(proximity.statusMessage)
                .multilineTextAlignment(.center)
                .padding()

            Button(proximity.isMonitoring ? "Parar monitoramento" : "Iniciar monitoramento") {
                proximity.toggleMonitoring()
            }
            .buttonStyle(.borderedProminent)

            Text("Disponível neste dispositivo: \(proximity.isSensorAvailable ? "Sim" : "Não")")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

final class ProximitySensorModel: NSObject, ObservableObject {
    @Published var statusMessage = "Toque em iniciar para monitorar o sensor de proximidade."
    @Published var isMonitoring = false
    @Published var isSensorAvailable = true

    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(proximityDidChange),
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.isProximityMonitoringEnabled = false
    }

    func toggleMonitoring() {
        if isMonitoring {
            UIDevice.current.isProximityMonitoringEnabled = false
            isMonitoring = false
            statusMessage = "Monitoramento pausado."
            return
        }

        UIDevice.current.isProximityMonitoringEnabled = true
        isMonitoring = UIDevice.current.isProximityMonitoringEnabled
        isSensorAvailable = isMonitoring

        if !isMonitoring {
            statusMessage = "Este dispositivo não tem sensor de proximidade acessível."
            return
        }

        statusMessage = UIDevice.current.proximityState
            ? "Objeto próximo do sensor."
            : "Nenhum objeto próximo do sensor."
    }

    @objc private func proximityDidChange() {
        DispatchQueue.main.async {
            guard self.isMonitoring else {
                return
            }
            self.statusMessage = UIDevice.current.proximityState
                ? "Objeto próximo do sensor."
                : "Nenhum objeto próximo do sensor."
        }
    }
}
