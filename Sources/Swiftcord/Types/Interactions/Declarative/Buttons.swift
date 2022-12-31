//
//  File.swift
//  
//
//  Created by Eric Rabil on 12/31/22.
//

import Foundation

extension Button: _InteractionControlView {
    public func _into(row: inout ActionRow) {
        row.components.append(self)
    }
}

public struct Buttons: _InteractionRootView {
    @resultBuilder
    public struct Builder {
        public static func buildOptional(_ component: (some _InteractionControlView)?) -> some _InteractionControlView {
            component
        }
        
        public static func buildArray(_ components: [some _InteractionControlView]) -> some _InteractionControlView {
            components
        }
        
        public static func buildEither(first component: some _InteractionControlView) -> some _InteractionControlView {
            component
        }
        
        public static func buildEither(second component: some _InteractionControlView) -> some _InteractionControlView {
            component
        }
        
        public static func buildBlock(_ components: (any _InteractionControlView)...) -> some _InteractionControlView {
            components
        }
    }
    
    let controls: any _InteractionControlView
    
    public init(@Builder _ controls: () -> some _InteractionControlView) {
        self.controls = controls()
    }
    
    public func _into(builder: InteractionBodyBuilder) {
        var row = ActionRow(components: [])
        controls._into(row: &row)
        builder.addComponent(row)
    }
}
