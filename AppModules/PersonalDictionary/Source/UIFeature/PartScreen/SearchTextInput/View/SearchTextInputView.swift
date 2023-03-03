//
//  SearchTextInputView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule
import UIKit

/// Параметры представления элемента ввода поискового текста.
struct SearchTextInputParams {

    /// Плейсхолдер для состояния элемента, когда поисковый текст пуст.
    let placeholder: String

    /// Размер элемента.
    let size: CGSize
}

/// Реализация представления элемента ввода поискового текста.
final class SearchTextInputView: UIView, UISearchBarDelegate {

    private let params: SearchTextInputParams
    private let viewModel: SearchTextInputViewModel
    private let logger: SLogger

    private let searchBar = UISearchBar()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления.
    init(params: SearchTextInputParams,
         viewModel: SearchTextInputViewModel,
         logger: SLogger) {
        self.params = params
        self.viewModel = viewModel
        self.logger = logger
        super.init(frame: CGRect(origin: .zero, size: params.size))
        initSearchBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initSearchBar() {
        addSubview(searchBar)
        searchBar.frame = frame
        searchBar.placeholder = params.placeholder
        searchBar.delegate = self
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        logger.log("User is entering search text: \"\(searchText)\"")
        viewModel.searchText.accept(searchText)
    }
}
