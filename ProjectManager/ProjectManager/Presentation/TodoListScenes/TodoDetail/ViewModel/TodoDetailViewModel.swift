//
//  DefaultTodoDetailViewModel.swift
//  ProjectManager
//
//  Created by 김도연 on 2022/07/06.
//

import Foundation
import Combine

protocol TodoDetailViewModelInput {
    func viewDidLoad()
    func didTapDoneButton(title: String?, content: String?, deadline: Date?)
    func didTapEditButton()
    func viewDidDisapper(title: String?, content: String?)
}

protocol TodoDetailViewModelOutput {
    var item: Just<Todo> { get }
    var isEdited: PassthroughSubject<Bool, Never> { get }
    var isCreated: PassthroughSubject<Bool, Never> { get }
    var title: CurrentValueSubject<String, Never> { get }
    var dismissView: PassthroughSubject<Void, Never> { get }
}

protocol TodoDetailViewModelable: TodoDetailViewModelInput, TodoDetailViewModelOutput {}

final class TodoDetailViewModel: TodoDetailViewModelable {
    
    // MARK: - Output
    
    var item: Just<Todo> {
        return Just(todoListModel)
    }
    
    let isEdited = PassthroughSubject<Bool, Never>()
    let isCreated = PassthroughSubject<Bool, Never>()
    let title = CurrentValueSubject<String, Never>("TODO")
    let dismissView = PassthroughSubject<Void, Never>()

    private let todoListModel: Todo
    private let todoUseCase: TodoListUseCaseable
    private let historyUseCase: TodoHistoryUseCaseable
    
    init(todoUseCase: TodoListUseCaseable, historyUseCase: TodoHistoryUseCaseable, todoListModel: Todo) {
        self.todoUseCase = todoUseCase
        self.historyUseCase = historyUseCase
        self.todoListModel = todoListModel
    }
}

extension TodoDetailViewModel {
    
    // MARK: - Input
    
    func viewDidLoad() {
        if todoListModel.title.isEmpty && todoListModel.content.isEmpty {
            isCreated.send(true)
        } else {
            isEdited.send(false)
        }
    }
    
    func didTapDoneButton(title: String?, content: String?, deadline: Date?) {
        guard let title = title,
              let content = content,
              let deadline = deadline
        else {
            return
        }
        
        if title.isEmpty && content.isEmpty {
            return
        }
        
        _ = todoUseCase.update(
            Todo(
                title: title,
                content: content,
                deadline: deadline,
                processType: todoListModel.processType,
                id: todoListModel.id
            )
        )
        
        let historyItem = TodoHistory(title: "[수정] \(title)", createdAt: Date())
        
        _ = historyUseCase.create(historyItem)
        
        dismissView.send(())
    }
    
    func didTapEditButton() {
        isCreated.send(true)
    }
    
    func viewDidDisapper(title: String?, content: String?) {
        _ = todoUseCase.deleteLastItem(title: title, content: content)
    }
}
