//
//  EditorBuilderImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import ComposableArchitecture
import UIKit

final class EditorBuilder: ViewControllerBuilder {

    private let store: StoreOf<Editor>
    private let networkIndicatorStore: StoreOf<NetworkIndicator>

    init(store: StoreOf<Editor>, networkIndicatorStore: StoreOf<NetworkIndicator>) {
        self.store = store
        self.networkIndicatorStore = networkIndicatorStore
    }

    func build() -> UIViewController {
        let normalPriorityText = NSLocalizedString("LS_NORMAL_PRIORITY", comment: "")
        let newTodoPlaceholder = NSLocalizedString("LS_TODO_2", comment: "")
        let priorityText = NSLocalizedString("LS_PRIORITY", comment: "")
        let deadlineText = NSLocalizedString("LS_DEADLINE", comment: "")
        let removeText = NSLocalizedString("LS_DELETE", comment: "")
        let saveText = NSLocalizedString("LS_SAVE", comment: "")
        let cancelText = NSLocalizedString("LS_CANCEL", comment: "")
        let todoText = NSLocalizedString("LS_TODO", comment: "")

        let highPriorityImage = UIImage(named: "high-priority")!
        let lowPriorityImage = UIImage(named: "low-priority")!

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
