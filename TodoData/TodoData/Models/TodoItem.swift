import Foundation
import SwiftData

@Model
final class TodoItem {
    var title: String
    var taskDescription: String
    var dueDate: Date
    var isDone: Bool
    var createdAt: Date

    init(
        title: String,
        taskDescription: String = "",
        dueDate: Date = .now,
        isDone: Bool = false,
        createdAt: Date = .now
    ) {
        self.title = title
        self.taskDescription = taskDescription
        self.dueDate = dueDate
        self.isDone = isDone
        self.createdAt = createdAt
    }
}
