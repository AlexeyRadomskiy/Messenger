import Foundation

protocol ChatService {
	func fetchData(
		with offset: Int,
		_ completion: @escaping (Result<MessageModel, NetworkError>) -> Void
	)
}

// MARK: - Implementation

struct ChatServiceImp: ChatService {
	
	// MARK: - Properties
	
	private let networkManager: NetworkManager
	
	// MARK: - Init
	
	init(networkManager: NetworkManager = NetworkManagerImp()) {
		self.networkManager = networkManager
	}
	
	// MARK: - Methods
	
	func fetchData(
		with offset: Int,
		_ completion: @escaping (Result<MessageModel, NetworkError>) -> Void
	) {
		networkManager.fetch(with: MainEndpoint.chatData(offset: offset)) { result in
			completion(result)
		}
	}
	
}
