//
//  CompletedItemCounterViewModel.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa

protocol CompletedItemCounterViewModel: AnyObject {

    var count: BehaviorRelay<Int> { get }
}
