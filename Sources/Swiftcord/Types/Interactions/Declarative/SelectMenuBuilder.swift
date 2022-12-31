//
//  File.swift
//  
//
//  Created by Eric Rabil on 12/31/22.
//

import Foundation

extension SelectMenu: _InteractionRootView {
    public func _into(builder: InteractionBodyBuilder) {
        builder.addSelection(self)
    }
}

public protocol _SelectMenuElement {
    func _into(_ menu: inout SelectMenu)
}

extension SelectMenuOptions: _SelectMenuElement {
    public func _into(_ menu: inout SelectMenu) {
        menu.options.append(self)
    }
}

extension Array: _SelectMenuElement {
    public func _into(_ menu: inout SelectMenu) where Element == _SelectMenuElement {
        forEach { $0._into(&menu) }
    }
    public func _into(_ menu: inout SelectMenu) {
        if let self = self as? [_SelectMenuElement] {
            return self._into(&menu)
        }
        fatalError()
    }
}

extension Optional: _SelectMenuElement where Wrapped: _SelectMenuElement {
    public func _into(_ menu: inout SelectMenu) {
        map { $0._into(&menu) }
    }
}

extension SelectMenu {
    @resultBuilder
    public struct Builder {
        public static func buildOptional(_ component: (some _SelectMenuElement)?) -> some _SelectMenuElement {
            component
        }
        
        public static func buildArray(_ components: [some _SelectMenuElement]) -> some _SelectMenuElement {
            components
        }
        
        public static func buildEither(first component: some _SelectMenuElement) -> some _SelectMenuElement {
            component
        }
        
        public static func buildEither(second component: some _SelectMenuElement) -> some _SelectMenuElement {
            component
        }
        
        public static func buildBlock(_ components: (any _SelectMenuElement)...) -> some _SelectMenuElement {
            components
        }
    }
    
    public init(customId: String, placeholder: String? = nil, @Builder options: () -> some _SelectMenuElement) {
        self.init(customId: customId, placeholder: placeholder, options: [])
        let options = options()
        options._into(&self)
    }
}

extension SelectMenu: _InteractionControlView {
    public func _into(row: inout ActionRow) {
        row.components.append(self)
    }
}
