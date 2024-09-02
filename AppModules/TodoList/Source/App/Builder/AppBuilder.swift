//
//  AppBuilder.swift
//  TodoList
//
//  Created by Maksim Ivanov on 07.02.2023.
//

import CoreModule
import UIKit

public final class AppBuilder: ViewControllerBuilder {

    public init() { }

    public func build() -> UIViewController {
        MainScreen()
    }
}

class MainScreen: UIViewController {

    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        label.text = "To-do list"
        label.textAlignment = .center
        label.textColor = .darkGray
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = view.frame
    }
}
