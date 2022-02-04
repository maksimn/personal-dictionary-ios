//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxCocoa

/// Реализация модели представления элемента ввода поискового текста.
final class SearchTextInputViewModelImpl: SearchTextInputViewModel {

    private let model: SearchTextInputModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель элемента ввода поискового текста.
    init(model: SearchTextInputModel) {
        self.model = model
    }

    /// Поисковый текст для представления
    let searchText = PublishRelay<String>()
}
