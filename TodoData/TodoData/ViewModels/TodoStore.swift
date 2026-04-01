import Foundation
import SwiftData

@MainActor
final class TodoStore {
    func addTask(
        title: String,
        description: String,
        dueDate: Date,
        using context: ModelContext
    ) {
        let newTask = TodoItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            taskDescription: description.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: dueDate
        )

        context.insert(newTask)
        save(context)
    }

    func updateTask(
        _ task: TodoItem,
        title: String,
        description: String,
        dueDate: Date,
        isDone: Bool,
        using context: ModelContext
    ) {
        task.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        task.taskDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        task.dueDate = dueDate
        task.isDone = isDone

        save(context)
    }

    func deleteTask(_ task: TodoItem, using context: ModelContext) {
        context.delete(task)
        save(context)
    }

    private func save(_ context: ModelContext) {
        do {
            try context.save()
        } catch {
            assertionFailure("Erro ao salvar tarefa: \(error.localizedDescription)")
        }
    }
}
