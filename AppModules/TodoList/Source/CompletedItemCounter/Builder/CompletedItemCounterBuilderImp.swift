//
//  CompletedItemCounterBuilderImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import UIKit

final class CompletedItemCounterBuilderImp: CompletedItemCounterBuilder {

    func build() -> CompletedItemCounterGraph {
        CompletedItemCounterGraphImp()
    }
}
