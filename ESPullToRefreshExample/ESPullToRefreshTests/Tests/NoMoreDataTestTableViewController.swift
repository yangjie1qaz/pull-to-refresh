//
//  NoMoreDataTestTableViewController.swift
//  ESPullToRefreshExample
//
//  Created by Jyggalag on 2017/7/24.
//  Copyright © 2017年 egg swift. All rights reserved.
//

import UIKit

class NoMoreDataTestTableViewController: UITableViewController {
    var page = 0, numRowsPerPage = 5
    var noMoreData = true

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.es.addPullToRefresh(handler: refresh)
        tableView.es.addInfiniteScrolling(handler: loadMore)

        dispatchSafeAfter(0.5) { [weak self] in
            self?.tableView.es.startPullToRefresh()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return page * numRowsPerPage
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = String(format: "%02ld", indexPath.row)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height / 8.0).rounded()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier, segueId == "ShowOptions" else { return }

		let optionsVc = segue.destination as! NoMoreDataTestOptionsViewController
        optionsVc.noMoreData = noMoreData
        optionsVc.numRowsPerPage = numRowsPerPage
        optionsVc.delegate = self
    }

    func refresh() {
        dispatchSafeAfter(1.0) { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.tableView.es.stopPullToRefresh()

            strongSelf.page = 1
			strongSelf.tableView.reloadData()

            if strongSelf.noMoreData {
                strongSelf.tableView.es.noticeNoMoreData()
            } else {
                strongSelf.tableView.es.resetNoMoreData()
            }
        }
    }

    func loadMore() {
        dispatchSafeAfter(1.0) { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.tableView.es.stopLoadingMore()

            strongSelf.page += 1
			strongSelf.tableView.reloadData()

            if strongSelf.noMoreData {
                strongSelf.tableView.es.noticeNoMoreData()
            } else {
                strongSelf.tableView.es.resetNoMoreData()
            }
        }
    }
}

extension NoMoreDataTestTableViewController: NoMoreDataTestOptionsDelegate {
    func didSetNoMoreData(_ value: Bool) {
        noMoreData = value
    }

    func didSetNumRowsPerPage(_ value: Int) {
        numRowsPerPage = value
    }
}

protocol NoMoreDataTestOptionsDelegate: class {
    func didSetNoMoreData(_ value: Bool)
    func didSetNumRowsPerPage(_ value: Int)
}

class NoMoreDataTestOptionsViewController: UIViewController {
    var noMoreData: Bool!
    var numRowsPerPage: Int!
    var delegate: NoMoreDataTestOptionsDelegate!

    @IBOutlet private weak var noMoreDataSwitch: UISwitch!
    @IBOutlet private weak var numRowsPerPageSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        noMoreDataSwitch.isOn = noMoreData

        switch numRowsPerPage {
        case 0:
            numRowsPerPageSegmentedControl.selectedSegmentIndex = 0
        case 5:
            numRowsPerPageSegmentedControl.selectedSegmentIndex = 1
        default:
            numRowsPerPageSegmentedControl.selectedSegmentIndex = 2
        }
    }

    @IBAction private func didNoMoreDataSwitchValueChanged(_ sender: UISwitch) {
        noMoreData = sender.isOn
        delegate.didSetNoMoreData(noMoreData)
    }

    @IBAction private func didNumRowsPerPageSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            numRowsPerPage = 0
        case 1:
            numRowsPerPage = 5
        default:
            numRowsPerPage = 10
        }
        delegate.didSetNumRowsPerPage(numRowsPerPage)
    }
}
