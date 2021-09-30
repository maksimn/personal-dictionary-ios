//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class ViewController: UIViewController {

    let newWordButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }

    @objc
    func onNewWordButtonTap() {
        let newWordViewController = NewWordViewController()

        newWordViewController.modalPresentationStyle = .popover

        present(newWordViewController, animated: true, completion: nil)
    }
}
