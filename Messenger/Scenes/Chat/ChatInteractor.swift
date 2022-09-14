import Foundation

protocol ChatInteractorProtocol: AnyObject {
	var messages: [String] { get }
	var imageData: Data? { get }
	var localMessagesCount: Int { get }
	
	func fetchMessages()
	func fetchImage()
	func removeMessage(at indexPath: IndexPath)
	func updateMessages(with text: String)
}

class ChatInteractor: ChatInteractorProtocol {
    
    // MARK: - Properties
    
    var presenter: ChatPresenterProtocol!
	
	var messages: [String] = []
	var imageData: Data?
	var localMessagesCount: Int {
		let localMessages = UserDefaults.standard.object(forKey: "Local Messages") as? [String]
		
		return localMessages?.count ?? 0
	}
	
	private let chatService: ChatService = ChatServiceImp()
	private let imageService: ImageService = ImageServiceImp()
	
	private var isInitialLoading = false
	private var offset = 0
    
    // MARK: - Methods
	
	func fetchMessages() {
		chatService.fetchData(with: offset) { result in
			switch result {
			case .success(let model):
				self.offset += 10
				model.result.forEach { self.messages.append($0) }
				
				DispatchQueue.main.async {
					if self.isInitialLoading {
						self.presenter.messagesDidReceived(isScrollToBottom: false)
					} else {
						let localMessages = UserDefaults.standard.object(forKey: "Local Messages") as? [String]
						localMessages?.forEach { self.messages.insert($0, at: 0) }
						self.presenter.messagesDidReceived(isScrollToBottom: true)
						self.isInitialLoading = true
					}
				}
			case .failure(let error):
				print(error.localizedDescription)
				
				DispatchQueue.main.async {
					self.presenter.getError()
					if self.offset > 20 {
						self.offset -= 10
					}
				}
			}
		}
	}
	
	func fetchImage() {
		imageService.fetchData { result in
			switch result {
			case .success(let data):
				DispatchQueue.main.async {
					self.imageData = data
					self.presenter.messagesDidReceived(isScrollToBottom: false)
				}
			case .failure(let error):
				print(error.localizedDescription)
				
				DispatchQueue.main.async {
					self.presenter.getError()
				}
			}
		}
	}
	
	func removeMessage(at indexPath: IndexPath) {
		messages.remove(at: indexPath.row)
	}
	
	func updateMessages(with text: String) {
		if var localMessages = UserDefaults.standard.object(forKey: "Local Messages") as? [String] {
			localMessages.append(text)
			UserDefaults.standard.set(localMessages, forKey: "Local Messages")
		}
		
		messages.insert(text, at: 0)
	}
    
}
