//
//  ChatViewController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/10/8.
//

import UIKit

class ChatViewController : UIViewController, NavigationBarViewDelegate {
    
    var friendInfo: FriendInfo?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var statusBarHeight: CGFloat = 0
        if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
            statusBarHeight = statusBarManager.statusBarFrame.height
        }
        NSLayoutConstraint.activate([
            self.navigationBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.navigationBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusBarHeight),
            self.navigationBarView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            self.navigationBarView.heightAnchor.constraint(equalToConstant: 44),
            self.inputBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.inputBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.inputBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.inputBarView.heightAnchor.constraint(equalToConstant: 56+34)
        ])
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
        let view = FriendNavigationBar(title: (friendInfo?.noteName ?? friendInfo?.nickName) ?? "")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var inputBarView: InputBarView = {
        let inputView = InputBarView()
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
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
