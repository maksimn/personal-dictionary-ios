//
//  SearchTextInputModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift

/// Реализация модели элемента ввода поискового текста.
final class SearchTextInputModelImpl: SearchTextInputModel {

    // MARK: - Public props

    weak var listener: SearchTextInputListener?

    private(set) var searchText: String = ""

    // MARK: - Private props

    private let viewModelBlock: () -> SearchTextInputViewModel?
    private weak var viewModel: SearchTextInputViewModel?

    private let disposeBag = DisposeBag()

    init(viewModelBlock: @escaping () -> SearchTextInputViewModel?) {
        self.viewModelBlock = viewModelBlock
    }

    /// Костыль.
    /// Необходимо вызвать в инициализаторе графа фичи, чтобы изменения данных во view были синхронизированы с моделью.
    func bindMVVM() {
        if viewModel == nil {
            viewModel = viewModelBlock()
            viewModel?.searchText.subscribe(onNext: { [weak self] text in
                self?.searchText = text
                self?.listener?.onSearchTextChanged(text)
            }).disposed(by: disposeBag)
        }
    }
}
