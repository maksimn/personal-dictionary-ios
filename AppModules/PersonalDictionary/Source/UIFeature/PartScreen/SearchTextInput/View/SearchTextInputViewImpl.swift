//
//  SearchTextInputViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift
import UIKit

/// Реализация представления элемента ввода поискового текста.
final class SearchTextInputViewImpl: NSObject, SearchTextInputView, UISearchBarDelegate {

    /// Модель представления элемента ввода поискового текста.
    var viewModel: SearchTextInputViewModel? {
        didSet {
            bindToViewModel()
        }
    }

    private let searchBar = UISearchBar()

    private let params: SearchTextInputViewParams

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления.
    init(params: SearchTextInputViewParams) {
        self.params = params
        super.init()
        initSearchBar()
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
            self?.viewModel?.searchText.accept(text ?? "")
        }).disposed(by: disposeBag)
    }
}
