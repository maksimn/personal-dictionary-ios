//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация модели представления элемента ввода поискового текста.
final class SearchTextInputViewModelImpl: SearchTextInputViewModel {

    private weak var view: SearchTextInputView?
    private let model: SearchTextInputModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель элемента ввода поискового текста.
    ///  - view: представление элемента ввода поискового текста.
    init(model: SearchTextInputModel, view: SearchTextInputView) {
        self.model = model
        self.view = view
    }

    /// Поисковый текст для представления
    var searchText: String = "" {
        didSet {
            view?.set(searchText)
        }
    }

    /// Обновить поисковый текст в модели.
    /// - Parameters:
    ///  - searchText: поисковый текст.
    func updateModel(_ searchText: String) {
        model.update(searchText)
    }
}
