//
//  TodoCellViewModel.swift
//  ProjectManager
//
//  Created by 김도연 on 2022/07/13.
//

import Foundation
import Combine

protocol TodoCellViewModelInput {
    func cellDidBind()
}

protocol TodoCellViewModelOutput {
    var todoTitle: Just<String> { get }
    var todoContent: Just<String> { get }
    var todoDeadline: Just<String> { get }
    
    var expired: PassthroughSubject<Void, Never> { get }
    var notExpired: PassthroughSubject<Void, Never> { get }
}

protocol TodoCellViewModelable: TodoCellViewModelInput, TodoCellViewModelOutput {}

final class TodoCellViewModel: TodoCellViewModelable {
    
    // MARK: - Output
    
    var todoTitle: Just<String> {
        return Just(model.title)
    }
    
    var todoContent: Just<String> {
        return Just(model.content)
    }
    
    var todoDeadline: Just<String> {
        return Just(dateformatter.string(from: model.deadline))
    }
    
    let expired = PassthroughSubject<Void, Never>()
    let notExpired = PassthroughSubject<Void, Never>()
    
    private let model: Todo
    private let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy. M. d."
        return formatter
    }()
    
    init(_ model: Todo) {
        self.model = model
    }
    
    private func setDateLabelColor() {
        if Date() > endOfTheDay(for: model.deadline) ?? Date() {
            expired.send(())
        } else {
            notExpired.send(())
        }
    }
    
    private func endOfTheDay(for date: Date) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        
        components.hour = 23
        components.minute = 59
        
        return calendar.date(from: components)
    }
}

extension TodoCellViewModel {
    
    // MARK: - Input
    
    func cellDidBind() {
        setDateLabelColor()
    }
}
