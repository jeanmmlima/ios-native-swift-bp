//
//  todoApp.swift
//  todo
//
//  Created by Jean Lima on 23/03/26.
//

import SwiftUI

@main
struct TodoApp: App {
    @State private var store = TodoStore()
    @State private var theme = AppTheme()
    
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environment(store)
                .environment(theme)
        }
    }
}
