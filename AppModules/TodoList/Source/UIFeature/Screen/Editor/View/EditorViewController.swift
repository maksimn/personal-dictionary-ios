//
//  EditorViewController.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import Combine
import ComposableArchitecture
import UIKit

final class EditorViewController: UIViewController, UITextViewDelegate {

    let params: EditorViewParams
    let viewStore: ViewStoreOf<Editor>
    var cancellables: Set<AnyCancellable> = []

    let networkIndicatorView: UIView
    let keyboardController: UIViewController

    lazy var saveBarButtonItem = UIBarButtonItem(
        title: params.navBarStrings.save,
        style: .plain,
        target: self,
        action: #selector(onSaveButtonTap)
    )
    let scrollView = UIScrollView(frame: .zero)
    let textView = UITextView()
    let placeholderLabel = UILabel()
    let pillowView = UIView()
    let separatorViewOne = UIView()
    let separatorViewTwo = UIView()
    lazy var prioritySegmentedControl = UISegmentedControl(items: params.prioritySegmentedControlItems)
    let importanceLabel = UILabel()
    let deadlineTextLabel = UILabel()
    let deadlineSwitch = UISwitch()
    let deadlineButton = UIButton()
    let deadlineDatePicker = UIDatePicker()
    let removeButton = UIButton()

    let theme: Theme

    init(
        params: EditorViewParams,
        theme: Theme,
        store: StoreOf<Editor>,
        networkIndicatorBuilder: ViewBuilder,
        keyboardUDFBuilder: ViewControllerBuilder
    ) {
        self.params = params
        self.theme = theme
        self.viewStore = ViewStore(store)
        self.networkIndicatorView = networkIndicatorBuilder.build()
        self.keyboardController = keyboardUDFBuilder.build()
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewStore.publisher.sink(receiveValue: { [weak self] state in
            self?.set(state: state)
        }).store(in: &cancellables)
    }

    private func set(state: Editor.State) {
        saveBarButtonItem.isEnabled = state.canBeSaved
        removeButton.isEnabled = state.canBeDeleted
        removeButton.setTitleColor(state.canBeDeleted ? .systemRed : .systemGray, for: .normal)
        deadlineDatePicker.isHidden = state.isDeadlinePickerHidden
        separatorViewTwo.isHidden = state.isDeadlinePickerHidden
        textView.text = state.todo.text
        prioritySegmentedControl.setTodoPriority(state.todo.priority)
        placeholderLabel.isHidden = !state.todo.text.isEmpty

        if let deadline = state.todo.deadline {
            deadlineSwitch.setOn(true, animated: false)
            deadlineDatePicker.setDate(deadline, animated: false)
            deadlineButton.isHidden = false
            deadlineButton.setTitle(deadline.dMMMMyyyy, for: .normal)
        } else {
            deadlineSwitch.setOn(false, animated: false)
        }

        setupFrameLayout()

        let isLandscapeWithVisibleKeyboard = state.keyboard.isVisible && state.keyboard.orientation == .landscape

        pillowView.isHidden = isLandscapeWithVisibleKeyboard
        separatorViewOne.isHidden = isLandscapeWithVisibleKeyboard
        prioritySegmentedControl.isHidden = isLandscapeWithVisibleKeyboard
        importanceLabel.isHidden = isLandscapeWithVisibleKeyboard
        deadlineTextLabel.isHidden = isLandscapeWithVisibleKeyboard
        deadlineSwitch.isHidden = isLandscapeWithVisibleKeyboard
        deadlineButton.isHidden = !deadlineSwitch.isOn || isLandscapeWithVisibleKeyboard
        removeButton.isHidden = isLandscapeWithVisibleKeyboard
    }

    @objc
    func onCancelButtonTap() {
        viewStore.send(.close)
    }

    @objc
    func onSaveButtonTap() {
        let state = viewStore.state

        viewStore.send(.saveTodo(state.todo, state.mode))
    }

    @objc
    func onRemoveButtonTap() {
        viewStore.send(.deleteTodo(viewStore.state.todo))
    }

    @objc
    func onDeadlineSwitchValueChanged() {
        viewStore.send(.deadlineChanged(deadlineSwitch.isOn ? Date() : nil))
    }

    @objc
    func onDeadlineDatePickerValueChanged() {
        viewStore.send(.deadlineChanged(deadlineDatePicker.date))
    }

    @objc
    func onDeadlineButtonTap() {
        viewStore.send(.toggleDeadlinePickerVisibility)
    }

    func textViewDidChange(_ textView: UITextView) {
        viewStore.send(.textChanged(textView.text))
    }

    @objc
    func onPriorityChanged() {
        viewStore.send(.priorityChanged(prioritySegmentedControl.todoPriority))
    }
}
