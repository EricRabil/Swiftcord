//
//  ListenerAdapter.swift
//
//
//  Created by Noah Pistilli on 2022-01-29.
//

import Foundation

public protocol ListenerAdapter {
    // Channel Create Events
    func onChannelCreate(event: TextChannel) async throws
    func onCategoryCreate(event: GuildCategory) async throws
    func onVoiceChannelCreate(event: GuildVoice) async throws

    // Channel Delete Events
    func onChannelDelete(event: TextChannel) async throws
    func onCategoryDelete(event: GuildCategory) async throws
    func onVoiceChannelDelete(event: GuildVoice) async throws

    // Channel Update Events
    func onChannelUpdate(event: TextChannel) async throws
    func onCategoryUpdate(event: GuildCategory) async throws
    func onVoiceChannelUpdate(event: GuildVoice) async throws
    func onChannelPinUpdate(event: Channel, lastPin: Date?) async throws

    // InteractionEvents
    func onButtonClickEvent(event: ButtonEvent) async throws
    func onMessageCommandEvent(event: MessageCommandEvent) async throws
    func onSlashCommandEvent(event: SlashCommandEvent) async throws
    func onSelectMenuEvent(event: SelectMenuEvent) async throws
    func onTextInputEvent(event: TextInputEvent) async throws
    func onUserCommandEvent(event: UserCommandEvent) async throws

    // Guild Events
    func onGuildBan(guild: Guild, user: User) async throws
    func onGuildUnban(guild: Guild, user: User) async throws
    func onGuildCreate(guild: Guild) async throws
    func onGuildDelete(guild: Guild) async throws
    func onGuildMemberJoin(guild: Guild, member: Member) async throws
    func onGuildMemberLeave(guild: Guild, user: User) async throws
    func onGuildReady(guild: Guild) async throws
    func onGuildRoleCreate(guild: Guild, role: Role) async throws
    func onGuildRoleDelete(guild: Guild, role: Role) async throws
    func onGuildAvailable(guild: Guild) async throws
    func onUnavailableGuildDelete(guild: UnavailableGuild) async throws

    // Guild Update Events
    func onGuildEmojisUpdate(guild: Guild, emojis: [Emoji]) async throws
    func onGuildIntegrationUpdate(guild: Guild) async throws
    func onGuildMemberUpdate(guild: Guild, member: Member) async throws
    func onGuildRoleUpdate(guild: Guild, role: Role) async throws
    func onGuildUpdate(guild: Guild) async throws

    // Message Events
    func onMessageCreate(event: Message) async throws
    func onMessageDelete(messageId: Snowflake, channel: Channel) async throws
    func onMessageBulkDelete(messageIds: [Snowflake], channel: Channel) async throws
    func onMessageReactionAdd(channel: Channel, messageId: Snowflake, userId: Snowflake, emoji: Emoji) async throws
    func onMessageReactionRemove(channel: Channel, messageId: Snowflake, userId: Snowflake, emoji: Emoji) async throws
    func onMessageReactionRemoveAll(messageId: Snowflake, channel: Channel) async throws

    // Thread Events
    func onThreadCreate(event: ThreadChannel) async throws
    func onThreadDelete(event: ThreadChannel) async throws
    func onThreadUpdate(event: ThreadChannel) async throws

    // Voice Events
    func onVoiceChannelJoin(userId: Snowflake, state: VoiceState) async throws
    func onVoiceChannelLeave(userId: Snowflake) async throws

    // Generic Events
    func onPresenceUpdate(member: Member?, presence: Presence) async throws
    func onShardReady(id: Int) async throws
    func onReady(botUser: User) async throws
    func onTypingStart(channel: Channel, userId: Snowflake, time: Date) async throws
    func onUserUpdate(event: User) async throws
}

public extension ListenerAdapter {
    // Channel Create Events
    func onChannelCreate(event: TextChannel) async throws {}
    func onCategoryCreate(event: GuildCategory) async throws {}
    func onVoiceChannelCreate(event: GuildVoice) async throws {}

    // Channel Delete Events
    func onChannelDelete(event: TextChannel) async throws {}
    func onCategoryDelete(event: GuildCategory) async throws {}
    func onVoiceChannelDelete(event: GuildVoice) async throws {}

    // Channel Update Events
    func onChannelUpdate(event: TextChannel) async throws {}
    func onCategoryUpdate(event: GuildCategory) async throws {}
    func onVoiceChannelUpdate(event: GuildVoice) async throws {}
    func onChannelPinUpdate(event: Channel, lastPin: Date? = nil) async throws {}

    // InteractionEvents
    func onButtonClickEvent(event: ButtonEvent) async throws {}
    func onMessageCommandEvent(event: MessageCommandEvent) async throws {}
    func onSlashCommandEvent(event: SlashCommandEvent) async throws {}
    func onSelectMenuEvent(event: SelectMenuEvent) async throws {}
    func onTextInputEvent(event: TextInputEvent) async throws {}
    func onUserCommandEvent(event: UserCommandEvent) async throws {}

    // Guild Events
    func onGuildBan(guild: Guild, user: User) async throws {}
    func onGuildUnban(guild: Guild, user: User) async throws {}
    func onGuildCreate(guild: Guild) async throws {}
    func onGuildDelete(guild: Guild) async throws {}
    func onGuildMemberJoin(guild: Guild, member: Member) async throws {}
    func onGuildMemberLeave(guild: Guild, user: User) async throws {}
    func onGuildReady(guild: Guild) async throws {}
    func onGuildRoleCreate(guild: Guild, role: Role) async throws {}
    func onGuildRoleDelete(guild: Guild, role: Role) async throws {}
    func onGuildAvailable(guild: Guild) async throws {}
    func onUnavailableGuildDelete(guild: UnavailableGuild) async throws {}

    // Guild Update Events
    func onGuildEmojisUpdate(guild: Guild, emojis: [Emoji]) async throws {}
    func onGuildIntegrationUpdate(guild: Guild) async throws {}
    func onGuildMemberUpdate(guild: Guild, member: Member) async throws {}
    func onGuildRoleUpdate(guild: Guild, role: Role) async throws {}
    func onGuildUpdate(guild: Guild) async throws {}

    // Message Events
    func onMessageCreate(event: Message) async throws {}
    func onMessageDelete(messageId: Snowflake, channel: Channel) async throws {}
    func onMessageBulkDelete(messageIds: [Snowflake], channel: Channel) async throws {}
    func onMessageReactionAdd(channel: Channel, messageId: Snowflake, userId: Snowflake, emoji: Emoji) async throws {}
    func onMessageReactionRemove(channel: Channel, messageId: Snowflake, userId: Snowflake, emoji: Emoji) async throws {}
    func onMessageReactionRemoveAll(messageId: Snowflake, channel: Channel) async throws {}

    // Thread Events
    func onThreadCreate(event: ThreadChannel) async throws {}
    func onThreadDelete(event: ThreadChannel) async throws {}
    func onThreadUpdate(event: ThreadChannel) async throws {}

    // Voice Events
    func onVoiceChannelJoin(userId: Snowflake, state: VoiceState) async throws {}
    func onVoiceChannelLeave(userId: Snowflake) async throws {}

    // Generic Events
    func onPresenceUpdate(member: Member?, presence: Presence) async throws {}
    func onShardReady(id: Int) async throws {}
    func onReady(botUser: User) async throws {}
    func onTypingStart(channel: Channel, userId: Snowflake, time: Date) async throws {}
    func onUserUpdate(event: User) async throws {}
}
