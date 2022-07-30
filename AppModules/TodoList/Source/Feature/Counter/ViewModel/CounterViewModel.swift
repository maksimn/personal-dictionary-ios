//
//  CounterViewModel.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa

protocol CounterViewModel: AnyObject {

    var count: BehaviorRelay<Int> { get }
}
