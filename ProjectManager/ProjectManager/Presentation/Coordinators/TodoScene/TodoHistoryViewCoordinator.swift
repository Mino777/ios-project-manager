//
//  TodoHistoryViewCoordinator.swift
//  ProjectManager
//
//  Created by 김도연 on 2022/07/19.
//

import UIKit

final class TodoHistoryViewCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let dependencies: TodoHistoryDIContainer
    
    init(navigationController: UINavigationController, dependencies: TodoHistoryDIContainer) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(sourceView: UIBarButtonItem) {
        let todoHistoryViewController = dependencies.makeTodoHistoryTableViewController()
        todoHistoryViewController.coordinator = self
        todoHistoryViewController.modalPresentationStyle = .popover
        let popoverViewController = todoHistoryViewController.popoverPresentationController

        popoverViewController?.barButtonItem = sourceView
        
        navigationController?.present(todoHistoryViewController, animated: true)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true)
        parentCoordinator?.removeChild(self)
    }
}