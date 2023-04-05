//
//  UITableView+Core.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 13.01.2022.
//

import UIKit

extension UITableView {

    public func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        return lastIndexPath == indexPath
    }
}
