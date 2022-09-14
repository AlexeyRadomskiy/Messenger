import UIKit

final class UserTableViewCell: BaseTableViewCell {
	
	// MARK: - Properties
	
	private let userView: UIImageView = {
		let imageView = UIImageView()
		imageView.roundCorners(radius: 16.0)
		imageView.backgroundColor = .tertiarySystemFill
		
		return imageView
	}()
	
	private let messageView: UIView = {
		let view = UIView()
		view.backgroundColor = .tertiarySystemFill
		view.roundCorners(radius: 8.0)
		
		return view
	}()
	
	private let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.backgroundColor = .clear
		label.sizeToFit()
		label.textColor = .label
		label.textAlignment = .left
		label.lineBreakMode = .byWordWrapping
		
		return label
	}()
	
	var messageTapHandler: (() -> Void)?
	
	// MARK: - Init
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		label.text = nil
	}
	
	// MARK: - Setter Methods
	
	func configure(with message: String, image: UIImage?) {
		label.text = message
		
		guard let image = image else { return }
		userView.image = image
	}
	
}

// MARK: - Private Methods

extension UserTableViewCell {
	
	override func addActions() {
		super.addActions()
		
		messageView.isUserInteractionEnabled = true
		let messageTapGesture = UITapGestureRecognizer { [weak self] _ in
			self?.messageTapHandler?()
		}
		messageView.addGestureRecognizer(messageTapGesture)
	}
	
}

// MARK: - Layout

extension UserTableViewCell {
	
	override func embedSubviews() {
		contentView.addSubviews(messageView, userView)
		messageView.addSubviews(label)
	}
	
	override func setSubviewsConstraints() {
		NSLayoutConstraint.activate([
			userView.heightAnchor.constraint(equalToConstant: 32.0),
			userView.widthAnchor.constraint(equalToConstant: 32.0),
			userView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
			userView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor),
			
			messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
			messageView.trailingAnchor.constraint(equalTo: userView.leadingAnchor, constant: -8.0),
			messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			messageView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.7),
			
			label.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 8.0),
			label.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 8.0),
			label.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -8.0),
			label.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -8.0)
		])
	}
	
}
