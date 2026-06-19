//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// View for navigation to the new word addition screen in the Personal Dictionary.
final class NavToNewWordView: UIView {

    private let navToNewWordButton = UIButton()

    private let navToNewWordImage: UIImage
    private let router: Router

    /// Initializer.
    /// - Parameters:
    ///  - navToNewWordImage: image for the view.
    ///  - router: router for navigation to the screen.
    init(navToNewWordImage: UIImage,
         router: Router) {
        self.navToNewWordImage = navToNewWordImage
        self.router = router
        super.init(frame: .zero)
        initNewWordButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func navigateToNewWord() {
        router.navigate()
    }

    private func initNewWordButton() {
        addSubview(navToNewWordButton)
        navToNewWordButton.setImage(navToNewWordImage, for: .normal)
        navToNewWordButton.imageView?.contentMode = .scaleAspectFit
        navToNewWordButton.addTarget(self, action: #selector(navigateToNewWord), for: .touchUpInside)
        navToNewWordButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        if let imageView = navToNewWordButton.imageView {
            imageView.snp.makeConstraints { make in
                make.edges.equalTo(navToNewWordButton)
            }
        }
    }
}
