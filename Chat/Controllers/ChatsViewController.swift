//
//  ChatsViewController.swift
//  Chat
//
//  Created by Edward Kim on 2021-01-20.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ChatsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let emptyChatsLabel: UILabel = {
        let emptyChatsLabel = UILabel()
        emptyChatsLabel.text = "No Chats"
        emptyChatsLabel.textAlignment = .center
        emptyChatsLabel.textColor = .gray
        emptyChatsLabel.font = .systemFont(ofSize: 20, weight: .medium)
        emptyChatsLabel.isHidden = true
        return emptyChatsLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapCompose))
        view.addSubview(tableView)
        view.addSubview(emptyChatsLabel)
        initTableView()
        fetchChats()
    }
    
    @objc private func tapCompose() {
        let viewController = NewChatViewController()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        present(navigationViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let viewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: false)
        }
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchChats() {
        tableView.isHidden = false
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = ChatViewController()
        viewController.title = "Albert Kho"
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}
