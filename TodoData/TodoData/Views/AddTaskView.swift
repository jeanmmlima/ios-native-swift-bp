import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()

    let store: TodoStore

    var body: some View {
        NavigationStack {
            Form {
                Section("Dados da Tarefa") {
                    TextField("Título", text: $title)
                    TextField("Descrição", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                    DatePicker("Prazo", selection: $dueDate)
                }
            }
            .navigationTitle("Nova Tarefa")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        store.addTask(
                            title: title,
                            description: description,
                            dueDate: dueDate,
                            using: modelContext
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddTaskView(store: TodoStore())
        .modelContainer(for: TodoItem.self, inMemory: true)
}
