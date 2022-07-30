//
//  CounterBuilder.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import UIKit

protocol CounterGraph {

    var view: UIView { get }

    var model: CounterModel? { get }
}
