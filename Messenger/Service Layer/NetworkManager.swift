import Foundation

protocol NetworkManager {
	func fetchImage(
		with endpoint: Endpoint,
		completion: @escaping(Result<Data, NetworkError>) -> Void
	)
	func fetch(
		with endpoint: Endpoint,
		completion: @escaping(Result<MessageModel, NetworkError>) -> Void
	)
}

class NetworkManagerImp: NetworkManager {
	
	func fetchImage(
		with endpoint: Endpoint,
		completion: @escaping(Result<Data, NetworkError>) -> Void
	) {
		guard let url = URL(string: endpoint.baseURL + endpoint.url) else {
			completion(.failure(.invalidURL))
			return
		}
		DispatchQueue.global().async {
			guard let imageData = try? Data(contentsOf: url) else {
				completion(.failure(.noData))
				return
			}
			DispatchQueue.main.async {
				completion(.success(imageData))
			}
		}
	}
	
	func fetch(
		with endpoint: Endpoint,
		completion: @escaping(Result<MessageModel, NetworkError>) -> Void
	) {
		guard let url = URL(string: endpoint.baseURL + endpoint.url) else {
			completion(.failure(.invalidURL))
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data else {
				completion(.failure(.noData))
				print(error?.localizedDescription ?? "No error description")
				
				return
			}
			do {
				let decoder = JSONDecoder()
				let type = try decoder.decode(MessageModel.self, from: data)
				DispatchQueue.main.async {
					completion(.success(type))
				}
			} catch {
				completion(.failure(.decodingError))
			}
		}.resume()
	}
	
}
