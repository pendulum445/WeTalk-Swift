//
//  MainTabBarController.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/9/29.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [self.messageListViewController, self.contactsViewController, self.discoverViewController, self.profileViewController]
    }
    
    // MARK: Getter
    private lazy var messageListViewController: ChatListViewController = {
        let vc = ChatListViewController()
        vc.tabBarItem = UITabBarItem(title: "消息", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        return vc
    }()
    
    private lazy var contactsViewController: ContactsViewController = {
        let vc = ContactsViewController()
        vc.tabBarItem = UITabBarItem(title: "通讯录", image: UIImage(systemName: "person.2"), selectedImage: UIImage(systemName: "person.2.fill"))
        return vc
    }()
    
    private lazy var discoverViewController: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.tabBarItem = UITabBarItem(title: "发现", image: UIImage(systemName: "safari"), selectedImage: UIImage(systemName: "safari.fill"))
        return vc
    }()
    
    private lazy var profileViewController: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.tabBarItem = UITabBarItem(title: "我", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        return vc
    }()
}
