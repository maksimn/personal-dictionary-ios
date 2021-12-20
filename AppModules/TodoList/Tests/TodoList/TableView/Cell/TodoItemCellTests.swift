//
//  TodoItemCellTests.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 22.06.2021.
//

import XCTest
@testable import TodoList

class TodoItemCellTests: XCTestCase {

    func test_countNumberOfLines_singleLineText_returnsOne() throws {
        let text = "AA\n"

        let numLines = TodoItemCell.countNumberOfLines(for: text, cellWidth: UIScreen.main.bounds.width,
                                                       priority: .normal)

        XCTAssertEqual(numLines, 1)
    }

    func test_countNumberOfLines_twoLinesText_returnsTwo() throws {
        let text = "AA\nAA\n"

        let numLines = TodoItemCell.countNumberOfLines(for: text, cellWidth: UIScreen.main.bounds.width,
                                                       priority: .normal)

        XCTAssertEqual(numLines, 2)
    }

    func test_countNumberOfLines_threeLinesText_returnsThree() throws {
        let text = "AA\nAA\nAA\n"

        let numLines = TodoItemCell.countNumberOfLines(for: text, cellWidth: UIScreen.main.bounds.width,
                                                       priority: .normal)

        XCTAssertEqual(numLines, 3)
    }

    func test_countNumberOfLines_fourLinesText_returnsThree() throws {
        let text = "AA\nAA\nAA\nAA\n"

        let numLines = TodoItemCell.countNumberOfLines(for: text, cellWidth: UIScreen.main.bounds.width,
                                                       priority: .normal)

        XCTAssertEqual(numLines, 3)
    }

    func test_countNumberOfLines_emptyText_returnsOne() throws {
        let text = ""

        let numLines = TodoItemCell.countNumberOfLines(for: text, cellWidth: UIScreen.main.bounds.width,
                                                       priority: .normal)

        XCTAssertEqual(numLines, 1)
    }
}
