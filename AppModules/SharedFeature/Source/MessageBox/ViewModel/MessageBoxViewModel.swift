//
//  MessageBoxViewModel.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

struct MessageBoxState {
    var text: String
    var isHidden: Bool
}

protocol MessageBoxViewModel {

    var state: MessageBoxState { get }
}
