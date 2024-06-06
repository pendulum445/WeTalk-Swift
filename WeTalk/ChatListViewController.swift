//
//  ChatListViewController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/9/29.
//

import SDWebImage
import UIKit

class ChatListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NavigationBarViewDelegate {
    
    private var chatListModel: [ChatCellModel] = []
    private var fetchDataFailed = false
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        self.view.addSubview(self.navigationBarView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicator)
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
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.activityIndicator.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.activityIndicator.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.activityIndicator.topAnchor.constraint(equalTo: self.navigationBarView.bottomAnchor),
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.activityIndicator.startAnimating()
        Task {
            do {
                let chatListModel: [ChatCellModel] = try await fetchData(from: "https://mock.apifox.cn/m1/2415634-0-default/chatList?userId={% mock 'qq' %}")
                DispatchQueue.main.async {
                    self.chatListModel = chatListModel
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                DispatchQueue.main.async {
                    self.fetchDataFailed = true
                }
            }
        }
    }
    
    // MARK: Custom
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatCell.self), for: indexPath) as! ChatCell
        cell.update(with: self.chatListModel[indexPath.row])
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.chatListModel[indexPath.row].unreadCount > 0 {
            self.chatListModel[indexPath.row].unreadCount = 0
            let cell = tableView.cellForRow(at: indexPath) as! ChatCell
            cell.updateUnreadRedDot(with: 0)
        }
        self.navigationController?.pushViewController(ChatViewController(friendInfo: self.chatListModel[indexPath.row].friendInfo), animated: true)
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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
}

enum DateDisplayFormat {
    case timeOnly, today, yesterday, thisWeek, monthDay, yearMonthDay
}

func getFriendlyDateText(from inputDateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: inputDateString) else {
        return "Invalid Date"
    }
    
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
    let sameYearAndWeek = calendar.isDateInToday(date) || (components.yearForWeekOfYear == calendar.component(.yearForWeekOfYear, from: now) && components.weekOfYear == calendar.component(.weekOfYear, from: now))
    
    var format: DateDisplayFormat
    
    if calendar.isDateInToday(date) {
        format = .timeOnly
    } else if calendar.isDateInYesterday(date) {
        format = .yesterday
    } else if sameYearAndWeek {
        format = .thisWeek
    } else if calendar.component(.year, from: date) == calendar.component(.year, from: now) {
        format = .monthDay
    } else {
        format = .yearMonthDay
    }
    
    switch format {
    case .timeOnly:
        dateFormatter.dateFormat = "HH:mm"
    case .today:
        return "今天"
    case .yesterday:
        return "昨天"
    case .thisWeek:
        dateFormatter.dateFormat = "E"
    case .monthDay:
        dateFormatter.dateFormat = "MM月dd日"
    case .yearMonthDay:
        dateFormatter.dateFormat = "y年MM月dd日"
    }
    
    return dateFormatter.string(from: date)
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
            self.titleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.timeLabel.leftAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 24),
            self.redDotLabel.rightAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: -7),
            self.redDotLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 7),
            self.redDotLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            self.redDotLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 42),
            self.redDotLabel.heightAnchor.constraint(equalToConstant: 18),
            self.summaryLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.summaryLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 38),
            self.summaryLabel.rightAnchor.constraint(lessThanOrEqualTo: self.timeLabel.leftAnchor, constant: -16),
            self.summaryLabel.heightAnchor.constraint(equalToConstant: 20),
            self.timeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
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
    func update(with model: ChatCellModel) {
        self.titleLabel.text = model.friendInfo.displayName()
        if model.friendInfo.messages.count > 0 {
            self.summaryLabel.text = model.friendInfo.messages[model.friendInfo.messages.count-1].text
            self.timeLabel.text = getFriendlyDateText(from: model.friendInfo.messages[model.friendInfo.messages.count-1].chatTime)
        } else {
            self.summaryLabel.text = ""
            self.timeLabel.text = ""
        }
        self.updateUnreadRedDot(with: model.unreadCount)
        self.avatarImageView.sd_setImage(with: URL(string: model.friendInfo.avatarUrl ?? "error_avartar_url"), placeholderImage: UIImage(named: "default_avatar"))
        self.contentView.setNeedsLayout()
    }
    
    func updateUnreadRedDot(with unreadCount: Int) {
        self.redDotLabel.text = unreadCount > 99 ? "99+" : String("\(unreadCount)")
        self.redDotLabel.isHidden = unreadCount == 0;
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
