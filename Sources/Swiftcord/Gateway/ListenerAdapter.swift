//
//  ListenerAdapter.swift
//
//
//  Created by Noah Pistilli on 2022-01-29.
//

import Foundation

open class ListenerAdapter {
    // Channel Create Events
    open func onChannelCreate(event: TextChannel) async throws {}
    open func onCategoryCreate(event: GuildCategory) async throws {}
    open func onVoiceChannelCreate(event: GuildVoice) async throws {}

    // Channel Delete Events
    open func onChannelDelete(event: TextChannel) async throws {}
    open func onCategoryDelete(event: GuildCategory) async throws {}
    open func onVoiceChannelDelete(event: GuildVoice) async throws {}

    // Channel Update Events
    open func onChannelUpdate(event: TextChannel) async throws {}
    open func onCategoryUpdate(event: GuildCategory) async throws {}
    open func onVoiceChannelUpdate(event: GuildVoice) async throws {}
    open func onChannelPinUpdate(event: Channel, lastPin: Date? = nil) async throws {}

    // InteractionEvents
    open func onButtonClickEvent(event: ButtonEvent) async throws {}
    open func onMessageCommandEvent(event: MessageCommandEvent) async throws {}
    open func onSlashCommandEvent(event: SlashCommandEvent) async throws {}
    open func onSelectMenuEvent(event: SelectMenuEvent) async throws {}
    open func onTextInputEvent(event: TextInputEvent) async throws {}
    open func onUserCommandEvent(event: UserCommandEvent) async throws {}

    // Guild Events
    open func onGuildBan(guild: Guild, user: User) async throws {}
    open func onGuildUnban(guild: Guild, user: User) async throws {}
    open func onGuildCreate(guild: Guild) async throws {}
    open func onGuildDelete(guild: Guild) async throws {}
    open func onGuildMemberJoin(guild: Guild, member: Member) async throws {}
    open func onGuildMemberLeave(guild: Guild, user: User) async throws {}
    open func onGuildReady(guild: Guild) async throws {}
    open func onGuildRoleCreate(guild: Guild, role: Role) async throws {}
    open func onGuildRoleDelete(guild: Guild, role: Role) async throws {}
    open func onGuildAvailable(guild: Guild) async throws {}
    open func onUnavailableGuildDelete(guild: UnavailableGuild) async throws {}

    // Guild Update Events
    open func onGuildEmojisUpdate(guild: Guild, emojis: [Emoji]) async throws {}
    open func onGuildIntegrationUpdate(guild: Guild) async throws {}
    open func onGuildMemberUpdate(guild: Guild, member: Member) async throws {}
    open func onGuildRoleUpdate(guild: Guild, role: Role) async throws {}
    open func onGuildUpdate(guild: Guild) async throws {}

    // Message Events
    open func onMessageCreate(event: Message) async throws {}
    open func onMessageDelete(messageId: Snowflake, channel: Channel) async throws {}
    open func onMessageBulkDelete(messageIds: [Snowflake], channel: Channel) async throws {}
    open func onMessageReactionAdd(channel: Channel, messageId: Snowflake, userId: Snowflake, emoji: Emoji) async throws {}
    open func onMessageReactionRemove(channel: Channel, messageId: Snowflake, userId: Snowflake, emoji: Emoji) async throws {}
    open func onMessageReactionRemoveAll(messageId: Snowflake, channel: Channel) async throws {}

    // Thread Events
    open func onThreadCreate(event: ThreadChannel) async throws {}
    open func onThreadDelete(event: ThreadChannel) async throws {}
    open func onThreadUpdate(event: ThreadChannel) async throws {}

    // Voice Events
    open func onVoiceChannelJoin(userId: Snowflake, state: VoiceState) async throws {}
    open func onVoiceChannelLeave(userId: Snowflake) async throws {}

    // Generic Events
    open func onPresenceUpdate(member: Member?, presence: Presence) async throws {}
    open func onShardReady(id: Int) async throws {}
    open func onReady(botUser: User) async throws {}
    open func onTypingStart(channel: Channel, userId: Snowflake, time: Date) async throws {}
    open func onUserUpdate(event: User) async throws {}

    public init() {}
}
