//
//  ItemListGraph.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

protocol ItemListGraph {

    var view: UIView { get }

    var model: ItemListModel? { get }
}
