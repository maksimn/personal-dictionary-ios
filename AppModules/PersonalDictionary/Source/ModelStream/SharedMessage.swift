//
//  SharedMessage.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import RxSwift

protocol SharedMessageStream {

    var sharedMessage: Observable<String> { get }
}

protocol SharedMessageSender {

    func send(sharedMessage: String)
}
