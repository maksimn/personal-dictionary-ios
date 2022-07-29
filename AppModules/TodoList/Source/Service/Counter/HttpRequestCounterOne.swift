//
//  PendingNetworkRequestCounter.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.07.2021.
//

import UIKit

class HttpRequestCounterOne: HttpRequestCounter {

    private let notificationCenter: NotificationCenter?

    private static var count = 0

    init(_ notificationCenter: NotificationCenter?) {
        self.notificationCenter = notificationCenter
    }

    func increment() {
        HttpRequestCounterOne.count += 1
        notificationCenter?.post(name: .httpRequestCounterIncrement, object: nil)
    }

    func decrement() {
        if HttpRequestCounterOne.count > 0 {
            HttpRequestCounterOne.count -= 1
            notificationCenter?.post(name: .httpRequestCounterDecrement, object: nil)
        }
    }

    var areRequestsPending: Bool {
        HttpRequestCounterOne.count > 0
    }
}
