//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Представление для навигации на экран добавления нового слова в Личный словарь.
final class NavToNewWordView: UIView {

    private let navToNewWordButton = UIButton()

    private let navToNewWordImage: UIImage
    private let router: CoreRouter

    /// Инициализатор.
    /// - Parameters:
    ///  - navToNewWordImage: картинка для представления.
    ///  - router: роутер для навигации на экран.
    init(navToNewWordImage: UIImage,
         router: CoreRouter) {
        self.navToNewWordImage = navToNewWordImage
        self.router = router
        super.init(frame: .zero)
        initNewWordButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func navigateToNewWord() {
        router.navigate()
    }

    private func initNewWordButton() {
        addSubview(navToNewWordButton)
        navToNewWordButton.setImage(navToNewWordImage, for: .normal)
        navToNewWordButton.imageView?.contentMode = .scaleAspectFit
        navToNewWordButton.addTarget(self, action: #selector(navigateToNewWord), for: .touchUpInside)
        navToNewWordButton.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
        if let imageView = navToNewWordButton.imageView {
            imageView.snp.makeConstraints { make -> Void in
                make.edges.equalTo(navToNewWordButton)
            }
        }
    }
}
