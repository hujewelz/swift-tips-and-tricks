import Foundation

public protocol DefaultRepresentable {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

@propertyWrapper
public struct Default<T: DefaultRepresentable> {
    public var wrappedValue: T.Value
    
    public init(wrappedValue: T.Value) {
        self.wrappedValue = wrappedValue
    }
}

extension Default: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}

extension KeyedDecodingContainer {
    public func decode<T>(_ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultRepresentable {
        try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
    }
}

extension Default: CustomStringConvertible, CustomDebugStringConvertible {
    public var debugDescription: String {
        String(reflecting: wrappedValue)
    }
    
    public var description: String {
        String(describing: wrappedValue)
    }
}

extension Bool {
    public enum True: DefaultRepresentable {
        public static let defaultValue = true
    }
    
    public enum False: DefaultRepresentable {
        public static let defaultValue = false
    }
}

extension Int {
    public enum Zero: DefaultRepresentable {
        public static let defaultValue: Int = 0
    }
}
