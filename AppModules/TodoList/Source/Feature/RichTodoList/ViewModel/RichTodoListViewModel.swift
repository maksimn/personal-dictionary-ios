//
//  ItemListViewModel.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxCocoa

protocol RichTodoListViewModel: AnyObject {

    var state: BehaviorRelay<RichTodoListState> { get }

    func toggleCompletedTodoVisibility()
}
