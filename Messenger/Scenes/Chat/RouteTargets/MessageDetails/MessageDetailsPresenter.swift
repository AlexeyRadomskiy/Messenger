import Foundation

protocol MessageDetailsPresenterProtocol: BasePresenterProtocol {
    
    // MARK: - View To Presenter
    
	var message: String { get }
	var imageData: Data? { get }
	
	func deleteMessage()
	
    // MARK: - Interactor To Presenter
    
}

class MessageDetailsPresenter {
    
    // MARK: - Properties
    
    private weak var view: MessageDetailsViewProtocol?
    private let interactor: MessageDetailsInteractorProtocol
    private let router: MessageDetailsRouterProtocol
	
	var completion: (() -> Void)?
	var message: String { interactor.message }
	var imageData: Data? { interactor.imageData }
    
    // MARK: - Init
    
    init(
		view: MessageDetailsViewProtocol,
		interactor: MessageDetailsInteractorProtocol,
		router: MessageDetailsRouterProtocol
	) {        
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - Presenter Protocol Implementation

extension MessageDetailsPresenter: MessageDetailsPresenterProtocol {
    
    // MARK: - View To Presenter
    
    func viewDidLoad() {
        
    }
	
	func deleteMessage() {
		interactor.deleteMessage()
		completion?()
		router.popViewController(animated: true)
	}
    
    // MARK: - Interactor To Presenter
    
}
