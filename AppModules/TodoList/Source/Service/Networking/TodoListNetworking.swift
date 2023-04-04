//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

protocol TodoListNetworking {

    func fetchTodoList(_ completion: @escaping TodoListDTOCallback)

    func createTodo(_ todoDTO: TodoDTO, _ completion: @escaping TodoDTOCallback)

    func updateTodo(_ todoDTO: TodoDTO, _ completion: @escaping TodoDTOCallback)

    func deleteTodo(_ id: String, _ completion: @escaping TodoDTOCallback)

    func syncTodoList(_ requestData: SyncTodoListRequestData, _ completion: @escaping TodoListDTOCallback)
}
