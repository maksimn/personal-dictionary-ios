//
//  SharedMessage.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

public protocol SharedMessageStream {

    var sharedMessage: AsyncStream<String> { get }
}

public protocol SharedMessageSender {

    func send(sharedMessage: String)
}
