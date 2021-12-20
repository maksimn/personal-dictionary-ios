//
//  TodoEditorPresenterOneTests.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

import XCTest
@testable import TodoList

// 1.2. Тесты доступности кнопки сохранить на экране добавления/редактирования.
class TestTodoEditorPresenterOne: XCTestCase {

    func testIsSaveButtonEnabled_creatingNew_falseWhenStartCreateNewItem() throws {
        // Arrange:
        let modelMock = NilTodoItemTodoEditorModelMock()
        let viewStub = TodoEditorViewStub()
        let presenter = TodoEditorPresenterOne(model: modelMock, view: viewStub)

        // Act:
        let result = presenter.isSaveButtonEnabled

        // Assert:
        XCTAssertFalse(result)
    }

    func testOnViewInputChanged_creatingNew_saveButtonEnabledWhenUserEnterTextInTodoEditor() throws {
        // Arrange:
        let modelMock = NilTodoItemTodoEditorModelMock()
        let viewStub = TodoEditorViewStub()
        let presenter = TodoEditorPresenterOne(model: modelMock, view: viewStub)

        // Act:
        presenter.onViewInputChanged(TodoEditorUserInput(text: "a", priority: .normal, deadline: nil))

        // Assert:
        XCTAssertTrue(presenter.isSaveButtonEnabled)
    }

    func testOnViewInputChanged_editingExisting_saveButtonDisabledUserInputFieldsEqualToInitialTodoItem() throws {
        // Arrange:
        let initialTodoItem = TodoItem(text: "a", priority: .high)
        let modelMock = TodoEditorModelMock(initialTodoItem)
        let viewStub = TodoEditorViewStub()
        let presenter = TodoEditorPresenterOne(model: modelMock, view: viewStub)

        // Act:
        presenter.onViewInputChanged(TodoEditorUserInput(text: initialTodoItem.text,
                                                         priority: initialTodoItem.priority,
                                                         deadline: initialTodoItem.deadline))

        // Assert:
        XCTAssertFalse(presenter.isSaveButtonEnabled)
    }

    func testOnViewInputChanged_editingExisting_saveButtonEnabledWhenUserChangesDataInEditor() throws {
        // Arrange:
        let initialTodoItem = TodoItem(text: "a", priority: .high)
        let modelMock = TodoEditorModelMock(initialTodoItem)
        let viewStub = TodoEditorViewStub()
        let presenter = TodoEditorPresenterOne(model: modelMock, view: viewStub)

        // Act:
        presenter.onViewInputChanged(TodoEditorUserInput(text: initialTodoItem.text,
                                                         priority: initialTodoItem.priority,
                                                         deadline: Date(timeIntervalSince1970: 1)))

        // Assert:
        XCTAssertTrue(presenter.isSaveButtonEnabled)
    }
}
