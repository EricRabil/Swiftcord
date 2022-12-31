//
//  TextInput.swift
//  
//
//  Created by Noah Pistilli on 2022-03-04.
//

public enum TextInputStyles: Int, Encodable {
    /// `short` specifies a single line input.
    case short = 1

    /// `paragraph` specifies a multiple line input.
    case paragraph
}

public struct TextInput: Component {
    public let type: ComponentTypes
    public let customId: String
    public let style: TextInputStyles
    public let label: String
    public var minLength: Int?
    public var maxLength: Int?
    public var required: Bool?
    public var value: String?
    public var placeholder: String?

    public init(
        customID: String,
        style: TextInputStyles,
        label: String,
        minLength: Int? = nil,
        maxLength: Int? = nil,
        required: Bool? = nil,
        value: String? = nil,
        placeholder: String? = nil
    ) {
        self.type = .textInput
        self.customId = customID
        self.style = style
        self.label = label
        self.minLength = minLength
        self.maxLength = maxLength
        self.required = required
        self.value = value
        self.placeholder = placeholder
    }
}

public extension InteractionBodyBuilder {
    @discardableResult func addTextInput(_ input: TextInput) -> InteractionBodyBuilder {
        addComponent(ActionRow(components: [input]))
    }
    
    @discardableResult func addTextInput(
        customID: String,
        style: TextInputStyles,
        label: String,
        minLength: Int? = nil,
        maxLength: Int? = nil,
        required: Bool? = nil,
        value: String? = nil,
        placeholder: String? = nil
    ) -> InteractionBodyBuilder {
        addTextInput(TextInput(
            customID: customID,
            style: style,
            label: label,
            minLength: minLength,
            maxLength: maxLength,
            required: required,
            value: value,
            placeholder: placeholder
        ))
    }
}
