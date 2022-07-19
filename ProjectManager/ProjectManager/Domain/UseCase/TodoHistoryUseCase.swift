//
//  TodoHistoryUseCase.swift
//  ProjectManager
//
//  Created by 김도연 on 2022/07/19.
//

import Foundation
import Combine

protocol TodoHistoryUseCaseable {
    func create(_ item: TodoHistory) -> AnyPublisher<Void, StorageError>
    func read() -> CurrentValueSubject<[TodoHistory], Never>
    func update(_ item: TodoHistory) -> AnyPublisher<Void, StorageError>
    func delete(item: TodoHistory) -> AnyPublisher<Void, StorageError>
}

final class TodoHistoryUseCase: TodoHistoryUseCaseable {
    private let repository: TodoHistoryRepositorible
    
    init(repository: TodoHistoryRepositorible) {
        self.repository = repository
    }
    
    func create(_ item: TodoHistory) -> AnyPublisher<Void, StorageError> {
        return repository.create(item)
    }
    
    func read() -> CurrentValueSubject<[TodoHistory], Never> {
        return repository.read()
    }
    
    func update(_ item: TodoHistory) -> AnyPublisher<Void, StorageError> {
        return repository.update(item)
    }
    
    func delete(item: TodoHistory) -> AnyPublisher<Void, StorageError> {
        return repository.delete(item: item)
    }
}