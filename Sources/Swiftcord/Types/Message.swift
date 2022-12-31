//
//  Message.swift
//  Swiftcord
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

import Foundation
import DictionaryCoder

@propertyWrapper public struct Indirect<T> {
    class Box<T> {
        var wrappedValue: T
        init(wrappedValue: T) {
            self.wrappedValue = wrappedValue
        }
    }
    
    let box: Box<T>
    public var wrappedValue: T {
        get { box.wrappedValue }
        set { box.wrappedValue = newValue }
    }
    
    public init(wrappedValue: T) {
        self.box = Box(wrappedValue: wrappedValue)
    }
}

public protocol _Optional { static var none: Self { get } }
extension Optional: _Optional {}

extension Indirect where T: _Optional {
    public init() {
        self.init(wrappedValue: .none)
    }
}

/// Message Type
public struct Message {

    // MARK: Properties

    /// Array of Attachment structs that was sent with the message
    public internal(set) var attachments = [Attachment]()

    /// User struct of the author (not returned if webhook)
    public let author: User?

    /// Content of the message
    public let content: String

    /// Channel struct of the message
    public let channel: TextChannel

    /// If message was edited, this is the time it happened
    public let editedTimestamp: Date?

    /// Array of embeds sent with message
    public var embeds = [Embed]()

    /// Message type flags
    public var flags: Int?

    /// Main Swiftcord class
    public let swiftcord: Swiftcord

    /// If sent in a guild, the guild
    public var guild: Guild? {
        return self.swiftcord.getGuild(for: self.channel.id)
    }

    /// Message ID
    public let id: Snowflake

    /// Whether or not this message mentioned everyone
    public let isEveryoneMentioned: Bool

    /// Whether or not this message is pinned in it's channel
    public let isPinned: Bool

    /// Whether or not this messaged was ttsed
    public let isTts: Bool

    /// Member struct for message
    public internal(set) var member: Member?

    /// Array of Users that were mentioned
    public internal(set) var mentions = [User]()

    /// Array of Roles that were mentioned
    public internal(set) var mentionedRoles = [Snowflake]()

    /// Used to validate a message was sent
    public let nonce: Snowflake?

    /// Array of reactions with message
    public internal(set) var reactions = [[String: Any]]()

    /// Message associated with MessageReference
    // TODO: Convert to Message object ["channel_id": 0, "message_id": 0, "guild_id": 0]
    public var refrencedMessage: String?

    /// Time when message was sent
    public let timestamp: Date

    /// Determines what type of message was sent
    public let type: Type

    /// If message was sent by webhook, this is that webhook's ID
    public let webhookId: Snowflake?
    
    @Indirect public var interaction: Interaction?

    // MARK: Initializer

    /**
     Creates Message struct

     - parameter swiftcord: Parent class to get guilds from
     - parameter json: JSON representable as a dictionary
     */
    init(_ swiftcord: Swiftcord, _ json: [String: Any]) async throws {
        let dictionaryDecoder = DictionaryDecoder()
        
        self.swiftcord = swiftcord
        let attachments = json["attachments"] as! [[String: Any]]
        for attachment in attachments {
            self.attachments.append(try dictionaryDecoder.decode(from: attachment))
        }

        if json["webhook_id"] == nil {
            self.author = User(swiftcord, json["author"] as! [String: Any])
        } else {
            self.author = nil
        }

        self.content = json["content"] as! String

        self.channel = try await swiftcord.getChannel(Snowflake(json["channel_id"])!, rest: true)! as! TextChannel

        if let editedTimestamp = json["edited_timestamp"] as? String {
            self.editedTimestamp = editedTimestamp.date
        } else {
            self.editedTimestamp = nil
        }

        let embeds = json["embeds"] as! [[String: Any]]
        for embed in embeds {
            self.embeds.append(try dictionaryDecoder.decode(from: embed))
        }

        self.id = Snowflake(json["id"])!

        if json["webhook_id"] == nil {
            for (_, guild) in swiftcord.guilds {
                if guild.channels[self.channel.id] != nil {
                    self.member = guild.members[self.author!.id]
                    break
                }
            }
        } else {
            self.member = nil
        }

        self.isEveryoneMentioned = json["mention_everyone"] as! Bool

        let mentions = json["mentions"] as! [[String: Any]]
        for mention in mentions {
            self.mentions.append(User(swiftcord, mention))
        }

        self.mentionedRoles = (
            json["mention_roles"] as! [String]
        ).map { Snowflake($0)! }

        self.nonce = Snowflake(json["nonce"])

        if let reactions = json["reactions"] as? [[String: Any]] {
            self.reactions = reactions
        }

        self.isPinned = json["pinned"] as! Bool
        self.timestamp = (json["timestamp"] as! String).date
        self.isTts = json["tts"] as! Bool

        if let type = json["type"] as? Int {
            self.type = Type(rawValue: type)!
        } else {
            self.type = Type(rawValue: 0)!
        }

        self.webhookId = Snowflake(json["webhook_id"])
        
        self.interaction = try await json.decode(swiftcord, "interaction")
    }

    // MARK: Functions

    /**
     Adds a reaction to self

     - parameter reaction: Either unicode or custom emoji to add to this message
     */
    public func addReaction(
        _ reaction: String
    ) async throws {
        try await self.channel.addReaction(reaction, to: self.id)
    }

    /// Deletes self
    public func delete() async throws {
        try await self.channel.deleteMessage(self.id)
    }

    /**
     Deletes reaction from self

     - parameter reaction: Either unicode or custom emoji reaction to remove
     - parameter userId: If nil, delete from self else delete from userId
     */
    public func deleteReaction(
        _ reaction: String,
        from userId: Snowflake? = nil
    ) async throws {
        try await self.channel.deleteReaction(reaction, from: self.id, by: userId ?? nil)
    }

    /// Deletes all reactions from self
    public func deleteReactions() async throws {
        guard let channel = self.channel as? GuildText else { return }

        try await channel.deleteReactions(from: self.id)
    }

    /**
     Edit self's content

     - parameter content: Content to edit from self
     */
    public func edit(
        with options: [String: Any]
    ) async throws -> Message? {
        try await self.channel.editMessage(self.id, with: options)
    }

    /**
     Get array of users from reaction

     - parameter reaction: Either unicode or custom emoji reaction to get users from
     */
    public func getReaction(
        _ reaction: String
    ) async throws -> [User]? {
        return try await self.channel.getReaction(reaction, from: self.id)
    }

    /// Pins self
    public func pin() async throws {
        return try await self.channel.pin(self.id)
    }

    /**
     Replies to a channel

     - parameter message: String to send to channel
     */
    public func reply(
        with message: String
    ) async throws -> Message? {
        return try await self.swiftcord.send(message, to: self.channel.id)
    }

    /**
     Replies to a channel with an Embed

     - parameter message: Embed to send to channel
     */
    public func reply(
        with message: EmbedBuilder
    ) async throws -> Message? {
        return try await self.channel.send(message)
    }

    /**
     Replies to a channel with a MessageBuilder instance

     - parameter message: Buttons to send to channel
     */
    public func reply(
        with message: ButtonBuilder
    ) async throws -> Message? {
        try await self.channel.send(message)
    }

    /**
     Replies to a channel with a SelectMenuBuilder instance

     - parameter message: Select Menu to send to channel
     */
    public func reply(
        with message: SelectMenuBuilder
    ) async throws -> Message? {
        return try await self.channel.send(message)
    }

}

extension Message {

    /// Depicts what kind of message was sent in chat
    public enum `Type`: Int {

        /// Regular sent message
        case `default`

        /// Someone was added to group message
        case recipientAdd

        /// Someone was removed from group message
        case recipientRemove

        /// Someone called the group message
        case call

        /// Somone changed the group's name message
        case channelNameChange

        /// Someone changed the group's icon message
        case channelIconChange

        /// Somone pinned a message in this channel message
        case channelPinnedMessage

        /// Someone just joined the guild message
        case guildMemberJoin

        /// A member boosted the server
        case memberBoost

        /// A member boosted the server to level 1
        case memberBoostLvl1

        /// A member boosted the server to level 2
        case memberBoostLvl2

        /// A member boosted the server to level 3
        case memberBoostLvl3

        /// A member subscribed to a announcement channel
        case channelFollowAdd

        /// ???
        case guildDiscoveryDisqualified = 14

        /// ???
        case guildDiscoveryRequalified

        /// ???
        case guildDiscoveryGracePeriodInitialWarning

        /// ???
        case guildDiscoveryGracePeriodFinalWarning

        /// A thread was created
        case threadCreated

        /// A message that replied to another message
        case reply

        /// ???
        case chatInputCommand

        /// Message that started the thread
        case threadStarterMessage

        /// ???
        case guildInviteReminder

        /// A member used an either a User or Message command
        case contextMenuCommand
    }

}

/// `AttachmentBuilder` aids in creating a form body for uploading attachments
public struct AttachmentBuilder: Encodable {
        
    var id: Int
    
    let filename: String
    
    private let description: String?
    
    let data: Data
    
    public init(
        filename: String,
        description: String? = nil,
        data: Data
    ) {
        // Need to adjust later
        self.id = 0
        self.filename = filename
        self.description = description
        self.data = data
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, filename, description
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.filename, forKey: .filename)
        try container.encode(self.description, forKey: .description)
    }
}

/// Attachment Type
public struct Attachment: Codable, Hashable {

    // MARK: Properties

    /// The filename for this Attachment
    public let filename: String

    /// Height of image (if image)
    public let height: Int?

    /// ID of attachment
    public let id: Snowflake

    /// The proxied URL for this attachment
    public let proxyUrl: String

    /// Size of the file in bytes
    public let size: Int

    /// The original URL of the attachment
    public let url: String

    /// Width of image (if image)
    public let width: Int?
    
    /// Mime type of the attachment
    public let contentType: String?
    
    public init(filename: String, height: Int?, id: Snowflake, proxyUrl: String, size: Int, url: String, width: Int?, contentType: String?) {
        self.filename = filename
        self.height = height
        self.id = id
        self.proxyUrl = proxyUrl
        self.size = size
        self.url = url
        self.width = width
        self.contentType = contentType
    }

    enum CodingKeys: String, CodingKey {
        case filename, height, id
        case proxyUrl = "proxy_url"
        case size, url, width
        case contentType = "content_type"
    }
}

public typealias Embed = EmbedBuilder
