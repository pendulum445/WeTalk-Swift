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
}
