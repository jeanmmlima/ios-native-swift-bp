//
//  TaskDetailView.swift
//  todo
//
//  Created by Jean Mário Moreira de Lima on 24/03/26.
//
import SwiftUI

struct TaskDetailView: View {
    var store: TodoStore
    let task: TodoItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("Descrição") {
                Text(task.title)
            }
            
            Section("Datas") {
                LabeledContent("Agendada para", value: task.date.formatted())
                LabeledContent("Criada em", value: task.createdAt.formatted())
            }
            
            Button(role: .destructive) {
                store.removeTask(task)
                dismiss()
            } label: {
                HStack {
                    Spacer()
                    Text("Excluir Tarefa")
                    Spacer()
                }
            }
        }
        .navigationTitle("Detalhes")
        .tint(.purple)
    }
}
