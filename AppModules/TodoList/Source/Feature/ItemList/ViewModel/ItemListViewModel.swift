//
//  ItemListViewModel.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxCocoa

protocol ItemListViewModel: AnyObject {

    var items: BehaviorRelay<[TodoItem]> { get }

    func add(_ todoItem: TodoItem)

    func toggleCompletionForTodo(at position: Int)

    func remove(at position: Int)
}
