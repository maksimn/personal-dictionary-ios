//
//  MainWordListContainer+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 08.11.2021.
//

import UIKit

extension MainWordListContainer {

    func initViews() {
        navigationItem.titleView = navToSearchView
        addWordListChildController()
        view.addSubview(navToNewWordButton)
        initNewWordButton()
    }

    private func addWordListChildController() {
        guard let wordListViewController = wordListMVVM.viewController else { return }

        add(child: wordListViewController)
    }

    private func initNewWordButton() {
        navToNewWordButton.setImage(params.staticContent.navToNewWordImage, for: .normal)
        navToNewWordButton.imageView?.contentMode = .scaleAspectFit
        navToNewWordButton.addTarget(self, action: #selector(navigateToNewWord), for: .touchUpInside)
        navToNewWordButton.snp.makeConstraints { make -> Void in
            make.size.equalTo(params.styles.navToNewWordButtonSize)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .offset(params.styles.navToNewWordButtonBottomOffset)
            make.centerX.equalTo(view)
        }
        if let imageView = navToNewWordButton.imageView {
            imageView.snp.makeConstraints { make -> Void in
                make.edges.equalTo(navToNewWordButton)
            }
        }
    }
}
