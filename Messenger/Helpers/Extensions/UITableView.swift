import UIKit

// MARK: - Reusable ID

protocol Reusable {
	static var reusableId: String { get }
}

// MARK: - UITableViewCell

extension UITableViewCell: Reusable {
	static var reusableId: String { String(describing: self) }
}

// MARK: -

extension UITableViewHeaderFooterView: Reusable {
	static var reusableId: String { String(describing: self) }
}

// MARK: - TableView

extension UITableView {
	
	func register<T: UITableViewCell>(_ :T.Type) {
		register(T.self, forCellReuseIdentifier: T.reusableId)
	}
	
	func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(
			withIdentifier: T.reusableId,
			for: indexPath
		) as? T else {
			fatalError("Could not dequeue cell with identifier: \(T.reusableId)")
		}
		
		return cell
	}
	
	func register<T: UITableViewHeaderFooterView>(_ :T.Type) {
		register(T.self, forHeaderFooterViewReuseIdentifier: T.reusableId)
	}
	
	func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
		guard let headerOrFooter = dequeueReusableHeaderFooterView(
			withIdentifier: T.reusableId
		) as? T else {
			fatalError("Could not dequeue headerOrFooter with identifier: \(T.reusableId)")
		}
		
		return headerOrFooter
	}
	
}
