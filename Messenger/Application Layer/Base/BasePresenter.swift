import Foundation

protocol BasePresenterProtocol: AnyObject {
    func loadView()
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
}

extension BasePresenterProtocol {
    func loadView() {}
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewWillDisappear() {}
}
