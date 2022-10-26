//
//  Builder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 27.10.2022.
//

import UIKit

protocol ViewBuilder {

    func build() -> UIView
}

protocol ViewControllerBuilder {

    func build() -> UIViewController
}
