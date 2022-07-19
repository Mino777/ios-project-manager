//
//  TodoCreateViewModel.swift
//  ProjectManager
//
//  Created by 김도연 on 2022/07/19.
//

import Combine
import Foundation

protocol TodoCreateViewModelInput {
    func didTapCancelButton()
    func didTapDoneButton(_ title: String?, _ content: String?, _ deadline: Date?)
}

protocol TodoCreateViewModelOutput {
    var dismissView: PassthroughSubject<Void, Never> { get }
}

protocol TodoCreateViewModelable: TodoCreateViewModelInput, TodoCreateViewModelOutput {}

final class TodoCreateViewModel: TodoCreateViewModelable {
    private let todoUseCase: TodoListUseCaseable
    private let historyUseCase: TodoHistoryUseCaseable
    
    // MARK: - Output
    
    let dismissView = PassthroughSubject<Void, Never>()
    
    init(todoUseCase: TodoListUseCaseable, historyUseCase: TodoHistoryUseCaseable) {
        self.todoUseCase = todoUseCase
        self.historyUseCase = historyUseCase
    }
}

extension TodoCreateViewModel {
    
    // MARK: - Input
    
    func didTapCancelButton() {
        dismissView.send(())
    }
    
    func didTapDoneButton(_ title: String?, _ content: String?, _ deadline: Date?) {
        guard let title = title, let content = content, let deadline = deadline else {
            return
        }
        
        let todoItem = Todo(title: title, content: content, deadline: deadline)
        _ = todoUseCase.create(todoItem)
        
        let historyItem = TodoHistory(title: "[생성] \(todoItem.title)", createdAt: Date())
        _ = historyUseCase.create(historyItem)
        
        dismissView.send(())
    }
}