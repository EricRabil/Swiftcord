//
//  File.swift
//  
//
//  Created by Eric Rabil on 12/27/22.
//

import Foundation

protocol _Model {
    init(_ swiftcord: Swiftcord, _ json: [String: Any]) async throws
}

extension Dictionary {
    func decode<P: _Model>(_ swiftcord: Swiftcord, _ key: Key) async throws -> P? {
        if let value = self[key] as? [String: Any] {
            return try await P.init(swiftcord, value)
        }
        return nil
    }
}

func a() {
    
}

public struct Interaction: _Model {
    public let id: Snowflake
    public let applicationId: Snowflake?
    public let guildId: Snowflake?
    public let channelId: Snowflake?
    public let token: String?
    public let version: Int?
    public let message: Message?
    public let locale: String?
    public let guildLocale: String?
    
    public init(_ swiftcord: Swiftcord, _ json: [String: Any]) async throws {
        id = Snowflake(json["id"])!
        applicationId = Snowflake(json["application_id"])
        guildId = json["guild_id"].flatMap(Snowflake.init(_:))
        channelId = json["channel_id"].flatMap(Snowflake.init(_:))
        token = json["token"] as? String
        version = json["version"] as? Int
        if let rawMessage = json["message"] as? [String: Any] {
            message = try await Message(swiftcord, rawMessage)
        } else {
            message = nil
        }
        locale = json["locale"] as? String
        guildLocale = json["guild_locale"] as? String
    }
}
