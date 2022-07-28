//
//  ToggableItemListGraph.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

protocol ToggableItemListGraph {

    var view: UIView { get }

    var model: ToggableItemListModel? { get }
}
