//
//  SelectMenu.swift
//  Swiftcord
//
//  Created by Noah Pistilli on 2021-12-16.
//

import Foundation

public class SelectMenuBuilder: Encodable {
    public var content: String
    public var components: [ActionRow]

    public init(message: String) {
        self.content = message
        self.components = []
    }

    public func addComponent(component: ActionRow) -> Self {
        components.append(component)
        return self
    }
}

public struct SelectMenu: Component {
    public let type: ComponentTypes
    public let customId: String
    public var options: [SelectMenuOptions]
    public let placeholder: String?

    public init(customId: String, placeholder: String? = nil, options: [SelectMenuOptions]) {
        self.type = .selectMenu
        self.customId = customId
        self.options = options
        self.placeholder = placeholder
    }
    
    public init(customId: String, placeholder: String? = nil, options: SelectMenuOptions...) {
        self.init(customId: customId, placeholder: placeholder, options: options)
    }
}

public extension InteractionBodyBuilder {
    @discardableResult func addSelection(_ selection: SelectMenu) -> InteractionBodyBuilder {
        addComponent(ActionRow(components: [selection]))
    }
    
    @discardableResult func addSelection(customId: String, placeholder: String? = nil, options: [SelectMenuOptions]) -> InteractionBodyBuilder {
        addSelection(SelectMenu(customId: customId, placeholder: placeholder, options: options))
    }
}

public struct SelectMenuOptions: Encodable {
    public let label: String
    public let value: String
    public let description: String?
    public let emoji: Emoji?
    public let `default`: Bool?

    public init(label: String, value: String, description: String? = nil, emoji: Emoji? = nil, default: Bool? = nil) {
        self.label = label
        self.value = value
        self.description = description
        self.emoji = emoji
        self.default = `default`
    }
}
