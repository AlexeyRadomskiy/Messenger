import UIKit.UIViewController

protocol BaseRouterProtocol: AnyObject {}

class BaseRouter {
    
    // MARK: - Properties
    
    private unowned var viewController: UIViewController
    
    init(view: UIViewController) {
        viewController = view
    }
    
    // MARK: - Methods
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        self.viewController.navigationController?.pushViewController(viewController, animated: animated)
    }
	
	func pop(_ animated: Bool = true) {
		self.viewController.navigationController?.popViewController(animated: animated)
	}
	
	func presentingPush(_ viewController: UIViewController, animated: Bool = true) {
		self.viewController.presentingViewController?.navigationController?.pushViewController(viewController, animated: animated)
	}
    
    func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.viewController.present(viewController, animated: animated, completion: completion)
    }
    
    func show(_ viewController: UIViewController, sender: Any? = nil) {
        self.viewController.show(viewController, sender: sender)
    }
    
}
