//
//  MainWordListHeaderView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Параметры представления.
struct MainWordListHeaderViewParams {

    /// Текст заголовка
    let heading: String

    /// Текст  навигационной кнопки
    let routingButtonTitle: String
}

/// Представление заголовка главного списка слов.
final class MainWordListHeaderView: UIView {

    private let params: MainWordListHeaderViewParams
    private let router: RoutingToFavoriteWordList

    private let routingButton = UIButton()
    private let myDictionaryLabel = UILabel()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления.
    ///  - router: роутер для навигации на экран списка избранных слов.
    init(params: MainWordListHeaderViewParams,
         router: RoutingToFavoriteWordList) {
        self.params = params
        self.router = router
        super.init(frame: .zero)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onRoutingButtonTap() {
        router.navigateToFavoriteWordList()
    }

    private func initViews() {
        initRoutingButton()
        initMyDictionaryLabel()
    }

    private func initRoutingButton() {
        routingButton.setTitle(params.routingButtonTitle, for: .normal)
        routingButton.setTitleColor(Theme.standard.goldColor, for: .normal)
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

    private func initMyDictionaryLabel() {
        myDictionaryLabel.textColor = .black
        myDictionaryLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        myDictionaryLabel.numberOfLines = 1
        myDictionaryLabel.textAlignment = .left
        myDictionaryLabel.text = params.heading
        addSubview(myDictionaryLabel)
        myDictionaryLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.snp.top).offset(14)
            make.left.equalTo(self.snp.left).offset(54.5)
        }
    }
}
