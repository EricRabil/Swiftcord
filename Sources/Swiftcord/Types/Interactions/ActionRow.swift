//
//  ActionRow.swift
//  Swiftcord
//
//  Created by Noah Pistilli on 2021-12-19.
//

import Foundation

/// ActionRow object that can hold any `Component`
public struct ActionRow: Component {
    public let type: ComponentTypes
    public var components: [any Component]

    enum CodingKeys: String, CodingKey {
        case type
        case components
    }

    public init(components: any Component...) {
        self.init(components: components)
    }
    
    public init(components: [any Component]) {
        self.type = .actionRow
        self.components = components
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try self.components.encode(container.superEncoder(forKey: .components))
    }
}
