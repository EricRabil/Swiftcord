//
//  InteractionResponse.swift
//  Swiftcord
//
//  Created by Noah Pistilli on 2021-12-18.
//

import Foundation

struct InteractionResponse: Encodable {
    let type: InteractionCallbackType
    let data: InteractionBody?
}

struct InteractionBody: Encodable {
    var content: String
    var embeds: [EmbedBuilder]
    var flags: Int?
    var components: [ActionRow]
    var attachments: [AttachmentBuilder]

    var customId: String?
    var title: String?

    init(content: String = "", flags: Int? = nil, embeds: [EmbedBuilder] = [], components: [ActionRow] = [], attachments: [AttachmentBuilder] = []) {
        self.content = content
        self.flags = flags
        self.components = components
        self.embeds = embeds
        self.attachments = attachments
        
        // Fix the attachment builder
        for (i, _) in self.attachments.enumerated() {
            self.attachments[i].id = i
        }
    }
}

public class InteractionBodyBuilder {
    private var body: InteractionBody = InteractionBody()
    
    public init() {}
}

public extension InteractionBodyBuilder {
    @discardableResult func addTitle(_ title: String) -> InteractionBodyBuilder {
        body.title = title
        return self
    }
    
    @discardableResult func addCustomId(_ customId: String) -> InteractionBodyBuilder {
        body.customId = customId
        return self
    }
    
    @discardableResult func markEphemeral(_ ephemeral: Bool = true) -> InteractionBodyBuilder {
        body.flags = ephemeral ? 64 : 0
        return self
    }
    
    @discardableResult func setContent(_ content: String = "") -> InteractionBodyBuilder {
        body.content = content
        return self
    }
    
    @discardableResult func addEmbed(_ embed: EmbedBuilder) -> InteractionBodyBuilder {
        body.embeds.append(embed)
        return self
    }
    
    @discardableResult func addEmbeds(_ embeds: [EmbedBuilder]) -> InteractionBodyBuilder {
        embeds.reduce(self) { _self, embed in _self.addEmbed(embed) }
    }
    
    @discardableResult func addComponent(_ component: ActionRow) -> InteractionBodyBuilder {
        body.components.append(component)
        return self
    }
    
    @discardableResult func addComponents(_ components: [ActionRow]) -> InteractionBodyBuilder {
        components.reduce(self) { _self, component in _self.addComponent(component) }
    }
    
    @discardableResult func addAttachment(_ attachment: AttachmentBuilder) -> InteractionBodyBuilder {
        body.attachments.append(attachment)
        return self
    }
    
    @discardableResult func addAttachments(_ attachments: [AttachmentBuilder]) -> InteractionBodyBuilder {
        attachments.reduce(self) { _self, attachment in _self.addAttachment(attachment) }
    }
}

extension InteractionBodyBuilder {
    func finish() -> InteractionBody {
        let body = body
        self.body = InteractionBody()
        return body
    }
}
