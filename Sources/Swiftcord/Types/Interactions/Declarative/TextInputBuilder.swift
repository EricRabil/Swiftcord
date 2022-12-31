//
//  File.swift
//  
//
//  Created by Eric Rabil on 12/31/22.
//

import Foundation

public extension TextInput {
    func constraints(minLength: Int? = nil, maxLength: Int? = nil) -> TextInput {
        var input = self
        input.minLength = minLength
        input.maxLength = maxLength
        return input
    }
    
    func required(_ isRequired: Bool) -> TextInput {
        var input = self
        input.required = isRequired
        return input
    }
    
    func value(_ value: String?) -> TextInput {
        var input = self
        input.value = value
        return input
    }
    
    func placeholder(_ placeholder: String?) -> TextInput {
        var input = self
        input.placeholder = placeholder
        return input
    }
}

extension TextInput: _InteractionRootView {
    public func _into(builder: InteractionBodyBuilder) {
        builder.addComponent(ActionRow(components: [self]))
    }
}
