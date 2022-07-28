//
//  CompletedItemVisibilityToggleModel.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

struct CompletedItemVisibilityToggleState {
    let isVisible: Bool
    let isEmpty: Bool
}

protocol CompletedItemVisibilityToggleModel {

    var initialState: CompletedItemVisibilityToggleState { get }

    func notifyWhenStateChanges()
}
