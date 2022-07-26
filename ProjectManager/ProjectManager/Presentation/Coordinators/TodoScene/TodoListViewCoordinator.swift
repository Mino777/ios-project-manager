//
//  TodoListViewCoordinator.swift
//  ProjectManager
//
//  Created by 김도연 on 2022/07/06.
//

import UIKit

final class TodoListViewCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let dependencies: TodoListDIContainer
    private weak var viewController: TodoListViewController?
    
    init(navigationController: UINavigationController, dependencies: TodoListDIContainer) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    // MARK: View Transition
    
    func start() {
        let todoListViewController = dependencies.makeTodoListViewController()
        todoListViewController.coordinator = self
        self.navigationController?.pushViewController(todoListViewController, animated: true)
    }
    
    func showCreateViewController() {
        guard let navigationController = navigationController else {
            return
        }

        let dIContainer = dependencies.makeTodoCreateDIContainer()
        let sceneCoordinator = dIContainer.makeCreateViewCoordinator(navigationController: navigationController)
        
        childCoordinators.append(sceneCoordinator)
        sceneCoordinator.parentCoordinator = self
        
        sceneCoordinator.start()
    }
    
    func showDetailViewController(_ item: Todo) {
        guard let navigationController = navigationController else {
            return
        }
        
        let diContainer = dependencies.makeTodoEditDIContainer()
        let sceneCoordinator = diContainer.makeEditViewCoordinator(navigationController: navigationController)
        
        childCoordinators.append(sceneCoordinator)
        sceneCoordinator.parentCoordinator = self
        
        sceneCoordinator.start(item)
    }
    
    func showHistoryViewController(sourceView: UIBarButtonItem) {
        guard let navigationController = navigationController else {
            return
        }
        
        let todoHistoryDIContainer = dependencies.makeTodoHistoryDIContainer()
        let sceneCoordinator = todoHistoryDIContainer.makeHistoryViewCoordinator(
            navigationController: navigationController
        )
        
        childCoordinators.append(sceneCoordinator)
        sceneCoordinator.parentCoordinator = self
        
        sceneCoordinator.start(sourceView: sourceView)
    }
}