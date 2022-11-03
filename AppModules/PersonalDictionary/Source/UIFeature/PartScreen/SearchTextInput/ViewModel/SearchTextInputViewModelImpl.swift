//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxCocoa
import RxSwift

/// Реализация модели представления элемента ввода поискового текста.
final class SearchTextInputViewModelImpl: SearchTextInputViewModel {

    /// Поисковый текст для представления
    let searchText = BindableString(value: "")

    private let model: SearchTextInputModel

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель элемента ввода поискового текста.
    init(model: SearchTextInputModel) {
        self.model = model
        searchText.subscribe(onNext: { [weak self] text in
            self?.model.listener?.onSearchTextChanged(text)
        }).disposed(by: disposeBag)
    }
}
