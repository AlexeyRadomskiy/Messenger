import Foundation

protocol MessageDetailsInteractorProtocol: AnyObject {
	var message: String { get }
	var imageData: Data? { get }
	
	func deleteMessage()
}

class MessageDetailsInteractor: MessageDetailsInteractorProtocol {
    
    // MARK: - Properties
    
    var presenter: MessageDetailsPresenterProtocol!
	
	var message: String
	var imageData: Data?
	
	private var userDefaults = UserDefaults.standard
	
	// MARK: - Init
	
	init(with message: String, _ imageData: Data?) {
		self.message = message
		self.imageData = imageData
	}
    
    // MARK: - Methods
	
	func deleteMessage() {
		if var localMessages = userDefaults.object(forKey: "Local Messages") as? [String] {
			localMessages.enumerated().forEach { index, localMessage in
				if localMessage == message {
					localMessages.remove(at: index)
					userDefaults.set(localMessages, forKey: "Local Messages")
				}
			}
		}
	}
    
}
