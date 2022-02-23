//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Представление для навигации на экран Поиска.
final class NavToNewWordView: UIView {

    private let navToNewWordButton = UIButton()

    private let navToNewWordImage: UIImage
    private let router: NavToNewWordRouter

    /// Инициализатор.
    /// - Parameters:
    ///  - router: роутер для навигации на экран.
    init(navToNewWordImage: UIImage,
         router: NavToNewWordRouter) {
        self.navToNewWordImage = navToNewWordImage
        self.router = router
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func navigateToNewWord() {
        router.navigateToNewWord()
    }

    private func initNewWordButton() {
        navToNewWordButton.setImage(navToNewWordImage, for: .normal)
        navToNewWordButton.imageView?.contentMode = .scaleAspectFit
        navToNewWordButton.addTarget(self, action: #selector(navigateToNewWord), for: .touchUpInside)
        if let imageView = navToNewWordButton.imageView {
            imageView.snp.makeConstraints { make -> Void in
                make.edges.equalTo(navToNewWordButton)
            }
        }
    }
}
