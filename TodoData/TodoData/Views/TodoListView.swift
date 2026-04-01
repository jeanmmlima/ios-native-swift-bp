import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.dueDate, order: .forward) private var tasks: [TodoItem]

    @State private var showAddTask = false
    private let store = TodoStore()

    init() {}

    var body: some View {
        NavigationStack {
            Group {
                if orderedTasks.isEmpty {
                    ContentUnavailableView(
                        "Sem tarefas",
                        systemImage: "checklist",
                        description: Text("Toque no botão + para cadastrar a primeira tarefa.")
                    )
                } else {
                    List {
                        ForEach(orderedTasks) { task in
                            NavigationLink {
                                TaskDetailView(task: task, store: store)
                            } label: {
                                HStack {
                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(task.isDone ? .green : .secondary)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(task.title)
                                            .strikethrough(task.isDone)
                                            .font(.headline)

                                        Text(task.dueDate, formatter: AppTheme.dateFormatter)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Minhas Tarefas")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskView(store: store)
            }
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = orderedTasks[index]
            store.deleteTask(task, using: modelContext)
        }
    }

    private var orderedTasks: [TodoItem] {
        tasks.sorted { lhs, rhs in
            if lhs.isDone != rhs.isDone {
                return lhs.isDone == false
            }
            return lhs.dueDate < rhs.dueDate
        }
    }
}

#Preview {
    TodoListView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
