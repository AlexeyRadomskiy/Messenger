import UIKit

// MARK: - UIView

extension UIView {
	
	func addSubviews(_ views: UIView...) {
		views.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}
	}
	
	func roundCorners(_ corners: UIRectCorner = .allCorners, radius: CGFloat) {
		clipsToBounds = true
		layer.cornerRadius = radius
		layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
	}
	
}
