//
//  Builder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 18.01.2023.
//

import UIKit

protocol ViewBuilder {

    func build() -> UIView
}

public protocol ViewControllerBuilder {

    func build() -> UIViewController
}
