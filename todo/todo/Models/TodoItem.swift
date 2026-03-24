//
//  TodoItem.swift
//  todo
//
//  Created by Jean Mário Moreira de Lima on 24/03/26.
//

import Foundation

struct TodoItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var date: Date
    var isUrgent: Bool = false
    let createdAt = Date()
}
