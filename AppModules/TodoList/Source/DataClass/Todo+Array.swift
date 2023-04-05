//
//  Todo+Array.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import UIKit

extension Array where Element == Todo {

    var completedTodoIndexPaths: [IndexPath] {
        self.enumerated()
            .filter { $1.isCompleted }
            .map { IndexPath(row: $0.offset, section: 0) }
    }

    mutating func sortByCreateAt() {
        sort(by: { todo1, todo2 in
            todo1.createdAt < todo2.createdAt
        })
    }

    func mergeWith(_ remoteTodos: [Todo]) -> [Todo] {
        var mergedTodos: [Todo] = []

        // Добавлять Todo'ы с id, которых у вас нет
        for todo in remoteTodos where !self.contains(where: { $0.id == todo.id }) {
            mergedTodos.append(todo)
        }

        // Удалять Todo'ы которые есть локально, но id  которых отсутствует в ответе ручки
        let todosContainingInRemote = self.filter { todo in
            remoteTodos.contains(where: { $0.id == todo.id })
        }

        // Обновлять Todo'ы, id  которых есть и у в кэше и в ответе ручки, и в поле updated_at ручки
        // бОльшее значение, чем у айтема в кэше
        for todo in todosContainingInRemote {
            if let remoteTodo = remoteTodos.first(where: { $0.id == todo.id }),
                remoteTodo.updatedAt > todo.updatedAt {
                mergedTodos.append(remoteTodo)
            } else {
                mergedTodos.append(todo)
            }
        }

        mergedTodos.sortByCreateAt()

        // для полученных моделей ставить флаг isDirty в значение false
        return mergedTodos.map { $0.isDirty ? $0.update(isDirty: false) : $0 }
    }

    static func isCreateTodoOperation(_ todos: [Todo], _ prev: [Todo]) -> Bool {
        prev.count + 1 == todos.count && Array(todos.prefix(prev.count)) == prev
    }

    static func isUpdateTodoOperation(_ todos: [Todo], _ prev: [Todo]) -> Bool {
        prev.count == todos.count
    }

    static func isDeleteTodoOperation(_ todos: [Todo], _ prev: [Todo]) -> Bool {
        if prev.count == todos.count + 1 {
            var i = 0, j = 0, counter = 0

            while i < todos.count {
                if todos[i] == prev[j] {
                    i += 1
                    j += 1
                } else {
                    j += 1
                    counter += 1

                    if counter > 1 {
                        return false
                    }
                }
            }

            if counter == 1 {
                return true
            }
        }

        return false
    }

    static func isExpandCompletedTodosOperation(_ todos: [Todo], _ prev: [Todo]) -> Bool {
        prev.allSatisfy({ !$0.isCompleted }) && todos.contains(where: { $0.isCompleted })
    }

    static func isCollapseCompletedTodosOperation(_ todos: [Todo], _ prev: [Todo]) -> Bool {
        todos.allSatisfy({ !$0.isCompleted }) && prev.contains(where: { $0.isCompleted })
    }
}
