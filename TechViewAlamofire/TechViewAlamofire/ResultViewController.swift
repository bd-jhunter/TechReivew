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
    @IBOutlet private weak var textView: UITextView!
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
            strongSelf.textView.text = strongSelf.body
        }
    }

    private func handleError(error: Error) {

    }

    private func showLoading(show: Bool) {
        loadingView.isHidden = !show
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
