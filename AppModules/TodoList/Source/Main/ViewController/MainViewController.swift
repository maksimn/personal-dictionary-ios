//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

final class MainViewController: UIViewController {

    private let toggableItemListBuilder: ToggableItemListBuilder
    lazy var toggableItemListGraph = toggableItemListBuilder.build()

    let routingButton = UIButton()

    init(toggableItemListBuilder: ToggableItemListBuilder,
         navToItemEditorBuilder: NavToItemEditorBuilder,
         networkIndicatorBuilder: NetworkIndicatorBuilder) {
        self.toggableItemListBuilder = toggableItemListBuilder
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = Strings.myTodos
        view.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 1.00, alpha: 1.00)
        layout(toggableItemListView: toggableItemListGraph.view)
        layout(navToItemEditorBuilder)
        layout(networkIndicatorBuilder)
        layoutRoutingButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toggableItemListGraph.model?.load()
    }

    @objc
    func onRoutingButtonTap() {
        dismiss(animated: true, completion: nil)
    }
}
