//
//  PreviewViewController.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

public final class PreviewViewController: UIViewController {

    private let builder = ToggableItemListBuilderImp()
    private lazy var graph = builder.build()

    public init() {
        super.init(nibName: nil, bundle: nil)
        let featureView = graph.view

        view.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 1.00, alpha: 1.00)
        view.addSubview(featureView)
        featureView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        graph.model?.load()
    }
}
