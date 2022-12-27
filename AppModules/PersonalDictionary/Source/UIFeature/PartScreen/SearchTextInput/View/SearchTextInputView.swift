//
//  SearchTextInputView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift
import UIKit

/// Реализация представления элемента ввода поискового текста.
final class SearchTextInputView: UIView {

    private let params: SearchTextInputViewParams

    private let model: SearchTextInputModel

    private let searchBar = UISearchBar()

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления.
    init(params: SearchTextInputViewParams,
         model: SearchTextInputModel) {
        self.params = params
        self.model = model
        super.init(frame: CGRect(origin: .zero, size: params.size))
        initSearchBar()
        bindToModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private

    private func initSearchBar() {
        addSubview(searchBar)
        searchBar.frame = frame
        searchBar.placeholder = params.placeholder
    }

    private func bindToModel() {
        searchBar.rx.text.subscribe(onNext: { [weak self] text in
            self?.model.set(searchText: text ?? "")
        }).disposed(by: disposeBag)
    }
}
