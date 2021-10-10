//
//  RouterImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class RouterImpl: Router {

    private weak var viewController: UIViewController?

    private let langRepository: LangRepository

    init(viewController: UIViewController?,
         langRepository: LangRepository) {
        self.langRepository = langRepository
        self.viewController = viewController
    }

    func navigateToNewWord() {
        let newWordMVVM = NewWordMVVMImpl(langRepository: langRepository,
                                          notificationCenter: NotificationCenter.default)
        guard let newWordViewController = newWordMVVM.viewController else { return }

        newWordViewController.modalPresentationStyle = .overFullScreen

        viewController?.present(newWordViewController, animated: true, completion: nil)
    }
}
