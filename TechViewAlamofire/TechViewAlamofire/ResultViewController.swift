//
//  ResultViewController.swift
//  TechViewAlamofire
//
//  Created by jhunter on 2018/8/9.
//  Copyright © 2018年 HCC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum RequestType {
    case get
    case post
    case put
    case delete

    var endpoint: String? {
        switch self {
        case .get:
            return "https://jsonplaceholder.typicode.com/comments?postId=1"
        case .post:
            return "https://jsonplaceholder.typicode.com/posts"
        case .put:
            return "https://jsonplaceholder.typicode.com/posts/1"
        case .delete:
            return "https://jsonplaceholder.typicode.com/posts/1"
        }
    }

    var title: String? {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

class ResultViewController: UIViewController {

    // MARK: - Properties
    var requestType: RequestType?
    private var alamofireManager: Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        var serverTrustPolicies = [String: ServerTrustPolicy]()

        let urls = ["https://jsonplaceholder.typicode.com/", "https://httpbin.org/"]
        let domains = urls.compactMap({ URL(string: $0)?.host })
        for domain in domains {
            serverTrustPolicies[domain] = .disableEvaluation
        }

        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
    private var request: Request? {
        guard let requestType = requestType, let endpoint = requestType.endpoint else { return nil }
        switch requestType {
        case .get:
            return Alamofire.request(endpoint)
        case .post:
            var urlRequest = URLRequest(url: URL(string: endpoint)!)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            var parameters: Parameters = [:]
            parameters["Topic"] = "Tech view - Alamofire"
            parameters["Category"] = "iOS Network Framework"
            urlRequest = (try? JSONEncoding.default.encode(urlRequest, with: parameters)) ?? urlRequest
            return alamofireManager.request(urlRequest)
        case .put:
            var urlRequest = URLRequest(url: URL(string: endpoint)!)
            urlRequest.httpMethod = HTTPMethod.put.rawValue
            var parameters: Parameters = [:]
            parameters["id"] = 1
            parameters["title"] = "foo"
            parameters["body"] = "bar"
            parameters["userId"] = 1
            urlRequest = (try? JSONEncoding.default.encode(urlRequest, with: parameters)) ?? urlRequest
            return alamofireManager.request(urlRequest)
        case .delete:
            var urlRequest = URLRequest(url: URL(string: endpoint)!)
            urlRequest.httpMethod = HTTPMethod.delete.rawValue
            return alamofireManager.request(urlRequest)
        }
    }
    private var headers: [String: String] = [:]
    private var body: String?
    private let dispatchQueue = DispatchQueue.global(qos: .default)

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    class func resultViewController(with requestType: RequestType) -> ResultViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let instance = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
            instance.requestType = requestType
            return instance
        } else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadingView.layer.cornerRadius = 7.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 0))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let titleView = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        titleView.setTitle(requestType?.title, for: .normal)
        titleView.setTitleColor(UIColor.blue, for: .normal)
        navigationItem.titleView = titleView
        navigationItem.title = ""
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    private func loadData() {
        guard let request  = request as? DataRequest else { return }

        showLoading(show: true)
        request.validate().responseJSON(queue: dispatchQueue) { [weak self] response in
            switch response.result {
            case .success(let value):
                self?.handleResponse(withValue: value, response: response)
            case .failure(let error):
                self?.handleError(error: error)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self?.showLoading(show: false)
            }
        }
    }

    private func handleResponse(withValue value: Any, response: DataResponse<Any>) {
        guard let response = response.response else { return }
        let json = JSON(value)

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            for (field, value) in response.allHeaderFields {
                strongSelf.headers["\(field)"] = "\(value)"
            }
            strongSelf.body = json.rawString()
            strongSelf.tableView.reloadData()
        }
    }

    private func handleError(error: Error) {

    }

    private func showLoading(show: Bool) {
        loadingView.isHidden = !show
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return headers.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.section {
            return 44.0
        } else {
            return 400.0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if 0 == section {
            return "Headers"
        } else {
            return "Body"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0 == indexPath.section {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
            let keyLabel = cell.contentView.subviews.first(where: { $0.tag == 100 })
            let valueLabel = cell.contentView.subviews.first(where: { $0.tag == 101 })
            if let keyLabel = keyLabel as? UILabel, let valueLabel = valueLabel as? UILabel {
                let key = headers.keys.sorted(by: <)[indexPath.row]
                let value = headers[key]
                keyLabel.text = key
                valueLabel.text = value
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "body", for: indexPath)
            let bodyLabel = cell.contentView.subviews.first(where: { $0.tag == 100 })
            if let bodyLabel = bodyLabel as? UITextView {
                bodyLabel.text = body
            }
            return cell
        }
    }
}
