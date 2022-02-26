//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Представление для навигации.
final class NavToOtherAppView: UIView {

    private let appParams: AppParams

    private let routingButton = UIButton()

    /// Инициализатор.
    /// - Parameters:
    ///  - width:
    init(appParams: AppParams) {
        self.appParams = appParams
        super.init(frame: .zero)
        initRoutingButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onRoutingButtonTap() {
        appParams.coreRouter?.navigate()
    }

    private func initRoutingButton() {
        routingButton.setTitle(appParams.routingButtonTitle, for: .normal)
        routingButton.setTitleColor(.darkGray, for: .normal)
        routingButton.backgroundColor = .clear
        routingButton.layer.cornerRadius = 8
        routingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        routingButton.addTarget(self, action: #selector(onRoutingButtonTap), for: .touchUpInside)
        addSubview(routingButton)
        routingButton.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }
}
