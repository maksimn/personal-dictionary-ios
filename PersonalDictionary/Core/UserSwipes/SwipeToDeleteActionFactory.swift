//
//  DeleteSwipeActionFactory.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import UIKit

struct DeleteActionStaticContent {
    let image: UIImage
}

struct DeleteActionStyles {
    let backgroundColor: UIColor
}

final class SwipeToDeleteActionFactory {

    private let staticContent: DeleteActionStaticContent
    private let styles: DeleteActionStyles
    private var onDeleteTap: ((Int) -> Void)?

    init(staticContent: DeleteActionStaticContent,
         styles: DeleteActionStyles,
         onDeleteTap: ((Int) -> Void)?) {
        self.staticContent = staticContent
        self.styles = styles
        self.onDeleteTap = onDeleteTap
    }

    func create(for row: Int) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "",
                                              handler: { (_, _, success: (Bool) -> Void) in
                                                self.onDeleteTap?(row)
                                                success(true)
                                              })

        deleteAction.image = staticContent.image
        deleteAction.backgroundColor = styles.backgroundColor

        return deleteAction
    }
}
