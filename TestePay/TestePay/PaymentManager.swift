//
//  PaymentManager.swift
//  TestePay
//
//  Created by Jean Mário Moreira de Lima on 01/04/26.
//

import Foundation
import ProximityReader // Framework para Tap to Pay
import Observation

@Observable
@MainActor // Garante segurança de UI para todas as propriedades
class PaymentManager {
    var token = ""
    var amountText = "5.00"
    var currencyCode = "BRL"
    var statusText = "Pronto para receber"
    var eventText = "Nenhum evento ainda"
    var isReading = false

    private let reader = PaymentCardReader()
    private var eventTask: Task<Void, Never>?
    private var currentSession: PaymentCardReaderSession?

    var canStartPayment: Bool {
        !isReading && !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && decimalAmount != nil
    }

    private var decimalAmount: Decimal? {
        Decimal(string: amountText.replacingOccurrences(of: ",", with: "."))
    }

    func processPayment() {
        guard PaymentCardReader.isSupported else {
            statusText = "Tap to Pay não disponível neste dispositivo."
            eventText = "Use um iPhone físico compatível (simulador não suporta)."
            return
        }

        guard let amount = decimalAmount else {
            statusText = "Valor inválido."
            eventText = "Informe um valor numérico válido."
            return
        }

        isReading = true
        statusText = "Preparando leitor..."
        eventText = "Iniciando sessão"

        Task {
            do {
                let tokenValue = PaymentCardReader.Token(rawValue: token.trimmingCharacters(in: .whitespacesAndNewlines))
                try await ensureAccountIsLinked(using: tokenValue)
                let session = try await reader.prepare(using: tokenValue)
                currentSession = session

                startListeningForReaderEvents()
                statusText = "Aproxime cartão, celular ou relógio do iPhone"

                let request = PaymentCardTransactionRequest(
                    amount: amount,
                    currencyCode: currencyCode.uppercased(),
                    for: .purchase
                )
                let result = try await session.readPaymentCard(request)

                statusText = successMessage(for: amount, result: result)
                eventText = "Leitura concluída: \(result.id)"
            } catch {
                statusText = "Erro: \(error.localizedDescription)"
                eventText = errorMessage(for: error)
            }

            stopListeningForReaderEvents()
            currentSession = nil
            isReading = false
        }
    }

    func cancelCurrentRead() {
        guard isReading else { return }
        guard let session = currentSession else {
            statusText = "Sem sessão ativa para cancelar"
            eventText = "Inicie uma leitura antes de cancelar"
            return
        }

        Task {
            do {
                _ = try await session.cancelRead()
                statusText = "Leitura cancelada"
                eventText = "Operação interrompida manualmente"
            } catch {
                statusText = "Falha ao cancelar"
                eventText = errorMessage(for: error)
            }
            stopListeningForReaderEvents()
            currentSession = nil
            isReading = false
        }
    }

    private func ensureAccountIsLinked(using token: PaymentCardReader.Token) async throws {
        if #available(iOS 16.4, *) {
            if try await reader.isAccountLinked(using: token) { return }
        }
        try await reader.linkAccount(using: token)
    }

    private func startListeningForReaderEvents() {
        eventTask?.cancel()
        eventTask = Task {
            for await event in reader.events {
                await MainActor.run {
                    self.eventText = eventDescription(event)
                }
            }
        }
    }

    private func stopListeningForReaderEvents() {
        eventTask?.cancel()
        eventTask = nil
    }

    private func successMessage(for amount: Decimal, result: PaymentCardReadResult) -> String {
        let formattedAmount = NSDecimalNumber(decimal: amount).doubleValue
        if #available(iOS 16.4, *) {
            switch result.outcome {
            case .success:
                return "Pagamento de \(formattedAmount.formatted(.currency(code: currencyCode.uppercased()))) aprovado."
            case .cardDeclined:
                return "Cartão recusado."
            case .failure:
                return "Falha na leitura do pagamento."
            @unknown default:
                return "Leitura concluída com resultado desconhecido."
            }
        }
        return "Leitura finalizada."
    }

    private func errorMessage(for error: Error) -> String {
        if let readError = error as? PaymentCardReaderSession.ReadError {
            return "Leitura: \(readError.errorName) (\(readError.errorDescription))"
        }
        if let cardReaderError = error as? PaymentCardReaderError {
            return "Reader: \(String(describing: cardReaderError))"
        }
        return error.localizedDescription
    }

    private func eventDescription(_ event: PaymentCardReader.Event) -> String {
        switch event {
        case .updateProgress(let progress):
            return "Preparando leitor: \(progress)%"
        case .notReady:
            return "Leitor não está pronto"
        case .readyForTap:
            return "Leitor pronto para aproximação"
        case .cardDetected:
            return "Cartão detectado"
        case .removeCard:
            return "Remova o cartão do topo do iPhone"
        case .readCompleted:
            return "Leitura concluída"
        case .readRetry:
            return "Tente aproximar novamente"
        case .readCancelled:
            return "Leitura cancelada"
        case .readNotCompleted:
            return "Leitura não concluída"
        case .pinEntryRequested:
            return "Digite o PIN no iPhone"
        case .pinEntryCompleted:
            return "PIN finalizado"
        case .userInterfaceDismissed:
            return "Interface do Tap to Pay encerrada"
        @unknown default:
            return "Evento desconhecido"
        }
    }
}
