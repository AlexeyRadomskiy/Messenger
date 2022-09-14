import Foundation

protocol ChatPresenterProtocol: BasePresenterProtocol {
    
    // MARK: - View To Presenter
	
	var messages: [String] { get }
	var imageData: Data? { get }
	var localMessagesCount: Int { get }
	
	func downloadMessages()
	func getTextForCell(at indexPath: IndexPath) -> String
	func messageDidTap(at indexPath: IndexPath)
	func sendButtonDidTap(with text: String)
    
    // MARK: - Interactor To Presenter
    
	func messagesDidReceived(isScrollToBottom: Bool)
	func getError()
}

class ChatPresenter {
    
    // MARK: - Properties
    
    private weak var view: ChatViewProtocol?
    private let interactor: ChatInteractorProtocol
    private let router: ChatRouterProtocol
	
	var messages: [String] { interactor.messages }
	var imageData: Data? { interactor.imageData }
	var localMessagesCount: Int { interactor.localMessagesCount }
    
    // MARK: - Init
    
    init(
		view: ChatViewProtocol,
		interactor: ChatInteractorProtocol,
		router: ChatRouterProtocol
	) {        
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - Presenter Protocol Implementation

extension ChatPresenter: ChatPresenterProtocol {
    
    // MARK: - View To Presenter
    
    func viewDidLoad() {
		interactor.fetchImage()
        downloadMessages()
    }
	
	func downloadMessages() {
		interactor.fetchMessages()
	}
	
	func getTextForCell(at indexPath: IndexPath) -> String {
		messages[indexPath.row]
	}
	
	func messageDidTap(at indexPath: IndexPath) {
		let message = messages[indexPath.row]
		
		router.openMessageDetailsScene(for: message, imageData) { [weak self] in
			self?.interactor.removeMessage(at: indexPath)
			self?.view?.updateTableView(isScrollToBottom: false)
		}
	}
	
	func sendButtonDidTap(with text: String) {
		interactor.updateMessages(with: text)
	}
    
    // MARK: - Interactor To Presenter
	
	func messagesDidReceived(isScrollToBottom: Bool) {
		view?.updateTableView(isScrollToBottom: isScrollToBottom)
	}
    
	func getError() {
		view?.showAlert()
	}
}
