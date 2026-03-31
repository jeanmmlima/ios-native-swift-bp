//
//  TodoListView.swift
//  todo
//
//  Created by Jean Mário Moreira de Lima on 24/03/26.
//


import SwiftUI

struct TodoListView: View {
    @Environment(TodoStore.self) var store
    @Environment(AppTheme.self) var theme
    
    var body: some View {
        NavigationStack {
            List(store.tasks) { task in
                NavigationLink(destination: TaskDetailView(store: store, task: task)) {
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.headline)
                            .foregroundStyle(task.isUrgent ? .red : .primary)
                        Text(task.date.formatted())
                            .font(.caption)
                    }
                }
                
            }
            .navigationTitle(theme.appTitle)
            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    NavigationLink(destination: AddTaskView()) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(.purple)
                                    }
                                }
                            }
        }
        .tint(.purple)
    }
}

#Preview {
    let store = TodoStore()
    let theme = AppTheme()
    TodoListView()
        .environment( store)
        .environment( theme)
}
