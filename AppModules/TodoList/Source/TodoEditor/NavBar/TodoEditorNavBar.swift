//
//  TodoDetailsNavBar.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 23.06.2021.
//

import UIKit

class TodoEditorNavBar {

    var onSaveButtonTap: (() -> Void)?
    var onCancelButtonTap: (() -> Void)?

    private lazy var saveBarButtonItem = UIBarButtonItem(title: Strings.save, style: .plain,
                                                         target: self, action: #selector(saveButtonTap))
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var activityBarButtonItem = UIBarButtonItem(customView: activityIndicator)

    init(_ navigationItem: UINavigationItem) {
        navigationItem.title = Strings.todo
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItems = [saveBarButtonItem, activityBarButtonItem]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.cancel, style: .plain,
                                                            target: self, action: #selector(cancelButtonTap))
    }

    @objc private func saveButtonTap() {
        onSaveButtonTap?()
    }

    @objc private func cancelButtonTap() {
        onCancelButtonTap?()
    }

    func setActivityIndicator(visible: Bool) {
        visible ?
            activityIndicator.startAnimating() :
            activityIndicator.stopAnimating()
    }

    func setSaveButton(_ enabled: Bool) {
        saveBarButtonItem.isEnabled = enabled
    }
}
