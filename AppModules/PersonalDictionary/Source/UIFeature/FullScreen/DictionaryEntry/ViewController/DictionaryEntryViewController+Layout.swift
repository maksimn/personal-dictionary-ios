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
        initTranslationDirectionView()
        initTableView()
        initLabel()
        initRetryButton()
        initActivityIndicator()
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

    private func initTranslationDirectionView() {
        let parentView = UIView()

        view.addSubview(parentView)
        parentView.addSubview(translationDirectionView)
        parentView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
        }
        translationDirectionView.layoutTo(view: parentView)
    }

    private func initTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = theme.backgroundColor
        tableView.layer.cornerRadius = 8
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.dataSource = datasource
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 38, left: 12, bottom: 12, right: 12))
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
