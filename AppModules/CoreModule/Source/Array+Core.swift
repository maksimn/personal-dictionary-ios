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

extension Array where Element: Hashable {

    public func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    public mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
