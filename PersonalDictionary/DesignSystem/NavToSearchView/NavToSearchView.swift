//
//  NavToSearchView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 08.11.2021.
//

import UIKit

final class NavToSearchView: UIView {

    private let searchBar = UISearchBar()
    private let navigateToSearchButton = UIButton()

    private var onTap: (() -> Void)?

    init(params: NavToSearchViewParams
            = NavToSearchViewParams(staticContent: NavToSearchStaticContent(),
                                    styles: NavToSearchStyles(size: CGSize(width: UIScreen.main.bounds.width - 32,
                                                                           height: 44))),
         onTap: (() -> Void)?) {
        self.onTap = onTap
        let frame = CGRect(origin: .zero, size: params.styles.size)
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
        onTap?()
    }
}
