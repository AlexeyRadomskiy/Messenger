import Foundation

protocol MessageDetailsRouterProtocol: BaseRouterProtocol {
	func popViewController(animated: Bool)
}

class MessageDetailsRouter: BaseRouter, MessageDetailsRouterProtocol {
    
    // MARK: - Properties
        
    // MARK: - Instantiate
    
    class func createScene(
		with message: String,
		_ imageData: Data?,
		completion: (() -> Void)?
	) -> MessageDetailsViewController {
        let view = MessageDetailsViewController()
		let interactor = MessageDetailsInteractor(with: message, imageData)
        let router = MessageDetailsRouter(view: view)
        let presenter = MessageDetailsPresenter(view: view, interactor: interactor, router: router)
        
        view.basePresenter = presenter
        interactor.presenter = presenter
		presenter.completion = completion
        
        return view
    }
    
    // MARK: - Methods
	
	func popViewController(animated: Bool) {
		pop(animated)
	}
    
}
