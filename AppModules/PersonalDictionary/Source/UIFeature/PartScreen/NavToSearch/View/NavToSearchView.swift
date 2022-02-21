//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Представление для навигации на экран Поиска.
final class NavToSearchView: UIView {

    private let searchBar = UISearchBar()
    private let navigateToSearchButton = UIButton()

    private let router: NavToSearchRouter

    /// Инициализатор.
    /// - Parameters:
    ///  - router: роутер для навигации на экран Поиска.
    init(width: NavToSearchWidth,
         router: NavToSearchRouter) {
        self.router = router
        let frame = CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width - 32 - (width == .full ? 0 : 40), height: 44)
        )
        super.init(frame: frame)
        searchBar.isUserInteractionEnabled = false
        navigateToSearchButton.addTarget(self, action: #selector(onNavigateToSearchButtonTap), for: .touchUpInside)
        addSubview(searchBar)
        addSubview(navigateToSearchButton)
        searchBar.frame = frame
        navigateToSearchButton.frame = frame
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onNavigateToSearchButtonTap() {
        router.navigateToSearch()
    }
}
