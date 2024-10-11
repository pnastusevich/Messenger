//
//  ChatsViewController.swift
//  Messenger
//
//  Created by Паша Настусевич on 11.10.24.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class ChatsViewController: MessagesViewController {

    private var messages: [ModelMessage] = []
    private var messageListener: ListenerRegistration?
    
    private let user: ModelUser
    private let chat: ModelChat
    
    init(user: ModelUser, chat: ModelChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        title = chat.friendUserName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        messageListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageInputBar()
        messagesCollectionView.backgroundColor = .mainWhite
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { result in
            switch result {
                
            case .success(var message):
                if let url = message.downloadURL {
                    FirebaseStorageManager.shared.dowloadImage(url: url) { [weak self] result in
                        guard let self else { return }
                        switch result {
                            
                        case .success(let image):
                            message.image = image
                            self.insertNewMessage(message: message)
                        case .failure(let error):
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                } else {
                    self.insertNewMessage(message: message)
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    private func insertNewMessage(message: ModelMessage) {
        guard !messages.contains(message) else { return }
        
        messages.append(message)
        messages.sort()
        
        let isLatesMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatesMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.sourceType = .camera
//        } else {
//            picker.sourceType = .photoLibrary
//        }
        present(picker, animated: true)
    }
    
    private func sendPhoto(image: UIImage) {
        FirebaseStorageManager.shared.uploadImageMessage(photo: image, to: chat) { result in
            switch result {
            case .success(let url):
                var message = ModelMessage(user: self.user, image: image)
                message.downloadURL = url
                FirestoreStorageManager.shared.sendMessage(chat: self.chat, message: message) { result in
                    switch result {
                        
                    case .success():
                        self.messagesCollectionView.scrollToLastItem(animated: true)
                    case .failure(_):
                        self.showAlert(title: "Error", message: "Failed to send image message")
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
    
// MARK: - ConfigureMessageInputBar
extension ChatsViewController {
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .mainWhite
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 48)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
        configureCameraIcon()
    }
    
    func configureSendButton() {
        let buttonImage = UIImage(systemName: "paperplane.fill")?.withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = buttonImage
        configuration.baseForegroundColor = .mainBlue
        configuration.baseBackgroundColor = UIColor.systemPurple
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        messageInputBar.sendButton.configuration = configuration
        messageInputBar.sendButton.title = ""
        
        messageInputBar.sendButton.layer.cornerRadius = 24
        messageInputBar.sendButton.clipsToBounds = true
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
     
        messageInputBar.setRightStackViewWidthConstant(to: 48, animated: false)
        messageInputBar.middleContentViewPadding.right = 10
    }
    
    func configureCameraIcon() {
        
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .mainBlue
        let cameraImage = UIImage(systemName: "camera")?.withRenderingMode(.alwaysTemplate)
        cameraItem.image = cameraImage
        
        cameraItem.addTarget(self, action: #selector (cameraButtonPressed), for: .primaryActionTriggered)
        
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: true)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: true)
        
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
    }
}



// MARK: - MessagesDataSource
extension ChatsViewController: MessagesDataSource {
    var currentSender: any MessageKit.SenderType {
         Sender(senderId: user.id, displayName: user.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
         messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func cellTopLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.item % 5 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                                      attributes: [
                                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                        NSAttributedString.Key.foregroundColor: UIColor.darkGray
                                      ])
        } else {
            return nil
        }
    }
}
// MARK: - MessagesLayoutDelegate
extension ChatsViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        CGSize(width: 0, height: 8)
    }
    
    func cellTopLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.item % 5 == 0 {
            return 30
        } else {
            return 0
        }
    }
}
// MARK: - MessagesDisplayDelegate
extension ChatsViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? .white : .mainBlue
    }
    
    func textColor(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? .mainDark : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
        
    }
    
    func avatarSize(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        return .zero
    }
    
    func messageStyle(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        .bubble
    }
}
// MARK: - InputBarAccessoryViewDelegate
extension ChatsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.isEmpty else { return }
        let message = ModelMessage(user: user, content: text)
        FirestoreStorageManager.shared.sendMessage(chat: chat, message: message) { result in
            switch result {
                
            case .success():
                self.messagesCollectionView.scrollToLastItem(animated: true)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
      }
}

extension ChatsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        sendPhoto(image: image)
    }
}

extension UIScrollView {
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForBottom: CGFloat {
      let scrollViewHeight = bounds.height
      let scrollContentSizeHeight = contentSize.height
      let bottomInset = contentInset.bottom
      let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
      return scrollViewBottomOffset
    }
}
