//
//  TodoItem+Array.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import UIKit

extension Array where Element == TodoItem {

    public var completedTodoItemIndexPaths: [IndexPath] {
        self.enumerated()
            .filter { $1.isCompleted }
            .map { IndexPath(row: $0.offset, section: 0) }
    }

    public mutating func sortByCreateAt() {
        sort(by: { todo1, todo2 in
            todo1.createdAt < todo2.createdAt
        })
    }

    public func mergeWith(_ remoteTodoList: [TodoItem]) -> [TodoItem] {
        let localTodoList = self
        var resultTodoList: [TodoItem] = []

        // Добавлять TodoItem 'ы с id , которых у вас нет
        for fetchedItem in remoteTodoList {
            if !localTodoList.contains(where: { $0.id == fetchedItem.id }) {
                resultTodoList.append(fetchedItem)
            }
        }

        // Удалять TodoItem 'ы которые есть локально, но id  которых отсутствует в ответе ручки
        let filteredLocalTodoList = localTodoList.filter { item in
            remoteTodoList.contains(where: { $0.id == item.id })
        }

        // Обновлять TodoItem 'ы, id  которых есть и у в кэше и в ответе ручки, и в поле updated_at ручки
        // бОльшее значение, чем у айтема в кэше
        for filteredItem in filteredLocalTodoList {
            if let handleItem = remoteTodoList.first(where: { $0.id == filteredItem.id }) {
                if handleItem.updatedAt > filteredItem.updatedAt {
                    resultTodoList.append(handleItem)
                } else {
                    resultTodoList.append(filteredItem)
                }
            } else {
                resultTodoList.append(filteredItem)
            }
        }

        resultTodoList.sortByCreateAt()

        return resultTodoList
    }
}
