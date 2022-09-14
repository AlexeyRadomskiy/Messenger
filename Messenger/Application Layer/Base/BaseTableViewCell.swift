import UIKit.UITableViewCell

// MARK: - BaseTableViewHeaderFooterView

class BaseTableViewCell: UITableViewCell {
	
	// MARK: - Init & life cycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupSubviews()
		addActions()
		configureCellAppearance()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - Objc extension

@objc extension BaseTableViewCell {
	
	// MARK: - Methods
	
	func setupSubviews() {
		embedSubviews()
		setSubviewsConstraints()
	}
	
	func embedSubviews() {}
	
	func setSubviewsConstraints() {}
	
	func addActions() {}
	
	func configureCellAppearance() {
		selectionStyle = .none
		backgroundColor = .clear
	}
	
}
