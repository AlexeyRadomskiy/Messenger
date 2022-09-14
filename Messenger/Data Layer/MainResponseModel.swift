import Foundation

// MARK: - MessageModelEncodable

struct MessageModelEncodable: Encodable {
	let offset: Int
}

// MARK: - MessageModel

struct MessageModel: Decodable {
	let result: [String]
}
