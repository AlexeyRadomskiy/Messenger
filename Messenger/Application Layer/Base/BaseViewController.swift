import UIKit.UIViewController

protocol BaseViewProtocol: AnyObject {}

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    var basePresenter: BasePresenterProtocol!
	
	private let backBarButtonItem = UIBarButtonItem(
		title: "Назад",
		style: .plain,
		target: nil,
		action: nil
	)
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        
        basePresenter.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
		configureAppearance()
		addActions()
        basePresenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        basePresenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        basePresenter.viewWillDisappear()
    }
    
}

// MARK: - Methods

@objc extension BaseViewController {
    
    func setupSubviews() {
        embedSubviews()
        setSubviewsConstraints()
    }
    
    func embedSubviews() {}
    
    func setSubviewsConstraints() {}
	
	func addActions() {}
	
	func configureAppearance() {
		view.backgroundColor = .systemGroupedBackground
		navigationItem.backBarButtonItem = backBarButtonItem
	}
    
}
