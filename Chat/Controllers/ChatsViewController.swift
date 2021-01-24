//
//  ChatsViewController.swift
//  Chat
//
//  Created by Edward Kim on 2021-01-20.
//

import UIKit
import FirebaseAuth
import JGProgressHUD


struct Chat {
    let id: String
    let name: String
    let otherUserEmail: String
    let recentMessage: RecentMessage
}

struct RecentMessage {
    let date: String
    let message: String
    let isRead: Bool
}

class ChatsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var chat = [Chat]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(ChatTableViewCell.self,
                           forCellReuseIdentifier: ChatTableViewCell.identifier)
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
        beginListeningForChat()
    }
    
    private func beginListeningForChat() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        DatabaseManager.shared.getChat(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let chat):
                guard !chat.isEmpty else {
                    return
                }
                
                self?.chat = chat
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("\(error)")
            }
        })
    }
    
    @objc private func tapCompose() {
        let viewController = NewChatViewController()
        viewController.completion = { [weak self] result in
            self?.createConversation(result: result)
        }
        let navigationViewController = UINavigationController(rootViewController: viewController)
        present(navigationViewController, animated: true)
    }
    
    private func createConversation(result: [String: String]) {
        guard let name = result["name"], let email = result["email"] else {
            return 
        }
        let viewController = ChatViewController(with: email, id: nil)
        viewController.isNewConversation = true
        viewController.title = name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
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
        return chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = chat[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier,
                                                 for: indexPath) as! ChatTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = chat[indexPath.row]
        let viewController = ChatViewController(with: model.otherUserEmail, id: model.id)
        viewController.title = model.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
