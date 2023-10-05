//
//  NavigationBarView.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/10/5.
//

import UIKit

@objc protocol NavigationBarViewDelegate: AnyObject {
    @objc optional func didClickNavigationBarLeftButton()
    @objc optional func didClickNavigationBarFirstRightButton()
    @objc optional func didClickNavigationBarSecondRightButton()
}

class BaseNavigationBarView: UIView {
    
    weak var delegate: NavigationBarViewDelegate?
    
    public var statusBarHeight: CGFloat = 0
    
    init() {
        if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
            statusBarHeight = statusBarManager.statusBarFrame.height
        }
        super.init(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height:44))
        self.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        self.addSubview(self.leftButton)
        self.addSubview(self.firstRightButton)
        self.addSubview(self.secondRightButton)
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.leftButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.firstRightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.firstRightButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.secondRightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.secondRightButton.rightAnchor.constraint(equalTo: self.firstRightButton.leftAnchor, constant: -16),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLeftButtonImage(imageName: String) {
        self.leftButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func setFirstRightButtonImage(imageName: String) {
        self.firstRightButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func setSecondRightButtonImage(imageName: String) {
        self.secondRightButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func setLabelTitle(title: String) {
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
    }
    
    @objc func didClickLeftButton() {
        delegate?.didClickNavigationBarLeftButton?()
    }
    
    @objc func didClickFirstRightButton() {
        delegate?.didClickNavigationBarFirstRightButton?()
    }
    
    @objc func didClickSecondRightButton() {
        delegate?.didClickNavigationBarSecondRightButton?()
    }
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 12, height: 24)
        button.addTarget(self, action: #selector(didClickLeftButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var firstRightButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 12, height: 24)
        button.addTarget(self, action: #selector(didClickFirstRightButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var secondRightButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 12, height: 24)
        button.addTarget(self, action: #selector(didClickSecondRightButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "PingFangSC-Medium", size: 17)
        label.center = self.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

class HomeNavigationBarView: BaseNavigationBarView {
    
    init(title: String) {
        super.init()
        self.setFirstRightButtonImage(imageName: "more")
        self.setSecondRightButtonImage(imageName: "search")
        self.setLabelTitle(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
