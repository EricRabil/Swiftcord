//
//  Components.swift
//  Swiftcord
//
//  Created by Noah Pistilli on 2021-12-16.
//

import Foundation

public enum ComponentTypes: Int, Encodable {
    case actionRow = 1, button, selectMenu, textInput
}

public protocol Component: Encodable {
    var type: ComponentTypes { get }
}

extension Component {
    func encode(_ encoder: Encoder) throws {
        try encode(to: encoder)
    }
}

extension Array {
    func encode(_ encoder: Encoder) throws where Element == any Component {
        var container = encoder.unkeyedContainer()
        for component in self {
            try component.encode(to: container.superEncoder())
        }
    }
}
