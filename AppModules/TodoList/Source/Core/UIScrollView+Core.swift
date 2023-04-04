//
//  UIScrollView+Core.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 16.02.2023.
//

import UIKit

extension UIScrollView {

    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.height + self.contentInset.bottom)

        setContentOffset(bottomOffset, animated: true)
    }
}
