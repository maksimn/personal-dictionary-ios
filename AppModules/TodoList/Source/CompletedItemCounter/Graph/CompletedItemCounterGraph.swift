//
//  CompletedItemCounterBuilder.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import UIKit

protocol CompletedItemCounterGraph {

    var view: UIView { get }

    var model: CompletedItemCounterModel? { get }
}
