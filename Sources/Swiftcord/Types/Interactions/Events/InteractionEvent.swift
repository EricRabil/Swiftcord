//
//  InteractionEvent.swift
//  Swiftcord
//
//  Created by Noah Pistilli on 2021-12-18.
//

import Foundation

public protocol InteractionEvent: AnyObject {
    var interactionId: Snowflake { get }
    var swiftcord: Swiftcord { get }
    var token: String { get }
    var ephemeral: Int { get set }
    var isDefered: Bool { get set }
}

public extension InteractionEvent {
    func delete() async throws {
        _ = try await self.swiftcord.requestWithBodyAsData(.deleteWebhook(self.swiftcord.user!.id, self.token))
    }

    /// Shows the `Bot is thinking...` text
    func deferReply(silently: Bool = false) async throws {
        self.isDefered = true

        let body = InteractionResponse(type: silently ? .deferSilently : .defer, data: InteractionBody(flags: self.ephemeral))

        let jsonData = try self.swiftcord.encoder.encode(body)

        _ = try await self.swiftcord.requestWithBodyAsData(.replyToInteraction(self.interactionId, self.token), body: jsonData)
    }
    
    func editWithInteraction(
        interaction: InteractionBodyBuilder
    ) async throws -> Message {
        let body = interaction.finish()
        
        let jsonData = try self.swiftcord.encoder.encode(body)

        let data = try await self.swiftcord.requestWithBodyAsData(.editWebhook(self.swiftcord.user!.id, self.token), body: jsonData)
        return try await Message(self.swiftcord, data as! [String: Any])
    }

    func edit(
        message: String
    ) async throws -> Message {
        try await editWithInteraction(interaction: InteractionBodyBuilder().setContent(message))
    }
    
    func editWithButtons(
        buttons: ButtonBuilder
    ) async throws -> Message {
        try await editWithInteraction(interaction: InteractionBodyBuilder().addComponents(buttons.components).addEmbeds(buttons.embeds ?? []).setContent(buttons.content ?? ""))
    }

    func editWithEmbeds(
        embeds: EmbedBuilder...
    ) async throws -> Message {
        try await editWithInteraction(interaction: InteractionBodyBuilder().addEmbeds(embeds))
    }

    func editWithSelectMenu(
        menu: SelectMenuBuilder
    ) async throws -> Message {
        try await editWithInteraction(interaction: InteractionBodyBuilder().addComponents(menu.components).setContent(menu.content))
    }
    
    func replyWithInteraction(interaction: InteractionBodyBuilder) async throws {
        var jsonData: Data, endpoint: Endpoint
        var body = interaction.finish()
        // Check if the bot defered the message. Replying to a defered message has an entirely different endpoint
        if !isDefered {
            body.flags = self.ephemeral
            let response = InteractionResponse(type: .sendMessage, data: body)
            jsonData = try self.swiftcord.encoder.encode(response)
            endpoint = .replyToInteraction(self.interactionId, self.token)
        } else {
            jsonData = try self.swiftcord.encoder.encode(body)
            endpoint = .replyToDeferedInteraction(self.swiftcord.user!.id, self.token)
        }
        _ = try await self.swiftcord.requestWithBodyAsData(endpoint, body: jsonData)
    }

    /**
     Replies to a slash command interaction

     - parameter message: Message to send to the channel
     */
    func reply(
        message: String
    ) async throws {
        try await replyWithInteraction(interaction: InteractionBodyBuilder().setContent(message))
    }
    
    /**
     Replies to a slash command interaction

     - parameter message: Message to send to the channel
     - parameter attachments: Attachment(s) to send to the channel
     */
    func reply(
        message: String,
        attachments: AttachmentBuilder...
    ) async throws {
        try await replyWithInteraction(interaction: InteractionBodyBuilder().setContent(message).addAttachments(attachments))
    }

    /**
     Replies to a slash command interaction with buttons

     - parameter buttons: Buttons to send to the channel
     */
    func replyButtons(
        buttons: ButtonBuilder
    ) async throws {
        try await replyWithInteraction(interaction: InteractionBodyBuilder().addComponents(buttons.components).addEmbeds(buttons.embeds ?? []).setContent(buttons.content ?? ""))
    }

    /**
     Replies to a slash command interaction with embeds

     - parameter buttons: Buttons to send to the channel
     */
    func replyEmbeds(
        embeds: EmbedBuilder...
    ) async throws {
        try await replyWithInteraction(interaction: InteractionBodyBuilder().addEmbeds(embeds))
    }

    func replyModal(
        modal: ModalBuilder
    ) async throws {
        try await replyWithInteraction(interaction: InteractionBodyBuilder().addComponent(ActionRow(components: modal.textInput)).addCustomId(modal.modal.customId).addTitle(modal.modal.title))
    }

    /**
     Replies to a slash command interaction with a select menu

     - parameter message: Message to send to the channel
     */
    func replySelectMenu(
        menu: SelectMenuBuilder
    ) async throws {
        try await replyWithInteraction(interaction: InteractionBodyBuilder().setContent(menu.content).addComponents(menu.components))
    }

    /// Sets a flag to tell Discord to make the response hidden
    func setEphemeral(_ isEphermeral: Bool) {
        if isEphermeral {
            self.ephemeral = 64
        } else {
            self.ephemeral = 0
        }
    }
}
