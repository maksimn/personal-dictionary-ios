//
//  SearchTextInputMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

protocol SearchTextInputMVVM {

    var uiview: UIView { get }

    var model: SearchTextInputModel? { get }
}
