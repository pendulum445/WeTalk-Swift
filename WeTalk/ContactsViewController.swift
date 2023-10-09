//
//  ContactsViewController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/10/9.
//

import UIKit

class ContactsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NavigationBarViewDelegate {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        self.view.addSubview(self.navigationBarView)
        self.view.addSubview(self.tableView)
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
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactCell.self), for: indexPath) as! ContactCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.updateWith(image: UIImage(named: "group_chat")!, title: "群聊")
            } else if indexPath.row == 1 {
                cell.updateWith(image: UIImage(named: "tag")!, title: "标签")
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        tableView.register(ContactCell.self, forCellReuseIdentifier: String(describing: ContactCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
    
    // MARK: Custom
    func updateWith(image: UIImage, title: String) {
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
