//
//  EmbedBuilder.swift
//  Swiftcord
//
//  Created by Noah Pistilli on 2021-12-19.
//

import Foundation

public class EmbedBuilder: Codable {
    /// Author dictionary from embed
    public internal(set) var author: Author?

    /// Side panel color of embed
    public internal(set) var color: Int?

    /// Description of the embed
    public internal(set) var description: String?

    /// Fields for the embed
    public internal(set) var fields: [Field]?

    /// Footer dictionary from embed
    public internal(set) var footer: Footer?

    /// Image data from embed
    public internal(set) var image: Image?
    
    /// Provider from embed
    public internal(set) var provider: Provider?
    
    /// Thumbnail data from embed
    public internal(set) var thumbnail: Thumbnail?

    /// Title of the embed
    public internal(set) var title: String?

    /// Type of embed | Discord says this should be considered deprecated. As such we set as rich
    public internal(set) var type: String

    /// URL of the embed
    public internal(set) var url: String?

    /// Video data from embed
    public internal(set) var video: Video?
    
    /// Timestamp of the embed
    public internal(set) var timestamp: String?

    // MARK: Initializers

    /// Creates an Embed Structure
    public init() {
        self.type = "rich"
        self.video = nil
    }

    // MARK: Functions

    /**
     Adds a field to the embed

     - parameter name: Title of the field
     - parameter value: Text that will be displayed underneath name
     - parameter inline: Whether or not to keep this field inline with others
     */
    public func addField(
        _ name: String,
        value: String,
        isInline: Bool = false
    ) -> Self {
        if self.fields == nil {
            self.fields = [Field]()
        }

        self.fields?.append(Field(name: name, value: value, isInline: isInline))

        return self
    }

    public func setTitle(title: String) -> Self {
        self.title = title
        return self
    }

    public func setDescription(description: String) -> Self {
        self.description = description
        return self
    }

    public func setColor(color: Int) -> Self {
        self.color = color
        return self
    }

    public func setFooter(text: String, url: String? = nil) -> Self {
        let footer = Footer(text: text, iconUrl: url)
        self.footer = footer

        return self
    }

    public func setImage(
        url: String,
        height: Int? = nil,
        width: Int? = nil
    ) -> Self {
        let image = Image(url: url, height: height, width: width)
        self.image = image

        return self
    }

    public func setThumbnail(
        url: String,
        height: Int? = nil,
        width: Int? = nil
    ) -> Self {
        let thumbnail = Thumbnail(url: url, height: height, width: width)
        self.thumbnail = thumbnail

        return self
    }

    public func setVideo(
        url: String,
        height: Int? = nil,
        width: Int? = nil
    ) -> Self {
        let video = Video(url: url, height: height, width: width)
        self.video = video

        return self
    }

    public func setAuthor(
        name: String,
        url: String? = nil,
        iconUrl: String? = nil
    ) -> Self {
        let author = Author(iconUrl: iconUrl, name: name, url: url)
        self.author = author

        return self
    }

    public func setTimestamp() -> Self {
        self.timestamp = ISO8601DateFormatter().string(from: Date())
        return self
    }
}

extension EmbedBuilder {
    public struct Author: Codable, Hashable {
        public var iconUrl: String?
        public var name: String
        public var url: String?

        public init(iconUrl: String? = nil, name: String, url: String? = nil) {
            self.iconUrl = iconUrl
            self.name = name
            self.url = url
        }
    }

    public struct Field: Codable, Hashable {
        public var name: String
        public var value: String
        public var inline: Bool

        public init(name: String = "", value: String = "", isInline: Bool = true) {
            self.name = name
            self.value = value
            self.inline = isInline
        }
    }

    public struct Footer: Codable, Hashable {
        public var iconUrl: String?
        public var proxyIconUrl: String?
        public var text: String

        public init(
            text: String,
            proxyIconUrl: String? = nil,
            iconUrl: String? = nil
        ) {
            self.text = text
            self.proxyIconUrl = proxyIconUrl
            self.iconUrl = iconUrl
        }
    }

    public struct Image: Codable, Hashable {
        public var height: Int?
        public var proxyUrl: String? = nil
        public var url: String
        public var width: Int?

        public init(url: String, proxyUrl: String? = nil, height: Int?, width: Int?) {
            self.height = height
            self.url = url
            self.proxyUrl = proxyUrl
            self.width = width
        }
    }

    public struct Thumbnail: Codable, Hashable {
        public var height: Int?
        public var proxyUrl: String? = nil
        public var url: String
        public var width: Int?

        public init(url: String, proxyUrl: String? = nil, height: Int?, width: Int?) {
            self.height = height
            self.proxyUrl = proxyUrl
            self.url = url
            self.width = width
        }
    }
    
    public struct Provider: Codable, Hashable {
        public var name: String
        public var url: String?
        
        public init(name: String, url: String? = nil) {
            self.name = name
            self.url = url
        }
    }

    public struct Video: Codable, Hashable {
        public var height: Int?
        public var url: String
        public var width: Int?

        public init(url: String, height: Int?, width: Int?) {
            self.height = height
            self.url = url
            self.width = width
        }
    }
}

/// Represents the parent tag in the JSON we send to Discord with an `EmbedBuilder`
struct EmbedBody: Encodable {
    let embeds: [EmbedBuilder]
}

public typealias EmbedField = EmbedBuilder.Field
public typealias EmbedAuthor = EmbedBuilder.Author
public typealias EmbedImage = EmbedBuilder.Image
public typealias EmbedThumbnail = EmbedBuilder.Thumbnail
public typealias EmbedVideo = EmbedBuilder.Video
