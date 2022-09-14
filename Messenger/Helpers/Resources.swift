import UIKit

// MARK: - Resources

enum R {
	
	// MARK: - Strings
	
	enum Strings {
		
		static let messagePlaceholder = "Сообщение"
		static let sendButtonTitle = "Отправить"
		
		enum Chat {
			static let navigationTitle = "Тестовое задание"
		}
		
		enum MessageDetails {
			static let messageTitle = "Сообщение:\n"
			static let sendTimeTitle = "Время отправки:\n14.09.2022 - 22:00"
			
			static let deleteMessageButtonTitle = "Удалить сообщение"
		}
		
		enum Link: String {
			case imageURL = "https://involta.ru/images/logos/logo.png"
			case chatURL = "https://numia.ru/api/getMessages"
		}

	}
	
	// MARK: - Fonts
	
	enum Fonts {
		static func helveticaRegular(with size: CGFloat) -> UIFont {
			UIFont(name: "Helvetica", size: size) ?? UIFont()
		}
	}
	
}
