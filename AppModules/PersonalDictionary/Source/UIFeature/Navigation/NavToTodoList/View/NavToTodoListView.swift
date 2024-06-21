//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Представление фичи "Навигация к другому продукту/приложению в супераппе".
final class NavToTodoListView: UIView {

    private let routingButtonTitle: String
    private let router: Router

    private let routingButton = UIButton()

    /// Инициализатор.
    /// - Parameters:
    ///  - routingButtonTitle: тайтл для навигационной кнопки.
    ///  - router: роутер для навигации на новый экран.
    init(routingButtonTitle: String,
         router: Router,
         theme: Theme) {
        self.routingButtonTitle = routingButtonTitle
        self.router = router
        super.init(frame: .zero)
        initRoutingButton(theme)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onRoutingButtonTap() {
        router.navigate()
    }

    private func initRoutingButton(_ theme: Theme) {
        routingButton.setTitle(routingButtonTitle, for: .normal)
        routingButton.setTitleColor(.systemBlue, for: .normal)
        routingButton.backgroundColor = .clear
        routingButton.layer.cornerRadius = 8
        routingButton.addTarget(self, action: #selector(onRoutingButtonTap), for: .touchUpInside)
        addSubview(routingButton)
        routingButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
