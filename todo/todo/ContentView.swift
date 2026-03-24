//
//  ContentView.swift
//  todo
//
//  Created by Jean Lima on 23/03/26.
//

import SwiftUI

struct ContentView: View {
    // Framework Observation: @State é usado para instanciar classes @Observable
        @State private var store = TodoModel()
        
        var body: some View {
            NavigationStack {
                List {
                    ForEach(store.tasks) { task in
                        NavigationLink(value: task) {
                            VStack(alignment: .leading) {
                                Text(task.description)
                                    .font(.headline)
                                Text(task.taskDate.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: store.deleteTask)
                }
                .navigationTitle("Minhas Tarefas")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink(destination: AddTaskView(store: store)) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.purple)
                        }
                    }
                }
                .navigationDestination(for: Task.self) { task in
                    TaskDetailView(store: store, task: task)
                }
                .tint(.purple)
            }
        }
}

struct AddTaskView: View {
    // Framework Observation: Referência ao objeto observado recebido por parâmetro
    var store: TodoModel
    
    @State private var description: String = ""
    @State private var taskDate: Date = Date()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section("Detalhes da Tarefa") {
                TextField("Descrição", text: $description)
                DatePicker("Data", selection: $taskDate, displayedComponents: [.date, .hourAndMinute])
            }
            
            Button("Salvar Tarefa") {
                store.addTask(description: description, date: taskDate)
                dismiss() // Volta para a lista
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .disabled(description.isEmpty)
        }
        .navigationTitle("Nova Tarefa")
    }
}

struct TaskDetailView: View {
    var store: TodoModel
    let task: Task
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("Descrição") {
                Text(task.description)
            }
            
            Section("Datas") {
                LabeledContent("Agendada para", value: task.taskDate.formatted())
                LabeledContent("Criada em", value: task.creationDate.formatted())
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


#Preview {
    ContentView()
}
