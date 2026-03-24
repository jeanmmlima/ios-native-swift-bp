//
//  Task.swift
//  todo
//
//  Created by Jean Lima on 23/03/26.
//


import SwiftUI
import Observation

struct Task: Identifiable, Hashable {
    var id = UUID()
    var description: String
    var taskDate: Date
    var creationDate: Date = Date()
}

@Observable // Framework Observation: Torna a classe observável de forma automática
class TodoModel {
    var tasks: [Task] = []
    
    func addTask(description: String, date: Date) {
        let newTask = Task(description: description, taskDate: date)
        tasks.append(newTask)
    }
    
    func deleteTask(at indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
    }
    
    func removeTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
}
