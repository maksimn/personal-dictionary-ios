//
//  DeleteSwipeActionFactory.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import UIKit

struct DeleteActionViewResource {
    let image: UIImage
    let backgroundColor: UIColor
}

final class SwipeToDeleteActionFactory {

    private let viewResource: DeleteActionViewResource
    private var onDeleteTap: ((Int) -> Void)?

    init(viewResource: DeleteActionViewResource,
         onDeleteTap: ((Int) -> Void)?) {
        self.viewResource = viewResource
        self.onDeleteTap = onDeleteTap
    }

    func create(for row: Int) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "",
                                              handler: { (_, _, success: (Bool) -> Void) in
                                                self.onDeleteTap?(row)
                                                success(true)
                                              })

        deleteAction.image = viewResource.image
        deleteAction.backgroundColor = viewResource.backgroundColor

        return deleteAction
    }
}
