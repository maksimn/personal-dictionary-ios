//
//  EditorBuilderImpl.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.01.2022.
//

final class EditorBuilderImpl: EditorBuilder {

    func build(initTodoItem: TodoItem?) -> UIViewController {
        let viewParams = EditorViewParams(
            backgroundLightColor: Colors.backgroundLightColor,
            prioritySegmentedControlItems: [Images.lowPriorityMark, "нет", Images.highPriorityMark],
            newTodoPlaceholder: "Что надо сделать?",
            priority: "Важность",
            shouldBeDoneBefore: "Сделать до",
            remove: "Удалить",
            navBar: EditorNavBarParams(
                save: "Сохранить",
                todo: "Дело",
                cancel: "Отменить"
            )
        )

        var interactor: EditorInteractor = EditorInteractorImpl(
            todoItem: initTodoItem,
            createdTodoItemPublisher: CreatedTodoItemStreamImp.instance,
            updatedTodoItemPublisher: UpdatedTodoItemStreamImp.instance,
            deletedTodoItemPublisher: DeletedTodoItemStreamImp.instance
        )
        let view = EditorViewController(
            params: viewParams,
            networkIndicatorBuilder: NetworkIndicatorBuilderImpl()
        )
        let presenter = EditorPresenterImpl(model: interactor, view: view)

        view.presenter = presenter
        interactor.presenter = presenter

        return view
    }
}