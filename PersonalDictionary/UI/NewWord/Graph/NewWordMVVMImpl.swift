//
//  NewWordMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

final class NewWordMVVMImpl: NewWordMVVM {

    private let view: NewWordViewController

    init(langRepository: LangRepository,
         notificationCenter: NotificationCenter) {
        let staticContent = NewWordViewStaticContent(
            selectButtonTitle: NSLocalizedString("Select", comment: ""),
            arrowText: NSLocalizedString("⇋", comment: ""),
            okText: NSLocalizedString("OK", comment: ""),
            textFieldPlaceholder: NSLocalizedString("Enter a new word", comment: "")
        )

        let styles = NewWordViewStyles(backgroundColor: appBackgroundColor)

        view = NewWordViewController(staticContent: staticContent, styles: styles)
        let model = NewWordModelImpl(langRepository, notificationCenter)
        let viewModel = NewWordViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var viewController: UIViewController? {
        view
    }
}
