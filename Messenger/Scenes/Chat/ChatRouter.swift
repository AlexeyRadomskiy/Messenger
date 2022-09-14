import Foundation

protocol ChatRouterProtocol: BaseRouterProtocol {
	func openMessageDetailsScene(
		for message: String,
		_ imageData: Data?,
		completion: (() -> Void)?
	)
}

class ChatRouter: BaseRouter, ChatRouterProtocol {
    
    // MARK: - Properties
        
    // MARK: - Instantiate
    
    class func createScene() -> ChatViewController {
        let view = ChatViewController()
        let interactor = ChatInteractor()
        let router = ChatRouter(view: view)
        let presenter = ChatPresenter(view: view, interactor: interactor, router: router)
        
        view.basePresenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
    // MARK: - Methods
    
	func openMessageDetailsScene(
		for message: String,
		_ imageData: Data?,
		completion: (() -> Void)?
	) {
		let viewController = MessageDetailsRouter.createScene(with: message, imageData) {
			completion?()
		}
		
		push(viewController)
	}
	
}
