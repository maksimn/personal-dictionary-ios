//
//  SearchTextInputModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift

/// Реализация модели элемента ввода поискового текста.
final class SearchTextInputModelImpl: SearchTextInputModel {

    /// Модель представления элемента ввода поискового текста.
    weak var viewModel: SearchTextInputViewModel? {
        didSet {
            subsсribeToViewModel()
        }
    }

    /// Делегат фичи
    weak var listener: SearchTextInputListener?

    /// Поисковый текст
    private(set) var searchText: String = ""

    private let disposeBag = DisposeBag()

    private func subsсribeToViewModel() {
        viewModel?.searchText.asObservable().subscribe(onNext: { [weak self] text in
            self?.searchText = text
            self?.listener?.onSearchTextChanged(text)
        }).disposed(by: disposeBag)
    }
}
