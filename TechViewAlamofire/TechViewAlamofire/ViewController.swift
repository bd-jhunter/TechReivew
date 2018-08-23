//
//  ViewController.swift
//  TechViewAlamofire
//
//  Created by jhunter on 2018/8/8.
//  Copyright © 2018年 J.Hunter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 0))

        let titleView = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        titleView.setTitle("Tech view - Alamofire", for: .normal)
        titleView.setTitleColor(UIColor.blue, for: .normal)
        navigationItem.titleView = titleView
        navigationItem.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var requestType: RequestType
        switch indexPath.row {
        case 0:
            requestType = .get
        case 1:
            requestType = .get
        case 2:
            requestType = .get
        case 3:
            requestType = .get
        default:
            return
        }

        if let resultViewController = ResultViewController.resultViewController(with: requestType) {
            navigationController?.pushViewController(resultViewController, animated: true)
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusecell", for: indexPath)
        let label = cell.contentView.subviews.first { $0.tag == 100 }
        if let label = label as? UILabel {
            switch indexPath.row {
            case 0:
                label.text = "GET"
            case 1:
                label.text = "POST"
            case 2:
                label.text = "PUT"
            case 3:
                label.text = "DELETE"
            default:
                break
            }
        }

        return cell
    }
}

