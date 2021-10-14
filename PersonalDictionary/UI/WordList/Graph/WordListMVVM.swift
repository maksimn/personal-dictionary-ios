//
//  WordListMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

protocol WordListMVVM {

    var viewController: UIViewController? { get }

    var navigationController: UINavigationController? { get }
}
