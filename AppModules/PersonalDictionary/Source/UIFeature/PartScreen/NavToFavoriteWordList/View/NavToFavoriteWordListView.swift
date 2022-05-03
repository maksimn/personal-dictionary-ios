//
//  NavToFavoriteWordListView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Представление элемента навигации на экран списка избранных слов.
final class NavToFavoriteWordListView: UIView {

    private let routingButtonTitle: String
    private let router: NavToFavoriteWordListRouter

    private let routingButton = UIButton()

    /// Инициализатор.
    /// - Parameters:
    ///  - routingButtonTitle: текст  навигационной кнопки на экран списка избранных слов..
    ///  - router: роутер для навигации на экран списка избранных слов.
    init(routingButtonTitle: String,
         router: NavToFavoriteWordListRouter) {
        self.routingButtonTitle = routingButtonTitle
        self.router = router
        super.init(frame: .zero)
        initRoutingButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onRoutingButtonTap() {
        router.navigateToFavoriteWordList()
    }

    private func initRoutingButton() {
        routingButton.setTitle(routingButtonTitle, for: .normal)
        routingButton.setTitleColor(Theme.data.goldColor, for: .normal)
        routingButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        routingButton.backgroundColor = .clear
        routingButton.layer.cornerRadius = 8
        routingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        routingButton.addTarget(self, action: #selector(onRoutingButtonTap), for: .touchUpInside)
        addSubview(routingButton)
        routingButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(14.5)
            make.left.equalTo(self.snp.left).offset(9)
        }
    }
}
