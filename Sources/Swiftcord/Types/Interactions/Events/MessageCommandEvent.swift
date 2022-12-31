//
//  MessageCommandEvent.swift
//  Swiftcord
//
//  Created by Noah Pistilli on 2021-12-20.
//

import Foundation

public class BaseCommandEvent: InteractionEvent {
    let data: [String: Any]
    
    public let interactionId: Snowflake
    public let swiftcord: Swiftcord
    public let token: String
    public var ephemeral: Int
    public var isDefered: Bool
    
    public let name: String
    
    public var channelId: Snowflake
    public var user: User
    public var member: Member?
    public var guildId: Snowflake?

    
    /// Guild object for this channel
    public var guild: Guild {
        return self.swiftcord.getGuild(for: channelId)!
    }
    
    init(_ swiftcord: Swiftcord, data: [String: Any]) async throws {
        self.data = data
        self.swiftcord = swiftcord
        self.token = data["token"] as! String

        self.channelId = Snowflake(data["channel_id"])!

        self.guildId = Snowflake(data["guild_id"])

        if let userJson = data["member"] as? [String: Any] {
            self.member = Member(swiftcord, try await swiftcord.getGuild(guildId!, rest: true), userJson)
            self.user = User(swiftcord, userJson["user"] as! [String: Any])
        } else {
            self.user = User(swiftcord, data["user"] as! [String: Any])
        }

        self.interactionId = Snowflake(data["id"] as! String)!
        let name = data["data"] as! [String: Any]

        self.name = name["name"] as! String

        self.ephemeral = 0
        self.isDefered = false
    }
}

public class MessageCommandEvent: BaseCommandEvent {
    public let message: Message

    public override init(_ swiftcord: Swiftcord, data: [String: Any]) async throws {
        var message = data["data"] as! [String: Any]

        let targetId = message["target_id"] as! String

        message = message["resolved"] as! [String: Any]
        message =  message["messages"] as! [String: Any]
        message = message[targetId] as! [String: Any]

        self.message = try await Message(swiftcord, message)
        
        try await super.init(swiftcord, data: data)
    }
}
