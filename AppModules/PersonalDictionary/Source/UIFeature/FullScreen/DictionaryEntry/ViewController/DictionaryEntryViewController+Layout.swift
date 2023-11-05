//
//  DictionaryEntryViewController.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import UIKit

extension DictionaryEntryViewController {

    func initViews() {
        view.backgroundColor = theme.backgroundColor
        initDictionaryEntryView()
        initLabel()
        initRetryButton()
        initActivityIndicator()
    }

    private func initDictionaryEntryView() {
        view.addSubview(dictionaryEntryView)
        dictionaryEntryView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func initActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }

    private func initRetryButton() {
        retryButton.setTitle(params.retryButtonText, for: .normal)
        retryButton.backgroundColor = .systemBlue
        retryButton.layer.cornerRadius = 8
        retryButton.addTarget(self, action: #selector(onRetryButtonTap), for: .touchUpInside)
        retryButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        view.addSubview(retryButton)
        retryButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(label.snp.bottom).offset(17)
            make.centerX.equalTo(view.snp.centerX)
        }
    }

    private func initLabel() {
        view.addSubview(label)
        label.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        label.text = params.errorText
    }
}
