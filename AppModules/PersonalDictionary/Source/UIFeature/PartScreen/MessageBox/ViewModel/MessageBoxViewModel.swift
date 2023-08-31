//
//  MessageBoxViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import RxCocoa

struct MessageBoxState {
    var text: String
    var isHidden: Bool
}

typealias BindableMessageBoxState = BehaviorRelay<MessageBoxState>

protocol MessageBoxViewModel {

    var state: BindableMessageBoxState { get }
}
