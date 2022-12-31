//
//  UserCommandEvent.swift
//  Swiftcord
//
//  Created by Noah Pistilli on 2021-12-20.
//

import Foundation

public class UserCommandEvent: BaseCommandEvent {
    public var targetMember: Member?
    public let targetUser: User

    public override init(_ swiftcord: Swiftcord, data: [String: Any]) async throws {
        let message = data["data"] as! [String: Any]
        let targetId = message["target_id"] as! String

        let resolved = message["resolved"] as! [String: Any]
        let userDict = resolved["users"] as! [String: Any]

        self.targetUser = User(swiftcord, userDict[targetId] as! [String: Any])

        try await super.init(swiftcord, data: data)
    }
}
