import UIKit

// MARK: - UIGestureRecognizer

/// extension for UIGestureRecognizer - actions with closure
extension UIGestureRecognizer: Closurable {
	
	public convenience init(closure: @escaping (UIGestureRecognizer) -> Void) {
		self.init()

		let container = getContainer(for: closure)
		addTarget(container, action: container.action)
	}
	
}

extension UISwipeGestureRecognizer {
	
	public convenience init(
		direction: UISwipeGestureRecognizer.Direction,
		_ closure: @escaping (UISwipeGestureRecognizer) -> Void
	) {
		self.init()
		
		self.direction = direction
		let container = getContainer(for: closure)
		addTarget(container, action: container.action)
	}
	
}
