//
//  NavToFavoritesView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Представление элемента навигации на экран Избранного
final class NavToFavoritesView: UIView {

    private let routingButtonTitle: String
    private let navToFavoritesRouter: CoreRouter

    private let routingButton = UIButton()

    /// Инициализатор.
    /// - Parameters:
    ///  - routingButtonTitle: текст  навигационной кнопки на экран списка избранных слов.
    ///  - navToFavoritesRouter: роутер для навигации на экран Избранного.
    init(routingButtonTitle: String,
         navToFavoritesRouter: CoreRouter,
         theme: Theme) {
        self.routingButtonTitle = routingButtonTitle
        self.navToFavoritesRouter = navToFavoritesRouter
        super.init(frame: .zero)
        initRoutingButton(theme)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onRoutingButtonTap() {
        navToFavoritesRouter.navigate()
    }

    private func initRoutingButton(_ theme: Theme) {
        routingButton.setTitle(routingButtonTitle, for: .normal)
        routingButton.setTitleColor(.systemBlue, for: .normal)
        routingButton.titleLabel?.font = theme.normalFont
        routingButton.backgroundColor = .clear
        routingButton.layer.cornerRadius = 8
        routingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        routingButton.addTarget(self, action: #selector(onRoutingButtonTap), for: .touchUpInside)
        addSubview(routingButton)
        routingButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
    }
}
