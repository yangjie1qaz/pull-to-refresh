//
//  ContentInsetTestTableViewController.swift
//  ESPullToRefreshExample
//
//  Created by Jyggalag on 2017/7/26.
//  Copyright © 2017年 egg swift. All rights reserved.
//

import UIKit

class ContentInsetTestTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 200.0, left: 0, bottom: 0, right: 0)

        tableView.es.addPullToRefresh(handler: refresh)
        tableView.es.addInfiniteScrolling(handler: loadMore)

        dispatchSafeAfter(0.5) { [weak self] in
            self?.tableView.es.startPullToRefresh()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }

    func refresh() {
        dispatchSafeAfter(1.0) { [weak self] in
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.reloadData()
        }
    }

    func loadMore() {
        dispatchSafeAfter(1.0) { [weak self] in
            self?.tableView.es.stopLoadingMore()
        }
    }
}
