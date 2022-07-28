//
//  ItemListViewModel.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxCocoa

protocol ToggableItemListViewModel: AnyObject {

    var state: BehaviorRelay<ToggableItemListState> { get }

    func toggleCompletedTodoVisibility()
}
