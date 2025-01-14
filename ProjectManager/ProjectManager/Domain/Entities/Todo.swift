//
//  Model.swift
//  ProjectManager
//
//  Created by 조민호 on 2022/07/06.
//

import Foundation

import RealmSwift

enum ProcessType: String, PersistableEnum {
    case todo = "TODO"
    case doing = "DOING"
    case done = "DONE"
}

struct Todo: Hashable {
    let id: String
    let title: String
    let content: String
    let deadline: Date
    var processType: ProcessType
    
    static func empty() -> Todo {
        return Todo(title: "", content: "", deadline: Date())
    }
    
    init(
        title: String,
        content: String,
        deadline: Date,
        processType: ProcessType = .todo,
        id: String = UUID().uuidString
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.deadline = deadline
        self.processType = processType
    }
    
    func toDictionary() -> NSDictionary {
        return [
            "id": self.id,
            "title": self.title,
            "content": self.content,
            "deadline": self.deadline.timeIntervalSinceReferenceDate,
            "processType": self.processType.rawValue
        ]
    }
}

#if DEBUG
extension Todo {
    static func dummyData() -> [Todo] {
        [
            Todo(title: "책상정리", content: "집중이 안될땐 역시나 책상정리", deadline: Date().addingTimeInterval(-123123123), processType: .todo),
            Todo(title: "라자냐 재료사러 가기", content: "프로젝트 회고를 작성하면 내가 이번 프로젝트에서\n무엇을 놓쳤는지 명확히 알 수 있어요", deadline: Date(), processType: .done),
            Todo(title: "일기쓰기", content: "난.. ㄱ ㅏ끔...읽ㄱㅣ를 쓴ㄷㅏ...", deadline: Date(), processType: .todo),
            Todo(title: "설거지하기", content: "밥을 먹었으면 응당 해야할 일", deadline: Date(), processType: .doing),
            Todo(title: "빨래하기", content: "그만 쌓아두고...\n근데...\n여전히 하기 싫다", deadline: Date(), processType: .doing),
            Todo(title: "TIL 작성하기", content: "TIL을 작성하면\n오늘의 상큼한 마무리도 되고\n나중에 포트폴리오 용으로도 좋죠!", deadline: Date(), processType: .doing),
            Todo(title: "프로젝트 회고 작성", content: "프로젝트 회고를 작성하면 내가 이번 프로젝트에서\n무엇을 놓쳤는지 명확히 알 수 있어요", deadline: Date(), processType: .done),
            Todo(title: "마이노는 맨날 리액션만 하고 있어요. 혼내주세요 진짜로 마이노는 맨날 리액션만 하고 있어요. 혼내주세요 진짜로", content: "굿!", deadline: Date(), processType: .doing)
        ]
    }
}
#endif
