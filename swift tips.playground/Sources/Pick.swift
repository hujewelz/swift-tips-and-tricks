import Foundation

public protocol CodingKeyRepresentable {
    static var key: String { get }
}

public struct Pick<Key, Value> where Key: CodingKeyRepresentable, Value: Decodable {
    public let value: Value
    
    private struct CodingKeys: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            fatalError()
        }
    }
}

extension Pick: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(Value.self, forKey: CodingKeys(stringValue: Key.key)!)
    }
}
