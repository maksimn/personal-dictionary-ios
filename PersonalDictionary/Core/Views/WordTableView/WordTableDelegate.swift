//
//  WordTableDelegate.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.11.2021.
//

import UIKit

typealias DeleteActionViewParams = ViewParams<DeleteActionStaticContent, DeleteActionStyles>

struct DeleteActionStaticContent {
    let image: UIImage
}

struct DeleteActionStyles {
    let backgroundColor: UIColor
}

final class WordTableDelegate: NSObject, UITableViewDelegate {

    var changedItemPosition: Int = -1

    private let deleteActionViewParams: DeleteActionViewParams?
    private var onDeleteTap: ((Int) -> Void)?

    init(onDeleteTap: ((Int) -> Void)?,
         deleteActionViewParams: DeleteActionViewParams?) {
        self.onDeleteTap = onDeleteTap
        self.deleteActionViewParams = deleteActionViewParams
        super.init()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let onDeleteTap = onDeleteTap,
              let deleteActionViewParams = deleteActionViewParams else {
            return nil
        }
        let deleteAction = UIContextualAction(style: .normal, title: "",
                                              handler: { (_, _, success: (Bool) -> Void) in
                                                onDeleteTap(indexPath.row)
                                                success(true)
                                              })

        deleteAction.image = deleteActionViewParams.staticContent.image
        deleteAction.backgroundColor = deleteActionViewParams.styles.backgroundColor

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
