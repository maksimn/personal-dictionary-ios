//
//  WordListGraph.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

protocol SearchWordListGraph {

    var viewController: UIViewController { get }

    var model: SearchWordListModel? { get }
}
