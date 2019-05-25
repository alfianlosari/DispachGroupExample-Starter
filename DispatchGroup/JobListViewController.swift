//
//  JobListViewController.swift
//  DispatchGroup
//
//  Created by Alfian Losari on 24/05/19.
//  Copyright © 2019 alfianlosari. All rights reserved.
//

import UIKit

class JobListViewController: UIViewController {
    
    @IBOutlet weak var downloadTableView: UITableView!
    @IBOutlet weak var completedTableView: UITableView!
    @IBOutlet weak var tasksCountSlider: UISlider!
    @IBOutlet weak var randomizeTimeSwitch: UISwitch!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var maxAsyncTasksSlider: UISlider!
    @IBOutlet weak var maxAsyncTasksLabel: UILabel!
    
    struct SimulationOption {
        var jobCount: Int
        var maxAsyncTasks: Int
        var isRandomizedTime: Bool
    }
    
    var option: SimulationOption! {
        didSet {
            updateJobLabel()
            updateMaxAsyncLabel()
        }
    }
    
    var downloadTasks = [DownloadTask]() {
        didSet {
            downloadTableView.reloadData()
        }
    }
    var completedTasks = [DownloadTask]() {
        didSet {
            completedTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        option = SimulationOption(jobCount: Int(tasksCountSlider.value), maxAsyncTasks: Int(maxAsyncTasksSlider.value), isRandomizedTime: randomizeTimeSwitch.isOn)
        downloadTableView.tableFooterView = UIView()
        completedTableView.tableFooterView = UIView()
        setupNavigationItems()
    }
    
    private func setupNavigationItems() {
        let startButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startOperation))
        navigationItem.rightBarButtonItem = startButtonItem
    }
    
    @objc func startOperation() {
        // TODO: Simulate download tasks with dispatch group and semaphore
    }
    
    @IBAction func maxAsyncTasksSliderchanged(_ sender: UISlider) {
        option.maxAsyncTasks = Int(sender.value)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        option.jobCount = Int(sender.value)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        option.isRandomizedTime = sender.isOn
    }
    
    private func updateMaxAsyncLabel() {
        maxAsyncTasksLabel.text = "\(option.maxAsyncTasks) Max Parallel Running Tasks"
    }
    
    private func updateJobLabel() {
        jobLabel.text = "\(option.jobCount) Tasks"
    }
    
    private func presentAlertWith(title: String , message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension JobListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === downloadTableView {
            return downloadTasks.count
        } else if tableView === completedTableView {
            return completedTasks.count
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProgressCell
        let task: DownloadTask
        if tableView === downloadTableView {
            task = downloadTasks[indexPath.row]
        } else if tableView === completedTableView {
            task = completedTasks[indexPath.row]
        } else {
            fatalError()
        }
        cell.configure(task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView === downloadTableView {
            return "Download Queue (\(downloadTasks.count))"
        } else if tableView === completedTableView {
            return "Completed (\(completedTasks.count))"
        } else {
            return nil
        }
    }

}
