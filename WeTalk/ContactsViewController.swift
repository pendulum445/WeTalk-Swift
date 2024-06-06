//
//  ContactsViewController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/10/9.
//

import SDWebImage
import UIKit

func firstLetterOf(string: String) -> String {
    let mutableString = NSMutableString(string: string) as CFMutableString
    CFStringTransform(mutableString, nil, kCFStringTransformMandarinLatin, false)
    CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
    let convertedString = mutableString as String
    let firstCharacter = convertedString.prefix(1)
    let regex = try! NSRegularExpression(pattern: "[a-zA-Z]", options: [])
    let isAlphabetic = regex.firstMatch(in: String(firstCharacter), options: [], range: NSRange(location: 0, length: firstCharacter.utf16.count)) != nil
    if !isAlphabetic {
        return "#"
    }
    return String(firstCharacter).uppercased()
}

class ContactsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NavigationBarViewDelegate {
    
    private var contactsModel: [String: [FriendInfo]] = [:]
    private var sectionLetters: [String] = []
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
                let friendInfos: [FriendInfo] = try await fetchData(from: "https://mock.apifox.cn/m1/2415634-0-default/contacts?userId={% mock 'qq' %}")
                DispatchQueue.main.async {
                    self.groupByFirstLetter(friendInfos: friendInfos)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: Custom
    private func groupByFirstLetter(friendInfos: [FriendInfo]) {
        for it in friendInfos {
            var firstLetter = firstLetterOf(string: it.displayName())
            if !("A" ... "Z").contains(firstLetter) {
                firstLetter = "#"
            }
            if self.contactsModel[firstLetter] == nil {
                self.contactsModel[firstLetter] = []
            }
            self.contactsModel[firstLetter]?.append(it)
        }
        for it in self.contactsModel.keys {
            self.sectionLetters.append(it)
        }
        self.sectionLetters.sort()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsModel[self.sectionLetters[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactCell.self), for: indexPath) as! ContactCell
        let key = self.sectionLetters[indexPath.section]
        let friendInfo = self.contactsModel[key]![indexPath.row]
        cell.update(avatarUrl: friendInfo.avatarUrl, title: friendInfo.displayName())
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contactsModel.keys.count
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ContactHeaderView(title: self.sectionLetters[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
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
        let view = HomeNavigationBarView(title: "通讯录")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ContactCell.self, forCellReuseIdentifier: String(describing: ContactCell.self))
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

class ContactCell : UITableViewCell {
    
    // MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.bottomLineView)
        NSLayoutConstraint.activate([
            self.avatarImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.avatarImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            self.titleLabel.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 12),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 180),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 24),
            self.bottomLineView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 68),
            self.bottomLineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.bottomLineView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -68),
            self.bottomLineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(avatarUrl: String?, title: String) {
        self.avatarImageView.sd_setImage(with: URL(string: avatarUrl ?? "error_url"), placeholderImage: UIImage(named: "default_avatar"))
        self.titleLabel.text = title
    }
    
    private func updateWith(image: UIImage, title: String) {
        self.avatarImageView.image = image
        self.titleLabel.text = title
    }
    
    // MARK: Getter
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "default_avatar"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.9)
        label.font = UIFont(name: "PingFangSC-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

class ContactHeaderView : UIView {
    
    // MARK: Life Cycle
    init(title: String) {
        super.init(frame: CGRectZero)
        self.addSubview(self.titleLabel)
        self.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.5)
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

struct FriendListResponse : Decodable {
    let code: Int
    let data: [FriendInfo]
}
