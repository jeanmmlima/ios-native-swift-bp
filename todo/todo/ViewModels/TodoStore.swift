//
//  TodoStore.swift
//  todo
//
//  Created by Jean Mário Moreira de Lima on 24/03/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
class TodoStore {
    var tasks: [TodoItem] = []
    
    func add(_ task: TodoItem) {
        tasks.append(task)
    }
    
    func deleteTask(at indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
       }
       
       func removeTask(_ task: TodoItem) {
           tasks.removeAll { $0.id == task.id }
       }
}
