//
//  RouterImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class RouterImpl: Router {

    private weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func navigateToNewWord() {
        let newWordMVVM = NewWordMVVMImpl(langRepository: LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                                             data: langData),
                                          notificationCenter: NotificationCenter.default,
                                          staticContent: newWordViewStaticContent,
                                          styles: newWordViewStyles)
        guard let newWordViewController = newWordMVVM.viewController else { return }

        newWordViewController.modalPresentationStyle = .overFullScreen

        viewController?.present(newWordViewController, animated: true, completion: nil)
    }
}
