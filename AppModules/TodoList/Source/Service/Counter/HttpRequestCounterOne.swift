//
//  PendingNetworkRequestCounter.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.07.2021.
//

import UIKit

class HttpRequestCounterOne: HttpRequestCounter {

    private let notificationCenter: NotificationCenter?

    private var count = 0

    init(_ notificationCenter: NotificationCenter?) {
        self.notificationCenter = notificationCenter
    }

    func increment() {
        count += 1
        notificationCenter?.post(name: .httpRequestCounterIncrement, object: nil)
    }

    func decrement() {
        if count > 0 {
            count -= 1
            notificationCenter?.post(name: .httpRequestCounterDecrement, object: nil)
        }
    }

    var areRequestsPending: Bool {
        count > 0
    }
}
