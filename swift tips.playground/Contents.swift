import Foundation




struct Test: Decodable {
    var name: String
    @Default<Int.Zero> var age: Int
    @Default<Bool.False> var isFoo: Bool
}

enum ResultKey: CodingKeyRepresentable {
    static let key: String = "result"
}

func testJson() {
    let jsonString = """
        {
            "name": "atest",
            "isFooo": 1,
            "result": "success"
        }
        """
    
    guard let data = jsonString.data(using: .utf8) else { return }
    
    do {
//        let value = try JSONDecoder().decode(Test.self, from: data)
        let value = try JSONDecoder().decode(Pick<ResultKey, String>.self, from: data)
        print(value)
    } catch {
        print(error)
    }
}


testJson()
