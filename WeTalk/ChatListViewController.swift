//
//  ChatListViewController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/9/29.
//

import Alamofire
import UIKit

class ChatListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NavigationBarViewDelegate {
    
    private var chatCellModels: [ChatCellModel]?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        self.view.addSubview(self.navigationBarView)
        self.view.addSubview(self.tableView)
        self.requestData()
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
            self.navigationBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.navigationBarView.heightAnchor.constraint(equalToConstant: 44),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.navigationBarView.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    // MARK: Custom
    private func requestData() {
        AF.request("https://mock.apifox.cn/m1/2415634-0-default/chatList?userId={% mock 'qq' %}").responseDecodable(of: ChatListResponse.self) { response in
            if case .success(let chatListResponse) = response.result {
                self.chatCellModels = chatListResponse.data
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatCellModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatCell.self), for: indexPath) as! ChatCell
        cell.updateWithModel(model: self.chatCellModels![indexPath.row])
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController(friendInfo: self.chatCellModels![indexPath.row].friendInfo)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: NavigationBarViewDelegate
    func didClickNavigationBarFirstRightButton() {
        // TODO: 点击搜索按钮
    }
    
    func didClickNavigationBarSecondRightButton() {
        // TODO: 点击加号按钮
    }
    
    // MARK: Getter
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
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ChatCell.self, forCellReuseIdentifier: String(describing: ChatCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}

class ChatCell: UITableViewCell {
    
    // MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.redDotLabel)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.summaryLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.bottomLineView)
        NSLayoutConstraint.activate([
            self.avatarImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.avatarImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 48),
            self.titleLabel.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 12),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            self.titleLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -76-120),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 24),
            self.redDotLabel.rightAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: -7),
            self.redDotLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 7),
            self.redDotLabel.heightAnchor.constraint(equalToConstant: 18),
            self.summaryLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.summaryLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 38),
            self.summaryLabel.widthAnchor.constraint(equalTo: self.titleLabel.widthAnchor),
            self.summaryLabel.heightAnchor.constraint(equalToConstant: 20),
            self.timeLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.timeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 19),
            self.bottomLineView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 76),
            self.bottomLineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.bottomLineView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -76),
            self.bottomLineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Custom
    func updateWithModel(model: ChatCellModel) {
        self.titleLabel.text = model.friendInfo.displayName()
        self.summaryLabel.text = model.lastChat
        if model.unreadCount == 0 {
            self.redDotLabel.isHidden = true
            self.redDotLabel.text = "0"
        } else if model.unreadCount < 100 {
            self.redDotLabel.isHidden = false
            self.redDotLabel.text = String("\(model.unreadCount)")
        } else {
            self.redDotLabel.isHidden = false
            self.redDotLabel.text = "99+"
        }
        let text = self.redDotLabel.text! as NSString
        let textSize = text.size(withAttributes: [.font: self.redDotLabel.font!])
        NSLayoutConstraint.activate([
            self.redDotLabel.widthAnchor.constraint(equalToConstant: max(textSize.width+5*2, 18))
        ])
        self.timeLabel.text = self.getLastChatTimeText(lastChatTime: model.lastChatTime)
        self.timeLabel.sizeToFit()
        self.contentView.setNeedsLayout()
    }
    
    private func getLastChatTimeText(lastChatTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: lastChatTime) {
            let calendar = Calendar.current
            let now = Date()
            if calendar.isDateInToday(date) {
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: date)
            } else if calendar.isDateInYesterday(date) {
                return "昨天"
            } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
                dateFormatter.dateFormat = "E"
                return dateFormatter.string(from: date)
            } else {
                if calendar.isDate(date, equalTo: now, toGranularity: .year) {
                    dateFormatter.dateFormat = "MM月dd日"
                } else {
                    dateFormatter.dateFormat = "y年MM月dd日"
                }
                return dateFormatter.string(from: date)
            }
        } else {
            return "Invalid Date"
        }
    }
    
    // MARK: Getter
    private lazy var avatarImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "default_avatar"))
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 4
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var redDotLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 9
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangSC-Light", size: 12)
        label.backgroundColor = UIColor(red: 0.98, green: 0.318, blue: 0.318, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.9)
        label.font = UIFont(name: "PingFangSC-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.3)
        label.font = UIFont(name: "PingFangSC-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

struct ChatListResponse: Decodable {
    let code: Int
    let data: [ChatCellModel]
}

struct ChatCellModel: Decodable {
    let friendInfo: FriendInfo
    let lastChat: String?
    let lastChatTime: String
    let unreadCount: Int
}

class FriendInfo: Decodable {
    let avatarUrl: String?
    let nickName: String
    let noteName: String?
    let userId: String
    
    func displayName() -> String {
        return self.noteName ?? self.nickName;
    }
}
