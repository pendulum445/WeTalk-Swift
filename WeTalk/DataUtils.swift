//
//  DataUtils.swift
//  WeTalk
//
//  Created by liaoyunjie on 2024/6/6.
//

import Foundation

func fetchData<T: Decodable>(from urlString: String) async throws -> T {
    let (data, _) = try await URLSession.shared.data(from: URL(string: urlString)!)
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
}

struct ChatMessage: Decodable {
    let chatTime: String
    let text: String
    let type: Int
}

enum Gender: String, Decodable {
    case female = "女"
    case male = "男"

    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "女", "female":
            self = .female
        case "男", "male":
            self = .male
        default:
            throw DecodingError.valueNotFound(Gender.self, .init(codingPath: decoder.codingPath, debugDescription: "Invalid gender value"))
        }
    }
}

struct UserMoreInfo: Decodable {
    let area: String?
    let gender: Gender
    let signature: String?
}

final class UserInfo: ObservableObject, Decodable {
    @Published var avatarUrl: String?
    @Published var nickName: String
    @Published var userId: String
    @Published var moreInfo: UserMoreInfo

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try container.decodeIfPresent(String.self, forKey: .avatarUrl)
        nickName = try container.decode(String.self, forKey: .nickName)
        userId = try container.decode(String.self, forKey: .userId)
        moreInfo = try container.decode(UserMoreInfo.self, forKey: .moreInfo)
    }
    
    private enum CodingKeys: String, CodingKey {
        case avatarUrl
        case nickName
        case userId
        case moreInfo
    }
}

struct FriendInfo: Decodable {
    let userInfo: UserInfo
    let noteName: String?
    let messages: [ChatMessage]
    
    func displayName() -> String {
        return self.noteName ?? self.userInfo.nickName;
    }
}

class ChatCellModel: ObservableObject, Identifiable, Decodable {
    let id: Int
    let friendInfo: FriendInfo
    @Published var unreadCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case friendInfo
        case unreadCount
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.friendInfo = try container.decode(FriendInfo.self, forKey: .friendInfo)
        self.unreadCount = try container.decode(Int.self, forKey: .unreadCount)
    }
}
