//
//  MyTodoDetailsView.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import UIKit

final class TodoEditorViewOne: UIViewController, TodoEditorView {

    var presenter: TodoEditorPresenter?

    var navBar: TodoEditorNavBar?

    let scrollView = UIScrollView(frame: .zero)
    let textView = UITextView()
    let placeholderLabel = UILabel()
    let pillowView = UIView()
    let separatorViewOne = UIView()
    let separatorViewTwo = UIView()
    let prioritySegmentedControl = UISegmentedControl(items: [Images.lowPriorityMark, Strings.noPriority,
                                                              Images.highPriorityMark])
    let importanceLabel = UILabel()
    let shouldBeDoneBeforeLabel = UILabel()
    let deadlineSwitch = UISwitch()
    let deadlineButton = UIButton()
    let deadlineDatePicker = UIDatePicker()
    let removeButton = UIButton()

    let priorityMapper = TodoItemPriorityMapper()
    let keyboardEventsHandle = KeyboardEventsHandle()

    var isKeyboardActive: Bool = false
    var keyboardSize: CGSize = .zero

    let networkIndicatorBuilder: NetworkIndicatorBuilder

    init(networkIndicatorBuilder: NetworkIndicatorBuilder) {
        self.networkIndicatorBuilder = networkIndicatorBuilder
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - TodoEditorView

    func set(todoItem: TodoItem?) {
        removeButton.setTitleColor(.systemRed, for: .normal)
        textView.text = todoItem?.text
        prioritySegmentedControl.selectedSegmentIndex = priorityMapper.index(for: todoItem?.priority ?? .normal)
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

    func hide() {
        dismiss(animated: true, completion: nil)
    }

    func clear() {
        deadlineDatePicker.isHidden = true
        separatorViewTwo.isHidden = true
        deadlineButton.isHidden = true
        textView.text = Strings.empty
        prioritySegmentedControl.selectedSegmentIndex = 1
        placeholderLabel.isHidden = false
        deadlineSwitch.setOn(false, animated: false)
        removeButton.setTitleColor(.systemGray, for: .normal)
        setupFrameLayout()
    }

    // MARK: - Private

    private func setDeadlineButtonTitle() {
        deadlineButton.setTitle(deadlineDatePicker.date.formattedDate, for: .normal)
    }

    private func userInput() -> TodoEditorUserInput {
        let deadline = deadlineSwitch.isOn ? deadlineDatePicker.date : nil
        let priority = priorityMapper.priority(for: prioritySegmentedControl.selectedSegmentIndex)
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        return TodoEditorUserInput(text: trimmedText, priority: priority, deadline: deadline)
    }
}

/// Обработка пользовательских действий (нажатия и т.д.).
extension TodoEditorViewOne: UITextViewDelegate {

    func onCancelButtonTap() {
        hide()
    }

    func onSaveButtonTap() {
        presenter?.save(userInput())
    }

    @objc func onRemoveButtonTap() {
        presenter?.removeTodoItem()
    }

    @objc func onDeadlineSwitchValueChanged() {
        if deadlineSwitch.isOn {
            deadlineButton.isHidden = false
            setDeadlineButtonTitle()
        } else {
            deadlineButton.isHidden = true
            deadlineDatePicker.isHidden = true
        }
        setupFrameLayout()
        presenter?.setIfSaveButtonEnabledOnUserInput(userInput())
    }

    @objc func onDeadlineDatePickerValueChanged() {
        setDeadlineButtonTitle()
        presenter?.setIfSaveButtonEnabledOnUserInput(userInput())
    }

    @objc func onDeadlineButtonTap() {
        deadlineDatePicker.isHidden = !deadlineDatePicker.isHidden
        separatorViewTwo.isHidden = deadlineDatePicker.isHidden
        setupFrameLayout()
    }

    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text
        let isTextNotEmpty = (text?.count ?? 0) > 0

        placeholderLabel.isHidden = isTextNotEmpty
        removeButton.setTitleColor(isTextNotEmpty ? .systemRed : .systemGray, for: .normal)
        presenter?.setIfSaveButtonEnabledOnUserInput(userInput())
    }

    @objc func onPriorityChanged() {
        presenter?.setIfSaveButtonEnabledOnUserInput(userInput())
    }
}
