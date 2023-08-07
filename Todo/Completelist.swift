//
//  File.swift
//  Todo
//
//  Created by 김도윤 on 2023/08/01.
//
import UIKit

class CompletelistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CompletedTasksDelegate{
    
    // 스위치가 눌리면 여기로 옮기게 하는
    func didUpdateCompletedTasks(_ tasks: [[String]]) {
        self.completedTasks = tasks
        self.tableView.reloadData()
    }
    
    weak var completedTasksDelegate: CompletedTasksDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedTaskCell", for: indexPath)
        cell.textLabel?.text = completedTasks[indexPath.section][indexPath.row]
        return cell
    }
    
    
    var completedTasks: [[String]] = []
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped) // or .plain
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "completedTaskCell")
        
        self.view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCompletedTasksChanged(_:)), name: NSNotification.Name("CompletedTasksChanged"), object: nil)
        
        // 'clicktodo' 뷰 컨트롤러의 델리게이트로 자신을 설정
        
        if let todoVC = navigationController?.viewControllers.first as? clicktodo {
            todoVC.completedTasksDelegate = self
        }
        
        
        
    }
    
    @objc func handleCompletedTasksChanged(_ notification: NSNotification) {
        // fetch the completed tasks data and reload the table view
        if let completedData = UserDefaults.standard.array(forKey: "CompletedTasksData") as? [[String]] {
            self.completedTasks = completedData
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let completedData = UserDefaults.standard.array(forKey: "CompletedTasksData") as? [[String]] {
            self.completedTasks = completedData
        }
        self.tableView.reloadData()
    }
}

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return completedTasks.count
//    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return completedTasks[section].count
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "completedTaskCell", for: indexPath)
//        cell.textLabel?.text = completedTasks[indexPath.section][indexPath.row]
//        return cell
//    }

func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section \(section + 1)"
}

