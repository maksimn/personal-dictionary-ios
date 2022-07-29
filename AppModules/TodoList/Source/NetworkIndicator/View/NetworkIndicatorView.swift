//
//  NetwordIndicatorView.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

protocol NetworkIndicatorView: AnyObject {

    var presenter: NetworkIndicatorPresenter? { get set }

    func set(visible: Bool)
}
