//
//  File.swift
//  
//
//  Created by Eric Rabil on 12/31/22.
//

import Foundation

public protocol _EmbedElementView {
    func _into(builder: EmbedBuilder)
}

extension EmbedField: _EmbedElementView {
    public func _into(builder: EmbedBuilder) {
        _ = builder.addField(name, value: value, isInline: inline)
    }
}

extension EmbedAuthor: _EmbedElementView {
    public func _into(builder: EmbedBuilder) {
        builder.author = self
    }
}

extension EmbedImage: _EmbedElementView {
    public func _into(builder: EmbedBuilder) {
        builder.image = self
    }
}

extension EmbedThumbnail: _EmbedElementView {
    public func _into(builder: EmbedBuilder) {
        builder.thumbnail = self
    }
}

extension EmbedVideo: _EmbedElementView {
    public func _into(builder: EmbedBuilder) {
        builder.video = self
    }
}

extension Array: _EmbedElementView {
    public func _into(builder: EmbedBuilder) where Element == _EmbedElementView {
        forEach { $0._into(builder: builder) }
    }
    public func _into(builder: EmbedBuilder) {
        if let self = self as? [_EmbedElementView] {
            return self._into(builder: builder)
        }
        fatalError()
    }
}

extension Optional: _EmbedElementView where Wrapped: _EmbedElementView {
    public func _into(builder: EmbedBuilder) {
        map { $0._into(builder: builder) }
    }
}

extension EmbedBuilder {
    public convenience init(@EmbedElementBuilder inner: () -> some _EmbedElementView) {
        self.init()
        inner()._into(builder: self)
    }
}

extension EmbedBuilder: _InteractionRootView {
    public func _into(builder: InteractionBodyBuilder) {
        builder.addEmbed(self)
    }
}

@resultBuilder
public struct EmbedElementBuilder {
    public static func buildEither(first component: some _EmbedElementView) -> some _EmbedElementView {
        component
    }
    
    public static func buildEither(second component: some _EmbedElementView) -> some _EmbedElementView {
        component
    }
    
    public static func buildOptional(_ component: (some _EmbedElementView)?) -> some _EmbedElementView {
        component
    }
    
    public static func buildArray(_ components: [some _EmbedElementView]) -> some _EmbedElementView {
        components
    }
    
    public static func buildBlock(_ components: (any _EmbedElementView)...) -> some _EmbedElementView {
        components
    }
}
