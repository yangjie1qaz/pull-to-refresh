//
//  CodeTriggerRefreshingTableViewController.swift
//  ESPullToRefreshExample
//
//  Created by Jyggalag on 2017/9/6.
//  Copyright © 2017年 egg swift. All rights reserved.
//

import UIKit

class CodeTriggerRefreshingTableViewController: UITableViewController {
    var pageNumber = 0
    let pageSize = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.es.addPullToRefresh(handler: refresh)
        tableView.es.addInfiniteScrolling(handler: loadMore)

        dispatchSafeAfter(1.0) { [weak self] in
            self?.tableView.es.startPullToRefresh()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageSize * pageNumber
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let pageNumber = (indexPath.row / pageSize) + 1
        cell.textLabel?.text = String(pageNumber)
        return cell
    }

    func refresh() {
        dispatchSafeAfter(1.0) { [weak self] in
            guard let sSelf = self else { return }
            sSelf.pageNumber = 1
            sSelf.tableView.reloadData()
            sSelf.tableView.es.stopPullToRefresh()
        }
    }

    func loadMore() {
        dispatchSafeAfter(1.0) { [weak self] in
            guard let sSelf = self else { return }
            sSelf.pageNumber += 1
            sSelf.tableView.reloadData()
            sSelf.tableView.es.stopLoadingMore()
        }
    }

    @IBAction func didPressRefreshItem(_ sender: Any) {
        tableView.es.startPullToRefresh()
    }
}
