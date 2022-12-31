//
//  File.swift
//  
//
//  Created by Eric Rabil on 12/31/22.
//

import Foundation

public protocol _InteractionView {}

public protocol _InteractionControlView: _InteractionView {
    func _into(row: inout ActionRow)
}

extension Array: _InteractionControlView {
    public func _into(row: inout ActionRow) where Element == _InteractionControlView {
        forEach { $0._into(row: &row) }
    }
    public func _into(row: inout ActionRow) {
        if let self = self as? [_InteractionControlView] {
            return self._into(row: &row)
        }
        fatalError()
    }
}

public protocol _InteractionRootView: _InteractionView {
    func _into(builder: InteractionBodyBuilder)
}

public typealias InteractionElement = _InteractionRootView

public protocol InteractionComponent {
    associatedtype View: InteractionElement
    @InteractionBuilder func component() async -> View
}

/// A component capable of hosting multiple inner components
public actor InteractionMultiComponent: InteractionComponent {
    public var children: [any InteractionComponent] = []
    
    public init() {}
    
    public func component() async -> some _InteractionRootView {
        children
    }
}

extension Array: _InteractionView, _InteractionRootView {
    public func _into(builder: InteractionBodyBuilder) where Element == _InteractionRootView {
        forEach { $0._into(builder: builder) }
    }
    public func _into(builder: InteractionBodyBuilder) {
        if let self = self as? [_InteractionRootView] {
            return self._into(builder: builder)
        }
        fatalError()
    }
}

extension Optional: _InteractionView {}

extension Optional: _InteractionRootView where Wrapped: _InteractionRootView {
    public func _into(builder: InteractionBodyBuilder) {
        map { $0._into(builder: builder) }
    }
}

extension Optional: _InteractionControlView where Wrapped: _InteractionControlView {
    public func _into(row: inout ActionRow) {
        map { $0._into(row: &row) }
    }
}

struct _InteractionBuilder: _InteractionRootView {
    var content: String = ""
    var views: [_InteractionRootView] = []
    
    func _into(builder: InteractionBodyBuilder) {
        builder.setContent(content)
        views._into(builder: builder)
    }
}
