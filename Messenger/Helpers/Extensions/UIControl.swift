import UIKit

//MARK: - Add Target

/// Closurable protocol
public protocol Closurable: AnyObject {}

public extension Closurable {
	
	func getContainer(for closure: @escaping (Self) -> Void) -> ClosureContainer<Self> {
		weak var weakSelf = self
		let container = ClosureContainer(closure: closure, caller: weakSelf)
		objc_setAssociatedObject(self, Unmanaged.passUnretained(self).toOpaque(), container as AnyObject?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

		return container
	}
}

public final class ClosureContainer<T: Closurable> {
	var closure: (T) -> Void
	var caller: T?

	public init(closure: @escaping (T) -> Void, caller: T?) {
		self.closure = closure
		self.caller = caller
	}

	@objc public func processHandler() {
		if let caller = caller {
			closure(caller)
		}
	}

	public var action: Selector { #selector(processHandler) }
}

// MARK: - UIControl

extension UIControl: Closurable {
	
	public func addTarget(
		for event: UIControl.Event = .touchUpInside,
		closure: @escaping (UIControl) -> ()
	) {
		let container = getContainer(for: closure)
		addTarget(container, action: container.action, for: event)
	}
	
}
