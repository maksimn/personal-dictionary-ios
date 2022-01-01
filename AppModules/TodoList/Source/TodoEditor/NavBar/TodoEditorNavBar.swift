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

    init(_ navigationItem: UINavigationItem,
         _ networkIndicatorBuilder: NetworkIndicatorBuilder) {
        let networkIndicatorVIPER = networkIndicatorBuilder.build()
        let activityBarButtonItem = UIBarButtonItem(customView: networkIndicatorVIPER.uiview)

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

    func setSaveButton(_ enabled: Bool) {
        saveBarButtonItem.isEnabled = enabled
    }
}
