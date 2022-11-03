//
//  SearchTextInputView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift
import UIKit

/// Реализация представления элемента ввода поискового текста.
final class SearchTextInputView {

    private let params: SearchTextInputViewParams

    private let viewModel: SearchTextInputViewModel

    private let searchBar = UISearchBar()

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления.
    init(params: SearchTextInputViewParams,
         viewModel: SearchTextInputViewModel) {
        self.params = params
        self.viewModel = viewModel
        initSearchBar()
        bindToViewModel()
    }

    /// UIView элемента ввода поискового текста.
    var uiview: UIView {
        searchBar
    }

    // MARK: - private

    private func initSearchBar() {
        searchBar.frame = CGRect(origin: .zero, size: params.size)
        searchBar.placeholder = params.placeholder
    }

    private func bindToViewModel() {
        searchBar.rx.text.subscribe(onNext: { [weak self] text in
            self?.viewModel.searchText.accept(text ?? "")
        }).disposed(by: disposeBag)
    }
}
