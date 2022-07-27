//
//  TodoListMVP.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 12.07.2021.
//

import UIKit

final class TodoListMVPGraph: TodoListMVP {

    private let view: TodoListView
    private let service: TodoListService

    init(_ service: TodoListService) {
        self.service = service

        let networkIndicatorBuilder = NetworkIndicatorBuilderImpl(httpRequestCounter: service.httpRequestCounter)
        let appViewParams = AppViewParams(backgroundLightColor: Colors.backgroundLightColor,
                                          highPriorityMark: Images.highPriorityMark,
                                          lowPriorityMark: Images.lowPriorityMark)
        let todoEditorBuilder = TodoEditorBuilderImpl(service: service,
                                                      appViewParams: appViewParams)

        view = TodoListViewOne(
            networkIndicatorBuilder: networkIndicatorBuilder,
            completedItemCounterBuilder: CompletedItemCounterBuilderImp()
        )
        var model: TodoListModel = TodoListModelOne(
            service: service,
            updatedTodoItemStream: UpdatedTodoItemStreamImp.instance,
            deletedTodoItemStream: DeletedTodoItemStreamImp.instance
        )
        let presenter: TodoListPresenter = TodoListPresenterOne(model: model,
                                                                view: view,
                                                                todoEditorBuilder: todoEditorBuilder)

        view.presenter = presenter
        model.presenter = presenter
    }

    var viewController: UIViewController? {
        view.viewController
    }
}
