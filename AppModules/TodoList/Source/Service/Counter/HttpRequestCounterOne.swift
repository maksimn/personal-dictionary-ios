//
//  PendingNetworkRequestCounter.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.07.2021.
//

import UIKit

class HttpRequestCounterOne: HttpRequestCounter {

    private static var count = 0

    private let httpRequestCounterPublisher: HttpRequestCounterPublisher

    init(httpRequestCounterPublisher: HttpRequestCounterPublisher) {
        self.httpRequestCounterPublisher = httpRequestCounterPublisher
    }

    func increment() {
        HttpRequestCounterOne.count += 1
        httpRequestCounterPublisher.notifyOnRequestCounterIncrement()
    }

    func decrement() {
        if HttpRequestCounterOne.count > 0 {
            HttpRequestCounterOne.count -= 1
            httpRequestCounterPublisher.notifyOnRequestCounterDecrement()
        }
    }

    var areRequestsPending: Bool {
        HttpRequestCounterOne.count > 0
    }
}
