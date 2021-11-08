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
        view.addSubview(newWordButton)
        initNewWordButton()
    }

    private func addWordListChildController() {
        guard let wordListViewController = wordListMVVM.viewController else { return }

        add(child: wordListViewController)
    }

    private func initNewWordButton() {
        newWordButton.setImage(UIImage(named: "icon-plus")!, for: .normal)
        newWordButton.imageView?.contentMode = .scaleAspectFit
        newWordButton.addTarget(self, action: #selector(onNewWordButtonTap), for: .touchUpInside)
        newWordButton.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
        if let imageView = newWordButton.imageView {
            imageView.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(newWordButton)
            }
        }
    }
}
