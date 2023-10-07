//
//  ChatsViewController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/9/29.
//

import UIKit

class ChatsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NavigationBarViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        self.view.addSubview(self.navigationBarView)
        self.view.addSubview(self.tableView)
        var statusBarHeight: CGFloat = 0
        if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
            statusBarHeight = statusBarManager.statusBarFrame.height
        }
        NSLayoutConstraint.activate([
            self.navigationBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.navigationBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusBarHeight),
            self.navigationBarView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            self.navigationBarView.heightAnchor.constraint(equalToConstant: 44),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.navigationBarView.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func didClickNavigationBarLeftButton() {
        // TODO
    }
    
    func didClickNavigationBarFirstRightButton() {
        // TODO
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatCell.self), for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    private lazy var navigationBarView: HomeNavigationBarView = {
        let view = HomeNavigationBarView(title: "微信")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatCell.self, forCellReuseIdentifier: String(describing: ChatCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}

class ChatCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.redDotLabel)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.summaryLabel)
        self.contentView.addSubview(self.timeLabel)
        NSLayoutConstraint.activate([
            self.avatarImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 48),
            self.titleLabel.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 12),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 14),
            self.redDotLabel.rightAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: -7),
            self.redDotLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            self.summaryLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.summaryLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 38),
            self.timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 19)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithModel(model: ChatCellModel) {
        if let avatarUrl = model.avatarUrl {
            // TODO: 加载头像
        }
        
    }
    
    private lazy var avatarImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "default_avatar"))
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 4
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var redDotLabel: UILabel = {
        let label = UILabel()
        label.text = "8"
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 9
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangSC-Light", size: 12)
        label.backgroundColor = UIColor(red: 0.98, green: 0.318, blue: 0.318, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "廖蕴杰"
        label.textColor = .black.withAlphaComponent(0.9)
        label.font = UIFont(name: "PingFangSC-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "这是一条测试消息"
        label.textColor = .black.withAlphaComponent(0.3)
        label.font = UIFont(name: "PingFangSC-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:21"
        label.textColor = .black.withAlphaComponent(0.3)
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
}

struct ChatCellModel {
    let avatarUrl: String?
    let unreadCount: UInt
    let title: String
    let summary: String
    let timestamp: Date
}
