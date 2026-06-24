//
//  MessageBoxViewModel.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import Combine

struct MessageBoxState {
    var text: String
    var isHidden: Bool
}

typealias BindableMessageBoxState = CurrentValueSubject<MessageBoxState, Never>

protocol MessageBoxViewModel {

    var state: BindableMessageBoxState { get }
}
