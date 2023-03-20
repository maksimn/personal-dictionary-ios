//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

final class NavToSearchView: UIView {

    private let router: EmptyRouter

    /// - Parameters:
    ///  - router: роутер для навигации на экран Поиска.
    init(router: EmptyRouter) {
        self.router = router
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
