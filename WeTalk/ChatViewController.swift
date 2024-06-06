//
//  ChatViewController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/10/8.
//

import SDWebImage
import UIKit

class ChatViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NavigationBarViewDelegate {
    
    private var friendInfo: FriendInfo?
    private var hasScrolledToBottom: Bool = false
    
    // MARK: Life Cycle
    init(friendInfo: FriendInfo) {
        super.init(nibName: nil, bundle: nil)
        self.friendInfo = friendInfo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        self.view.addSubview(self.navigationBarView)
        self.view.addSubview(self.inputBarView)
        self.view.addSubview(self.tableView)
        var statusBarHeight: CGFloat = 0
        if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
            statusBarHeight = statusBarManager.statusBarFrame.height
        }
        NSLayoutConstraint.activate([
            self.navigationBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.navigationBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusBarHeight),
            self.navigationBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.navigationBarView.heightAnchor.constraint(equalToConstant: 44),
            self.inputBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.inputBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.inputBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.inputBarView.heightAnchor.constraint(equalToConstant: 56+34),
            self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.navigationBarView.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.inputBarView.topAnchor),
            self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hasScrolledToBottom = true
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.hasScrolledToBottom {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                if (self.friendInfo?.messages.count ?? 0) > 0 {
                    let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
        return self.friendInfo?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.friendInfo!.messages[indexPath.row].type == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendMessageCell", for: indexPath) as! FriendMessageCell
            cell.update(avatarUrl: self.friendInfo!.avatarUrl, message: self.friendInfo!.messages[indexPath.row].text)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelfMessageCell", for: indexPath) as! SelfMessageCell
            cell.update(avatarUrl: self.friendInfo!.avatarUrl, message: self.friendInfo!.messages[indexPath.row].text)
            return cell
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: NavigationBarViewDelegate
    func didClickNavigationBarLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didClickNavigationBarFirstRightButton() {
        // TODO: 点击更多按钮
    }
    
    // MARK: Getter
    private lazy var navigationBarView: FriendNavigationBar = {
        let view = FriendNavigationBar(title: friendInfo!.displayName())
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var inputBarView: InputBarView = {
        let inputView = InputBarView()
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        //        tableView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        tableView.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        tableView.register(FriendMessageCell.self, forCellReuseIdentifier: "FriendMessageCell")
        tableView.register(SelfMessageCell.self, forCellReuseIdentifier: "SelfMessageCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}

class InputBarView : UIView {
    
    // MARK: Life Cycle
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 0.9)
        self.addSubview(self.topLineView)
        self.addSubview(self.voiceButton)
        self.addSubview(self.emotionButton)
        self.addSubview(self.moreButton)
        self.addSubview(self.textField)
        NSLayoutConstraint.activate([
            self.topLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.topLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.topLineView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.topLineView.heightAnchor.constraint(equalToConstant: 0.5),
            self.voiceButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.voiceButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            self.voiceButton.widthAnchor.constraint(equalToConstant: 32),
            self.voiceButton.heightAnchor.constraint(equalToConstant: 32),
            self.textField.leftAnchor.constraint(equalTo: self.voiceButton.rightAnchor, constant: 8),
            self.textField.centerYAnchor.constraint(equalTo: self.voiceButton.centerYAnchor),
            self.textField.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -48-88),
            self.textField.heightAnchor.constraint(equalToConstant: 40),
            self.emotionButton.leftAnchor.constraint(equalTo: self.textField.rightAnchor, constant: 8),
            self.emotionButton.centerYAnchor.constraint(equalTo: self.voiceButton.centerYAnchor),
            self.emotionButton.widthAnchor.constraint(equalToConstant: 32),
            self.emotionButton.heightAnchor.constraint(equalToConstant: 32),
            self.moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.moreButton.centerYAnchor.constraint(equalTo: self.voiceButton.centerYAnchor),
            self.moreButton.widthAnchor.constraint(equalToConstant: 32),
            self.moreButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Getter
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var voiceButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "input_bar_voice"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emotionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "input_bar_emotion"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "input_bar_more"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
}

class BaseMessageCell : UITableViewCell {
    
    // MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        //        self.contentView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi))
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.cornerImageView)
        self.contentView.addSubview(self.messageTextView)
        self.configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Custom
    func configureCell() {}
    
    func update(avatarUrl: String?, message: String) {
        self.avatarImageView.sd_setImage(with: URL(string: avatarUrl ?? "error_url"), placeholderImage: UIImage(named: "default_avatar"))
        self.messageTextView.text = message
    }
    
    // MARK: Getter
    internal lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "default_avatar"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal lazy var cornerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 4
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "PingFangSC-Regular", size: 17)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
}

class FriendMessageCell : BaseMessageCell {
    
    // MARK: Custom
    override func configureCell() {
        self.cornerImageView.image = UIImage(named: "chat_left_corner")
        self.messageTextView.backgroundColor = .white
        NSLayoutConstraint.activate([
            self.avatarImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            self.cornerImageView.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 4),
            self.cornerImageView.centerYAnchor.constraint(equalTo: self.avatarImageView.centerYAnchor),
            self.cornerImageView.widthAnchor.constraint(equalToConstant: 26),
            self.cornerImageView.heightAnchor.constraint(equalToConstant: 22),
            self.messageTextView.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 10),
            self.messageTextView.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: -16),
            self.messageTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.messageTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            self.messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
        ])
    }
}

class SelfMessageCell : BaseMessageCell {
    
    // MARK: Custom
    override func configureCell() {
        self.cornerImageView.image = UIImage(named: "chat_right_corner")
        self.messageTextView.backgroundColor = UIColor(red: 0.55, green: 0.91, blue: 0.5, alpha: 1)
        NSLayoutConstraint.activate([
            self.avatarImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            self.cornerImageView.rightAnchor.constraint(equalTo: self.avatarImageView.leftAnchor, constant: -4),
            self.cornerImageView.centerYAnchor.constraint(equalTo: self.avatarImageView.centerYAnchor),
            self.cornerImageView.widthAnchor.constraint(equalToConstant: 26),
            self.cornerImageView.heightAnchor.constraint(equalToConstant: 22),
            self.messageTextView.rightAnchor.constraint(equalTo: self.avatarImageView.leftAnchor, constant: -10),
            self.messageTextView.leftAnchor.constraint(greaterThanOrEqualTo: self.contentView.leftAnchor, constant: 16),
            self.messageTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.messageTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            self.messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
        ])
    }
}
