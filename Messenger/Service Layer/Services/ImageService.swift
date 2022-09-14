import Foundation

protocol ImageService {
	func fetchData(_ completion: @escaping (Result<Data, NetworkError>) -> Void)
}

// MARK: - Implementation

struct ImageServiceImp: ImageService {
	
	// MARK: - Properties
	
	private let networkManager: NetworkManager
	
	// MARK: - Init
	
	init(networkManager: NetworkManager = NetworkManagerImp()) {
		self.networkManager = networkManager
	}
	
	// MARK: - Methods
	
	func fetchData(_ completion: @escaping (Result<Data, NetworkError>) -> Void) {
		networkManager.fetchImage(with: MainEndpoint.imageData) { result in
			completion(result)
		}
	}
	
}
