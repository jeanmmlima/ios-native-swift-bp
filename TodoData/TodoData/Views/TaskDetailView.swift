import SwiftUI
import SwiftData

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let task: TodoItem
    let store: TodoStore

    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var isDone: Bool

    init(task: TodoItem, store: TodoStore) {
        self.task = task
        self.store = store

        _title = State(initialValue: task.title)
        _description = State(initialValue: task.taskDescription)
        _dueDate = State(initialValue: task.dueDate)
        _isDone = State(initialValue: task.isDone)
    }

    var body: some View {
        Form {
            Section("Status") {
                Toggle("Concluída", isOn: $isDone)
            }

            Section("Conteúdo") {
                TextField("Título", text: $title)
                TextField("Descrição", text: $description, axis: .vertical)
                    .lineLimit(3...5)
                DatePicker("Prazo", selection: $dueDate)
            }

            Section("Informações") {
                LabeledContent("Criada em") {
                    Text(task.createdAt, formatter: AppTheme.dateFormatter)
                }
            }
        }
        .navigationTitle("Detalhe")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Salvar") {
                    store.updateTask(
                        task,
                        title: title,
                        description: description,
                        dueDate: dueDate,
                        isDone: isDone,
                        using: modelContext
                    )
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            ToolbarItem(placement: .topBarLeading) {
                Button(role: .destructive) {
                    store.deleteTask(task, using: modelContext)
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: TodoItem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let exampleTask = TodoItem(title: "Estudar SwiftData", taskDescription: "Praticar consultas e persistência.", dueDate: .now)
    container.mainContext.insert(exampleTask)

    return NavigationStack {
        TaskDetailView(task: exampleTask, store: TodoStore())
    }
    .modelContainer(container)
}
