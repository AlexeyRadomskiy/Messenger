import Foundation

protocol Endpoint {
    var url: String { get }
    var baseURL: String { get }
}

enum MainEndpoint: Endpoint {
	case chatData(offset: Int)
	case imageData
	
	var url: String {
		switch self {
		case .chatData(let offset):
			return "?offset=\(offset)"
		case .imageData:
			return ""
		}
	}
	
	var baseURL: String {
		switch self {
		case .chatData:
			return R.Strings.Link.chatURL.rawValue
		case .imageData:
			return  R.Strings.Link.imageURL.rawValue
		}
	}
	
}

