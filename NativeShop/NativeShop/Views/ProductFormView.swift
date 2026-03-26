import SwiftUI

struct ProductFormView: View {
    let title: String
    let submitButtonTitle: String
    let isSaving: Bool
    let onSave: (String, String, Double, URL) async -> Bool

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var description = ""
    @State private var priceText = ""
    @State private var imageURLText = ""
    @State private var formErrorMessage: String?

    init(
        title: String = "Cadastro de Produto",
        submitButtonTitle: String = "Cadastrar",
        isSaving: Bool = false,
        onSave: @escaping (String, String, Double, URL) async -> Bool
    ) {
        self.title = title
        self.submitButtonTitle = submitButtonTitle
        self.isSaving = isSaving
        self.onSave = onSave
    }

    var body: some View {
        Form {
            Section("Dados do Produto") {
                TextField("Nome", text: $name)
                TextField("Descrição", text: $description, axis: .vertical)
                    .lineLimit(3...5)
                TextField("Preço (ex: 49,90)", text: $priceText)
                    .keyboardType(.decimalPad)
                TextField("URL da imagem", text: $imageURLText)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
            }

            Section {
                Button {
                    Task {
                        await handleSave()
                    }
                } label: {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text(submitButtonTitle)
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(isSaving)
            }
        }
        .navigationTitle(title)
        .alert("Erro no formulário", isPresented: Binding(get: {
            formErrorMessage != nil
        }, set: { newValue in
            if !newValue {
                formErrorMessage = nil
            }
        })) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(formErrorMessage ?? "")
        }
    }

    private func handleSave() async {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedImageURL = imageURLText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanedName.isEmpty, !cleanedDescription.isEmpty, !cleanedImageURL.isEmpty else {
            formErrorMessage = "Preencha todos os campos antes de cadastrar."
            return
        }

        let normalizedPrice = priceText
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let price = Double(normalizedPrice), price > 0 else {
            formErrorMessage = "Informe um preço válido maior que zero."
            return
        }

        guard let imageURL = URL(string: cleanedImageURL) else {
            formErrorMessage = "Informe uma URL de imagem válida."
            return
        }

        let didSave = await onSave(cleanedName, cleanedDescription, price, imageURL)
        if didSave {
            dismiss()
        }
    }
}
