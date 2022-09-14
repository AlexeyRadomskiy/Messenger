import UIKit

extension UIButton {
	
	// MARK: - Attributes
	
	func setAttr(
		text: String,
		font: UIFont? = nil,
		normal: UIColor,
		highlighted: UIColor? = nil,
		selected: UIColor? = nil
	) {
		var attr: [NSAttributedString.Key: Any] = [:]
		
		if let font = font {
			attr[.font] = font
		}
		
		attr[.foregroundColor] = normal
		setAttributedTitle(NSAttributedString(
			string: text,
			attributes: attr
		), for: .normal)
		
		if let highlighted = highlighted {
			attr[.foregroundColor] = highlighted
			setAttributedTitle(NSAttributedString(
				string: text,
				attributes: attr
			), for: .highlighted)
		}
		
		if let selected = selected {
			attr[.foregroundColor] = selected
			setAttributedTitle(NSAttributedString(
				string: text,
				attributes: attr
			), for: .selected)
		}
	}
	
}
