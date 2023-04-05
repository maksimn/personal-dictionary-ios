//
//  Array+Core.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 21.02.2023.
//

extension Array {

    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
