//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Представление для навигации на экран добавления нового слова в Личный словарь.
final class NavToItemEditorView: UIView {

    private let navigationButton = UIButton()

    private let navigationImage: UIImage
    private let router: NavToItemEditorRouter

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationImage: картинка для представления.
    ///  - router: роутер для навигации на экран.
    init(navigationImage: UIImage,
         router: NavToItemEditorRouter) {
        self.navigationImage = navigationImage
        self.router = router
        super.init(frame: .zero)
        initNavigationButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func navigate() {
        router.navigate(with: nil)
    }

    private func initNavigationButton() {
        addSubview(navigationButton)
        navigationButton.setImage(navigationImage, for: .normal)
        navigationButton.imageView?.contentMode = .scaleAspectFit
        navigationButton.addTarget(self, action: #selector(navigate), for: .touchUpInside)
        navigationButton.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
        if let imageView = navigationButton.imageView {
            imageView.snp.makeConstraints { make -> Void in
                make.edges.equalTo(navigationButton)
            }
        }
    }
}
