public struct API {
    let host: String
}

// MARK: - RawRepresentable

extension API: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        host = value
    }

    public init(unicodeScalarLiteral value: UnicodeScalarType) {
        self.init(stringLiteral: value)
    }

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
        self.init(stringLiteral: value)
    }
}
