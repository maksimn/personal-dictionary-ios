//
//  PreviewViewController.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

public final class PreviewViewController: UIViewController {

    private let builder: NavToItemEditorBuilder

    public init() {
        self.builder = NavToItemEditorBuilderImp(navigationController: nil)
        super.init(nibName: nil, bundle: nil)
        let featureView = builder.build()

        view.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 1.00, alpha: 1.00)
        view.addSubview(featureView)
        featureView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}
