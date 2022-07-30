//
//  MyTodoDetailsView.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import UIKit

final class EditorViewController: UIViewController, EditorView, UITextViewDelegate {

    var presenter: EditorPresenter?

    let params: EditorViewParams

    var navBar: EditorNavBar?
    let scrollView = UIScrollView(frame: .zero)
    let textView = UITextView()
    let placeholderLabel = UILabel()
    let pillowView = UIView()
    let separatorViewOne = UIView()
    let separatorViewTwo = UIView()
    lazy var prioritySegmentedControl = UISegmentedControl(items: params.prioritySegmentedControlItems)
    let importanceLabel = UILabel()
    let shouldBeDoneBeforeLabel = UILabel()
    let deadlineSwitch = UISwitch()
    let deadlineButton = UIButton()
    let deadlineDatePicker = UIDatePicker()
    let removeButton = UIButton()

    let keyboardEventsHandle = KeyboardEventsHandle()
    var isKeyboardActive: Bool = false
    var keyboardSize: CGSize = .zero

    let networkIndicatorBuilder: NetworkIndicatorBuilder

    init(params: EditorViewParams,
         networkIndicatorBuilder: NetworkIndicatorBuilder) {
        self.params = params
        self.networkIndicatorBuilder = networkIndicatorBuilder
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - EditorView

    func set(todoItem: TodoItem?) {
        removeButton.setTitleColor(.systemRed, for: .normal)
        textView.text = todoItem?.text
        prioritySegmentedControl.setTodoItem(priority: todoItem?.priority ?? .normal)
        placeholderLabel.isHidden = (todoItem?.text.count ?? 0) > 0

        if let deadline = todoItem?.deadline {
            deadlineSwitch.setOn(true, animated: false)
            deadlineDatePicker.setDate(deadline, animated: false)
            deadlineButton.isHidden = false
            deadlineButton.setTitle(deadlineDatePicker.date.formattedDate, for: .normal)
        } else {
            deadlineSwitch.setOn(false, animated: false)
        }
    }

    func setSaveButton(enabled: Bool) {
        navBar?.setSaveButton(enabled)
    }

    func setRemoveButton(enabled: Bool) {
        removeButton.setTitleColor(enabled ? .systemRed : .systemGray, for: .normal)
        removeButton.isEnabled = enabled
    }

    func hide() {
        dismiss(animated: true, completion: nil)
    }

    func clear() {
        deadlineDatePicker.isHidden = true
        separatorViewTwo.isHidden = true
        deadlineButton.isHidden = true
        textView.text = ""
        prioritySegmentedControl.selectedSegmentIndex = 1
        placeholderLabel.isHidden = false
        deadlineSwitch.setOn(false, animated: false)
        removeButton.setTitleColor(.systemGray, for: .normal)
        setupFrameLayout()
    }

    func setTextPlaceholder(visible: Bool) {
        placeholderLabel.isHidden = !visible
    }

    func setDeadlineButton(visible: Bool) {
        deadlineButton.isHidden = !visible
    }

    func updateDeadlineButtonTitle() {
        deadlineButton.setTitle(deadlineDatePicker.date.formattedDate, for: .normal)
    }

    func setDeadlineDatePicker(visible: Bool) {
        deadlineDatePicker.isHidden = !visible
        separatorViewTwo.isHidden = deadlineDatePicker.isHidden
    }

    var isDeadlineDatePickerVisible: Bool {
        !deadlineDatePicker.isHidden
    }

    // MARK: - User Actions

    func onCancelButtonTap() {
        hide()
    }

    func onSaveButtonTap() {
        presenter?.save(userInput())
    }

    @objc
    func onRemoveButtonTap() {
        presenter?.removeTodoItem()
    }

    @objc
    func onDeadlineSwitchValueChanged() {
        presenter?.handleDeadlineSwitchValueChanged(deadlineSwitch.isOn, userInput())
        setupFrameLayout()
    }

    @objc
    func onDeadlineDatePickerValueChanged() {
        presenter?.handleDeadlineDatePickerValueChanged(userInput())
    }

    @objc
    func onDeadlineButtonTap() {
        setDeadlineDatePicker(visible: deadlineDatePicker.isHidden)
        setupFrameLayout()
    }

    func textViewDidChange(_ textView: UITextView) {
        presenter?.handleTextInput(userInput())
    }

    @objc
    func onPriorityChanged() {
        presenter?.setIfSaveButtonEnabledOnUserInput(userInput())
    }

    private func userInput() -> EditorUserInput {
        EditorUserInput(text: textView.text.trimmingCharacters(in: .whitespacesAndNewlines),
                            priority: prioritySegmentedControl.todoItemPriority,
                            deadline: deadlineSwitch.isOn ? deadlineDatePicker.date : nil)
    }
}
