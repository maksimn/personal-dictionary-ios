//
//  CompletedItemVisibilityToggleViewModel.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa

protocol CompletedItemVisibilityToggleViewModel: AnyObject {

    var state: BehaviorRelay<CompletedItemVisibilityToggleState> { get }
}
