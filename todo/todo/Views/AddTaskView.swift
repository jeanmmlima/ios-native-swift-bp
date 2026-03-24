//
//  AddTaskView.swift
//  todo
//
//  Created by Jean Mário Moreira de Lima on 24/03/26.
//


import SwiftUI

struct AddTaskView: View {
    @Environment(TodoStore.self) var store
    @Environment(AppTheme.self) var theme
    @Environment(\.dismiss) var dismiss
    
    // Estado local para a nova tarefa
    @State private var newTask = TodoItem(title: "", date: Date())
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section("Informações") {
                    TextField("O que precisa ser feito?", text: $newTask.title)
                    DatePicker("Data", selection: $newTask.date)
                }
                
                Section("Extras") {
                    // O prefixo '$' cria o binding bidirecional
                    Toggle("Marcar como Urgente", isOn: $newTask.isUrgent)
                }
            }
            .navigationTitle("Nova Tarefa")
            .toolbar {
                Button("Salvar") {
                    store.add(newTask)
                    dismiss()
                }
                .tint(theme.tintColor)
            }
        }
    }
}
