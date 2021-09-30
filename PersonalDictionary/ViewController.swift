//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class ViewController: UIViewController {

    let newWordButton = UIButton()

    let newWordMVVM: NewWordMVVM

    init(newWordMVVM: NewWordMVVM) {
        self.newWordMVVM = newWordMVVM
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

    @objc
    func onNewWordButtonTap() {
        guard let newWordViewController = newWordMVVM.viewController else { return }

        newWordViewController.modalPresentationStyle = .popover

        present(newWordViewController, animated: true, completion: nil)
    }
}
