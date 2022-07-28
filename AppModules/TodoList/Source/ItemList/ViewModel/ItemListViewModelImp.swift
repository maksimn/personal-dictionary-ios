//
//  ItemListViewModelImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxCocoa

final class ItemListViewModelImp: ItemListViewModel {

    let items = BehaviorRelay<[TodoItem]>(value: [])

    private let model: ItemListModel

    init(model: ItemListModel) {
        self.model = model
    }

    func add(_ todoItem: TodoItem) {
        model.add(todoItem)
    }

    func toggleCompletionForTodo(at position: Int) {
        model.toggleCompletionForTodo(at: position)
    }

    func remove(at position: Int) {
        model.remove(at: position)
    }
}
