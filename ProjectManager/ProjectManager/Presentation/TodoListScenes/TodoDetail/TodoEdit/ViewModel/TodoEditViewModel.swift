//
//  DefaultTodoDetailViewModel.swift
//  ProjectManager
//
//  Created by 김도연 on 2022/07/06.
//

import Foundation
import Combine

protocol TodoEditViewModelInput {
    func viewDidLoad()
    func didTapDoneButton(title: String?, content: String?, deadline: Date?)
    func didTapEditButton()
}

protocol TodoEditViewModelOutput {
    var state: PassthroughSubject<TodoEditViewModel.State, Never> { get }
}

protocol TodoEditViewModelable: TodoEditViewModelInput, TodoEditViewModelOutput {}

final class TodoEditViewModel: TodoEditViewModelable {
    
    // MARK: - Output
    
    enum State {
        case item(item: Todo)
        case viewTitle(title: String)
        case isEdited
        case dismissView
        case showErrorAlert(message: String)
    }
    
    let state = PassthroughSubject<State, Never>()
    
    private let todo: Todo
    private let todoUseCase: TodoListUseCaseable
    private let historyUseCase: TodoHistoryUseCaseable
    private var cancellableBag = Set<AnyCancellable>()
    
    init(todoUseCase: TodoListUseCaseable, historyUseCase: TodoHistoryUseCaseable, todoListModel: Todo) {
        self.todoUseCase = todoUseCase
        self.historyUseCase = historyUseCase
        self.todo = todoListModel
    }
}

extension TodoEditViewModel {
    
    // MARK: - Input
    
    func viewDidLoad() {
        state.send(.viewTitle(title: "TODO"))
        state.send(.item(item: todo))
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
        
        let todoItem = Todo(
            title: title,
            content: content,
            deadline: deadline,
            processType: todo.processType,
            id: todo.id
        )
        updateTodoItem(todoItem)
        
        let historyItem = TodoHistory(title: "[수정] \(title)", createdAt: Date())
        createHistoryItem(historyItem)

        state.send(.dismissView)
    }
    
    private func updateTodoItem(_ item: Todo) {
        todoUseCase.update(item)
        .sink(
            receiveCompletion: {
                guard case .failure(let error) = $0 else { return}
                self.state.send(.showErrorAlert(message: error.localizedDescription))
            }, receiveValue: {}
        )
        .store(in: &cancellableBag)
    }
    
    private func createHistoryItem(_ item: TodoHistory) {
        historyUseCase.create(item)
            .sink(
                receiveCompletion: {
                    guard case .failure(let error) = $0 else { return}
                    self.state.send(.showErrorAlert(message: error.localizedDescription))
                }, receiveValue: {}
            )
            .store(in: &cancellableBag)
    }
    
    func didTapEditButton() {
        state.send(.isEdited)
    }
}
