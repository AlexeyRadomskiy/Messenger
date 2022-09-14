import UIKit

protocol ChatViewProtocol: BaseViewProtocol {
	func updateTableView(isScrollToBottom: Bool)
    func showAlert()
}

class ChatViewController: BaseViewController {
    
    // MARK: - Properties
    
    var presenter: ChatPresenterProtocol {
        basePresenter as! ChatPresenterProtocol
    }
	
	private let activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.style = .large
		
		return activityIndicator
	}()
	
	private let navigationView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemGroupedBackground
		
		return view
	}()
	
	private let navigationTitle: UILabel = {
		let label = UILabel()
		label.text = R.Strings.Chat.navigationTitle
		label.textColor = .label
		label.font = R.Fonts.helveticaRegular(with: 17.0)
		
		return label
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 0.0, right: 0.0)
		tableView.register(MessageTableViewCell.self)
		tableView.register(UserTableViewCell.self)
		tableView.showsVerticalScrollIndicator = false
		tableView.keyboardDismissMode = .onDrag
		tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
		
		return tableView
	}()
	
	private let sendView = SendMessageView()
	
	private var image: UIImage? {
		UIImage(data: presenter.imageData ?? Data())
	}
	
	private lazy var bottomConstraint = NSLayoutConstraint(
		item: sendView,
		attribute: .bottom,
		relatedBy: .equal,
		toItem: view,
		attribute: .bottom,
		multiplier: 1.0,
		constant: -16.0
	)
    
    // MARK: - Lifecycle Methods
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.navigationBar.isHidden = false
	}
	
	deinit {
		removeKeyboardNotifications()
	}
    
}

// MARK: - View Protocol Implementation

extension ChatViewController: ChatViewProtocol {
	
	func updateTableView(isScrollToBottom: Bool) {
		tableView.reloadData()
		activityIndicator.stopAnimating()
		if isScrollToBottom {
			scrollToBottom()
		}
	}
    
	func showAlert() {
		let alertController = UIAlertController(
			title: "Ошибка сети",
			message: "Попробовать получить данные еще раз?",
			preferredStyle: .alert
		)
		
		let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
		let repeatFetchDataAction = UIAlertAction(
			title: "Повторить",
			style: .default
		) { action in
			self.activityIndicator.startAnimating()
			self.presenter.downloadMessages()
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(repeatFetchDataAction)
		
		present(alertController, animated: true)
	}
	
}

// MARK: - Setup Subviews

extension ChatViewController {
    
    override func embedSubviews() {
		view.addSubviews(navigationView, tableView, sendView, activityIndicator)
		navigationView.addSubviews(navigationTitle)
    }
    
    override func setSubviewsConstraints() {
		NSLayoutConstraint.activate([
			navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			navigationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			navigationView.heightAnchor.constraint(equalToConstant: 40.0),
			
			navigationTitle.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor),
			navigationTitle.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
			
			tableView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: sendView.topAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			sendView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			sendView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
		view.addConstraint(bottomConstraint)
    }
    
}

// MARK: - UITableViewDataSource
// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row < presenter.localMessagesCount {
			let cell: UserTableViewCell = tableView.dequeueReusableCell(for: indexPath)
			cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
			cell.configure(with: presenter.getTextForCell(at: indexPath), image: image)
			cell.messageTapHandler = { [weak self] in
				self?.presenter.messageDidTap(at: indexPath)
			}
			
			return cell
		}
		
		let cell: MessageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
		cell.configure(with: presenter.getTextForCell(at: indexPath), image: image)
		cell.messageTapHandler = { [weak self] in
			self?.presenter.messageDidTap(at: indexPath)
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == presenter.messages.count - 5 {
			presenter.downloadMessages()
		}
	}
	
}

// MARK: - Private Methods

extension ChatViewController {
	
	override func configureAppearance() {
		super.configureAppearance()
		
		navigationController?.interactivePopGestureRecognizer?.delegate = self
		navigationController?.navigationBar.tintColor = .label
		
		tableView.dataSource = self
		tableView.delegate = self

		registerForKeyboardNotifications()
		activityIndicator.startAnimating()
	}
	
	override func addActions() {
		super.addActions()
		
		sendView.sendButtonTapHandler = { [weak self] text in
			self?.presenter.sendButtonDidTap(with: text)
			self?.animateTableView()
		}
		
		sendView.textViewStartEditing = { [weak self] in
			self?.scrollToBottom()
		}
	}
	
	private func scrollToBottom() {
		tableView.scrollToRow(
			at: IndexPath(row: 0, section: 0),
			at: .bottom,
			animated: true
		)
	}
	
	private func animateTableView() {
		updateTableView(isScrollToBottom: false)
		tableView.visibleCells.first?.alpha = 0.0
		tableView.visibleCells.first?.transform = CGAffineTransform(translationX: 0.0, y: -4.0)
		UIView.animate(
			withDuration: 1.0,
			delay: 0.0,
			usingSpringWithDamping: 0.8,
			initialSpringVelocity: 0,
			options: .curveEaseInOut) {
				self.tableView.visibleCells.first?.alpha = 1.0
				self.tableView.visibleCells.first?.transform = CGAffineTransform.identity
			}
	}
	
}

// MARK: - UIGestureRecognizerDelegate

extension ChatViewController: UIGestureRecognizerDelegate {
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		
		return navigationController?.viewControllers.count ?? 0 > 1
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		
		return true
	}
}

// MARK: - Setup KeyboardNotifications

extension ChatViewController {
	
	private func registerForKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	private func removeKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc private func keyboardWillShow(_ notification: Notification) {
		let userInfo = notification.userInfo
		let keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		bottomConstraint.constant = -keyboardFrameSize.height
		
		UIView.animate(withDuration: 0.5, animations: {
			self.view.layoutIfNeeded()
			self.updateTableView(isScrollToBottom: false)
		})
	}
	
	@objc private func keyboardWillHide() {
		bottomConstraint.constant = -16.0
		
		UIView.animate(withDuration: 0.5, animations: {
			self.view.layoutIfNeeded()
			self.updateTableView(isScrollToBottom: false)
		})
	}
	
}
