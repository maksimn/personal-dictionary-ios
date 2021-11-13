//
//  SearchModeMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import UIKit

protocol SearchModePickerMVVM {

    var uiview: UIView { get }

    var model: SearchModePickerModel? { get }
}
