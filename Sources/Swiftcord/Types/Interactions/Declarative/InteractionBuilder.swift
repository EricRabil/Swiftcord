//
//  File.swift
//  
//
//  Created by Eric Rabil on 12/30/22.
//

import Foundation

extension AttachmentBuilder: _InteractionRootView {
    public func _into(builder: InteractionBodyBuilder) {
        builder.addAttachment(self)
    }
}

extension ActionRow: _InteractionRootView {
    public func _into(builder: InteractionBodyBuilder) {
        builder.addComponent(self)
    }
}

@resultBuilder
public struct InteractionBuilder {
    public static func buildOptional(_ component: (some _InteractionRootView)?) -> some _InteractionRootView {
        component
    }
    
    public static func buildEither(first component: some _InteractionRootView) -> some _InteractionRootView {
        component
    }
    
    public static func buildEither(second component: some _InteractionRootView) -> some _InteractionRootView {
        component
    }
    
    public static func buildArray(_ components: [some _InteractionRootView]) -> some _InteractionRootView {
        components
    }
    
    public static func buildBlock(_ components: (any _InteractionRootView)...) -> some _InteractionRootView {
        components
    }
}

extension InteractionBodyBuilder {
    public convenience init(@InteractionBuilder _ body: () -> some _InteractionRootView) {
        self.init()
        body()._into(builder: self)
    }
}

extension InteractionBody {
    public init(@InteractionBuilder _ body: () -> some _InteractionRootView) {
        self = InteractionBodyBuilder(body).finish()
    }
}
