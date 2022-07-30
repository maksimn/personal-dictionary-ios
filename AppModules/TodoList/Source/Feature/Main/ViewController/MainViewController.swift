//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

final class MainViewController: UIViewController {

    private let richTodoListBuilder: RichTodoListBuilder
    lazy var richTodoListGraph = richTodoListBuilder.build()

    let routingButton = UIButton()

    init(mainTitle: String,
         richTodoListBuilder: RichTodoListBuilder,
         navToEditorBuilder: NavToEditorBuilder,
         networkIndicatorBuilder: NetworkIndicatorBuilder) {
        self.richTodoListBuilder = richTodoListBuilder
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = mainTitle
        view.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 1.00, alpha: 1.00)
        layout(richTodoListView: richTodoListGraph.view)
        layout(navToEditorBuilder)
        layout(networkIndicatorBuilder)
        layoutRoutingButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        richTodoListGraph.model?.load()
    }

    @objc
    func onRoutingButtonTap() {
        dismiss(animated: true, completion: nil)
    }
}
