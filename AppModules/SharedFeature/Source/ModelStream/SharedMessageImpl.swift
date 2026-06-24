//
//  SharedMessageImpl.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import Foundation

public class SharedMessageStreamImpl: SharedMessageStream, SharedMessageSender {

    private init() {}

    public static let instance = SharedMessageStreamImpl()

    private var continuation: AsyncStream<String>.Continuation?

    public var sharedMessage: AsyncStream<String> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    public func send(sharedMessage: String) {
        continuation?.yield(sharedMessage)
    }
}
