//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// View of the "Navigation to Another Product/Application in the Superapp" feature.
final class NavToTodoListView: UIView {

    private let routingButtonTitle: String
    private let router: Router

    private let routingButton = UIButton()

    /// Initializer.
    /// - Parameters:
    ///  - routingButtonTitle: title for the navigation button.
    ///  - router: router for navigation to a new screen.
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
