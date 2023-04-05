//
//  EditorBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ComposableArchitecture
import CoreModule
import UIKit

final class EditorBuilder: ViewControllerBuilder {

    private let store: StoreOf<Editor>
    private let networkIndicatorStore: StoreOf<NetworkIndicator>

    init(store: StoreOf<Editor>, networkIndicatorStore: StoreOf<NetworkIndicator>) {
        self.store = store
        self.networkIndicatorStore = networkIndicatorStore
    }

    func build() -> UIViewController {
        let bundle = Bundle.module

        let normalPriorityText = bundle.moduleLocalizedString("LS_NORMAL_PRIORITY")
        let newTodoPlaceholder = bundle.moduleLocalizedString("LS_TODO_2")
        let priorityText = bundle.moduleLocalizedString("LS_PRIORITY")
        let deadlineText = bundle.moduleLocalizedString("LS_DEADLINE")
        let removeText = bundle.moduleLocalizedString("LS_DELETE")
        let saveText = bundle.moduleLocalizedString("LS_SAVE")
        let cancelText = bundle.moduleLocalizedString("LS_CANCEL")
        let todoText = bundle.moduleLocalizedString("LS_TODO")

        let highPriorityImage = UIImage(named: "high-priority", in: bundle, compatibleWith: nil)!
        let lowPriorityImage = UIImage(named: "low-priority", in: bundle, compatibleWith: nil)!

        let viewParams = EditorViewParams(
            prioritySegmentedControlItems: [lowPriorityImage, normalPriorityText, highPriorityImage],
            newTodoPlaceholder: newTodoPlaceholder,
            priority: priorityText,
            deadlineText: deadlineText,
            remove: removeText,
            navBarStrings: EditorNavBarStrings(
                save: saveText,
                cancel: cancelText,
                todo: todoText
            )
        )
        let editorViewController = EditorViewController(
            params: viewParams,
            theme: Theme.data,
            store: store,
            networkIndicatorBuilder: NetworkIndicatorBuilder(store: networkIndicatorStore),
            keyboardUDFBuilder: KeyboardUDFBuilder(
                store: store.scope(state: \.keyboard, action: Editor.Action.keyboard)
            )
        )
        let editor = UINavigationController(rootViewController: editorViewController)

        editor.modalPresentationStyle = .overFullScreen

        return editor
    }
}
