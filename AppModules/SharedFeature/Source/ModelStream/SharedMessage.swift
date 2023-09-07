//
//  SharedMessage.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import RxSwift

public protocol SharedMessageStream {

    var sharedMessage: Observable<String> { get }
}

public protocol SharedMessageSender {

    func send(sharedMessage: String)
}
