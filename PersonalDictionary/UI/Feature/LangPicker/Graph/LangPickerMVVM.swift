//
//  LangPickerMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

protocol LangPickerMVVM {

    var uiview: UIView? { get }

    var model: LangPickerModel? { get }
}
