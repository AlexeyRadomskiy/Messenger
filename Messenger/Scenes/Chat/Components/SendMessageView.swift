import UIKit

final class SendMessageView: UIView {
	
	// MARK: - Properies
	
	private let textView: UITextView = {
		let textView = UITextView()
		textView.layer.cornerRadius = 12.0
		textView.sizeToFit()
		textView.isScrollEnabled = false
		textView.layer.borderColor = UIColor.systemGray.cgColor
		textView.layer.borderWidth = 1.0
		textView.text = R.Strings.messagePlaceholder
		textView.textColor = .systemGray
		textView.font = R.Fonts.helveticaRegular(with: 15.0)
		
		return textView
	}()
	
	private let sendButton: UIButton = {
		let button = UIButton()
		button.setAttr(
			text: R.Strings.sendButtonTitle,
			normal: UIColor.systemGray
		)
		button.isEnabled = false
		
		return button
	}()
	
	var sendButtonTapHandler: ((String) -> Void)?
	var textViewStartEditing: (() -> Void)?
	
	private var height: CGFloat?
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureAppearance()
		addActions()
		embedSubviews()
		setSubviewsConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - Layout

extension SendMessageView {
	
	private func embedSubviews() {
		addSubviews(textView, sendButton)
	}
	
	private func setSubviewsConstraints() {
		NSLayoutConstraint.activate([
			textView.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
			textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
			textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16.0),
			textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0),
			
			sendButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
			sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
			sendButton.widthAnchor.constraint(equalToConstant: 100.0)
		])
	}
	
}

// MARK: - Private Methods

extension SendMessageView {
	
	private func configureAppearance() {
		backgroundColor = .systemGroupedBackground
		textView.delegate = self
		height = frame.height
	}
	
	private func addActions() {
		sendButton.addTarget { [weak self] _ in
			guard let text = self?.textView.text else { return }
			self?.sendButtonTapHandler?(text)
			self?.textView.text = nil
			self?.configureSendButton()
		}
	}
}

// MARK: - UITextViewDelegate

extension SendMessageView: UITextViewDelegate {
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.text = nil
		textViewStartEditing?()
		textView.textColor = .label
	}
	
	func textViewDidChange(_ textView: UITextView) {
		sendButton.isEnabled = true
		configureSendButton()
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		let text: String
		
		if  textView.text.isEmpty {
			text = R.Strings.messagePlaceholder
			textView.textColor = .systemGray
		} else {
			text = ""
		}
		
		textView.text = text
	}
	
}

extension SendMessageView {
	
	private func configureSendButton() {
		let color = textView.text.isEmpty ? UIColor.systemGray : UIColor.systemBlue
		sendButton.setTitleColor(color, for: .normal)
		sendButton.isEnabled = !textView.text.isEmpty
	}
	
}
