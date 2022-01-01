//
//  NetwordIndicatorInteractor.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

protocol NetworkIndicatorInteractor {

    var presenter: NetworkIndicatorPresenter? { get set }

    var areRequestsPending: Bool { get }
}
