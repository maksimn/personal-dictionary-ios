//
//  SearchTextInputView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule
import RxSwift
import UIKit

final class SearchTextInputView: UISearchController {

    private let model: SearchTextInputModel
    private let logger: SLogger

    private let disposeBag = DisposeBag()

    init(model: SearchTextInputModel, placeholder: String, logger: SLogger) {
        self.model = model
        self.logger = logger
        super.init(searchResultsController: nil)
        searchBar.placeholder = placeholder
        obscuresBackgroundDuringPresentation = false
        subscribe()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.log(dismissedFeatureName: "PersonalDictionary.SearchTextInput")
    }

    private func subscribe() {
        searchBar.rx.text
            .subscribe(onNext: { [weak self] searchText in
                self?.onNext(searchText)
            }).disposed(by: disposeBag)
    }

    private func onNext(_ searchText: String?) {
        guard let searchText = searchText else { return }

        logger.log("User is entering search text: \"\(searchText)\"")
        model.process(searchText)
    }
}
