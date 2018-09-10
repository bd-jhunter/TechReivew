//
//  ViewController.swift
//  TechReviewCoreData
//
//  Created by jhunter on 2018/9/7.
//  Copyright © 2018 jhunter. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    private lazy var loadingWindow: UIWindow = {
        let screenBound = UIScreen.main.bounds
        let containerWindow = UIWindow(frame: screenBound)
        containerWindow.backgroundColor = UIColor.white
        containerWindow.alpha = 0.35
        let contentView = loadingView
        containerWindow.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutAttribute.centerX, .centerY].map({
            NSLayoutConstraint(item: contentView, attribute: $0, relatedBy: .equal, toItem: containerWindow, attribute: $0, multiplier: 1, constant: 0)
        })
        constraints.append(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 197))
        constraints.append(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 127))
        containerWindow.addConstraints(constraints)

        return containerWindow
    }()
    
    private lazy var loadingView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 137))
        containerView.backgroundColor = UIColor.black
        containerView.alpha = 0.9
        containerView.layer.cornerRadius = 7.0

        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutAttribute.centerX, .centerY].map({
            NSLayoutConstraint(item: containerView, attribute: $0, relatedBy: .equal, toItem: activityIndicator, attribute: $0, multiplier: 1, constant: 0)
        })
        containerView.addConstraints(constraints)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        title.text = "Waiting, please..."
        title.textColor = UIColor.white
        containerView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        constraints = [NSLayoutAttribute.centerX].map({
            NSLayoutConstraint(item: containerView, attribute: $0, relatedBy: .equal, toItem: title, attribute: $0, multiplier: 1, constant: 0)
        })
        constraints.append(NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: activityIndicator, attribute: .bottom, multiplier: 1, constant: 12))
        containerView.addConstraints(constraints)

        return containerView
    }()
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Private methods
    private func setupUI() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.rowHeight = 54.0
    }
    
    private func resetCoreData() {
        startLoading(start: true)
        CoreDataUtil.shared.resetCoreData { [weak self] cost in
            DispatchQueue.main.async {
                self?.startLoading(start: false)
            }
        }
    }
    
    private func insertCoreData() {
        startLoading(start: true)
        CoreDataUtil.shared.testInsertOperation { [weak self] cost in
            DispatchQueue.main.async {
                self?.startLoading(start: false)
                self?.toast(message: "Insert cost is \(cost) ms")
            }
        }
    }
    
    private func queryCoreData() {
        startLoading(start: true)
        CoreDataUtil.shared.testQueryOperation { [weak self] cost in
            DispatchQueue.main.async {
                self?.startLoading(start: false)
                self?.toast(message: "Query cost is \(cost) ms")
            }
        }
    }
    
    private func updateCoreData() {
        startLoading(start: true)
        CoreDataUtil.shared.testUpdateOperation { [weak self] cost in
            DispatchQueue.main.async {
                self?.startLoading(start: false)
                self?.toast(message: "Update cost is \(cost) ms")
            }
        }
    }
    
    private func startLoading(start: Bool) {
//        loadingWindow.isHidden = !start
//        if start {
//            activityIndicator.startAnimating()
//        } else {
//            activityIndicator.stopAnimating()
//        }
    }
    
    private func toast(message: String) {
        let hud = MBProgressHUD(for: view) ?? MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = message
        hud.detailsLabel.text = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            hud.hide(animated: true)
        }
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                insertCoreData()
            case 1:
                queryCoreData()
            case 2:
                updateCoreData()
            case 3:
                resetCoreData()
            default:
                break
            }
        } else {
            
        }
    }
}

