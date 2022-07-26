//
//  TodoListDIContainer.swift
//  ProjectManager
//
//  Created by 김도연 on 2022/07/06.
//

import UIKit
import Combine

final class TodoListDIContainer {
    struct Dependencies {
        unowned let todoStorage: LocalStorageable
        unowned let remoteStorage: RemoteStorageable
        unowned let historyStorage: HistoryStorageable
    }
    
    private let isFirstLogin = UserDefaults.standard.bool(forKey: "isFirstLogin")
    private let dependencies: Dependencies
    
    private unowned var parentViewModel: TodoListViewModel?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension TodoListDIContainer {
    
    // MARK: ViewController
    
    func makeTodoListViewController() -> TodoListViewController {
        return TodoListViewController(viewModel: makeTodoListViewModel(), dependency: self)
    }
    
    // MARK: - View
    
    func makeTodoListView() -> TodoListView {
        return TodoListView(dependency: self)
    }
    
    func makeTodoView(processType: ProcessType) -> TodoView {
        return TodoView(viewModel: makeTodoViewModel(processType: processType))
    }
    
    // MARK: - ViewModel
    
    private func makeTodoListViewModel() -> TodoListViewModelable {
        let viewModel = TodoListViewModel(todoUseCase: makeTodoListUseCase(), historyUseCase: makeTodoHistoryUseCase())
        parentViewModel = viewModel
        
        return viewModel
    }
    
    private func makeTodoViewModel(processType: ProcessType) -> TodoViewModel {
        let viewModel = TodoViewModel(
            processType: processType,
            items: parentViewModel?.todoItems ?? Just([Todo]()).eraseToAnyPublisher()
        )
        
        viewModel.delegate = parentViewModel
        
        return viewModel
    }
    
    // MARK: - UseCase
    
    private func makeTodoListUseCase() -> TodoListUseCaseable {
        return TodoListUseCase(repository: makeTodoListRepository())
    }
    
    private func makeTodoHistoryUseCase() -> TodoHistoryUseCaseable {
        return TodoHistoryUseCase(repository: makeTodoHistoryRepository())
    }
    
    // MARK: - Repository
    
    private func makeTodoListRepository() -> TodoListRepositorible {
        return TodoListRepository(
            todoLocalStorage: dependencies.todoStorage,
            todoRemoteStorage: dependencies.remoteStorage,
            isFirstLogin: isFirstLogin
        )
    }
    
    private func makeTodoHistoryRepository() -> TodoHistoryRepositorible {
        return TodoHistoryRepository(storage: dependencies.historyStorage)
    }
    
    // MARK: - Coordiantor
    
    func makeListViewCoordinator(navigationController: UINavigationController) -> TodoListViewCoordinator {
        return TodoListViewCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    // MARK: - DIContainer
    
    func makeTodoHistoryDIContainer() -> TodoHistoryDIContainer {
        return TodoHistoryDIContainer(dependencies: .init(historyStorage: dependencies.historyStorage))
    }
    
    func makeTodoCreateDIContainer() -> TodoCreateDIContainer {
        return TodoCreateDIContainer(
            dependencies: .init(
                todoStorage: dependencies.todoStorage,
                remoteStorage: dependencies.remoteStorage,
                historyStorage: dependencies.historyStorage
            )
        )
    }
    
    func makeTodoEditDIContainer() -> TodoEditDIContainer {
        return TodoEditDIContainer(
            dependencies: .init(
                todoStorage: dependencies.todoStorage,
                remoteStorage: dependencies.remoteStorage,
                historyStorage: dependencies.historyStorage
            )
        )
    }
}