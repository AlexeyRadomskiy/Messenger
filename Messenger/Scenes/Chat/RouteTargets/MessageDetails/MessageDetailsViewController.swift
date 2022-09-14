import UIKit

protocol MessageDetailsViewProtocol: BaseViewProtocol {
    
}

class MessageDetailsViewController: BaseViewController {
    
    // MARK: - Properties
    
    var presenter: MessageDetailsPresenterProtocol {
        basePresenter as! MessageDetailsPresenterProtocol
    }
	
	private let userView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .tertiarySystemFill
		imageView.alpha = 0.0
		
		return imageView
	}()
	
	private let messageLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.backgroundColor = .clear
		label.sizeToFit()
		label.textColor = .label
		label.textAlignment = .left
		label.lineBreakMode = .byWordWrapping
		label.alpha = 0.0
		
		return label
	}()
	
	private let sendTimeLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.backgroundColor = .clear
		label.sizeToFit()
		label.textColor = .label
		label.textAlignment = .left
		label.lineBreakMode = .byWordWrapping
		label.alpha = 0.0
		label.text = R.Strings.MessageDetails.sendTimeTitle
		
		return label
	}()
	
	private let deleteMessageButton: UIButton = {
		let button = UIButton()
		button.setAttr(
			text: R.Strings.MessageDetails.deleteMessageButtonTitle,
			normal: UIColor.label
		)
		button.roundCorners(radius: 16.0)
		button.backgroundColor = .systemFill
		button.alpha = 0.0
		
		return button
	}()
	
	private var image: UIImage? {
		UIImage(data: presenter.imageData ?? Data())
	}
    
}

// MARK: - View Protocol Implementation

extension MessageDetailsViewController: MessageDetailsViewProtocol {
    
}

// MARK: - Setup Subviews

extension MessageDetailsViewController {
    
    override func embedSubviews() {
		view.addSubviews(userView, messageLabel, sendTimeLabel, deleteMessageButton)
    }
    
    override func setSubviewsConstraints() {
		NSLayoutConstraint.activate([
			userView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
			userView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			userView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
			userView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2),
			
			messageLabel.topAnchor.constraint(equalTo: userView.bottomAnchor, constant: 16.0),
			messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
			messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
			
			sendTimeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16.0),
			sendTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
			sendTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
			
			deleteMessageButton.heightAnchor.constraint(equalToConstant: 52.0),
			deleteMessageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
			deleteMessageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
			deleteMessageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -84.0)
		])
    }
    
}

// MARK: - Private Methods

extension MessageDetailsViewController {
	
	override func configureAppearance() {
		super.configureAppearance()
		
		setText()
		setImage()
		addAnimations()
	}
	
	override func addActions() {
		deleteMessageButton.addTarget { [weak self] _ in
			self?.presenter.deleteMessage()
		}
	}
	
	private func addAnimations() {
		UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut) {
			self.userView.alpha = 1.0
			self.messageLabel.alpha = 1.0
			self.sendTimeLabel.alpha = 1.0
			self.deleteMessageButton.alpha = 1.0
		}
	}
    
	private func setText() {
		messageLabel.text = R.Strings.MessageDetails.messageTitle + presenter.message
	}
	
	private func setImage() {
		userView.roundCorners(radius: view.bounds.width / 4)
		userView.image = image
	}
	
}
