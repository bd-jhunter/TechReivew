//
//  ViewController.swift
//  TechReviewSnapKit
//
//  Created by jhunter on 2018/9/30.
//  Copyright © 2018 jhunter. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    // MARK: - Properties
    private var htmlString: String {
        return "致捷信消费金融有限公司：<br><br>本人现向贵公司申请消费贷款（“消费贷款”）并因业务需要授权如下：<br><br>"
            + "1. 本人同意并授权贵公司向中国人民银行个人信用信息基础数据库查询、获取和报送本人个人信息、个人信用信息以及其他反映本人信用状况的信息（包括不良信用记录，如有）。授权期限为自本人签署本授权书起至贷款合同（如有）终止。<br><br>"
            + "2. 本人理解并同意贵公司可以将部分与消费贷款有关的服务外包给业务合作伙伴（包括深圳捷信信驰咨询有限公司，即消费信贷合同项下的客户服务供应商）。<br><br>"
            + "3. 本人理解并同意贵公司可以将部分与消费贷款有关的服务外包给业务合作伙伴（包括深圳捷信信驰咨询有限公司，即消费信贷合同项下的客户服务供应商）。"

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // create views
        let titleLabel = titleLable()
        let contentView = self.contentView()
        let button = actionButton()
        
        view.addSubview(titleLabel)
        view.addSubview(contentView)
        view.addSubview(button)
        self.edgesForExtendedLayout = []
//        layoutWithSnapKit(titleLabel: titleLabel, contentView: contentView, button: button)
//        layoutWithAutoLayout(titleLabel: titleLabel, contentView: contentView, button: button)
        layoutWithAutoLayoutVFL(titleLabel: titleLabel, contentView: contentView, button: button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Private methods
    private func layoutWithSnapKit(titleLabel: UIView, contentView: UIView, button: UIView) {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(50)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.bottom.equalTo(button.snp.top).offset(-24)
        }
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            make.leading.equalTo(view.snp.leading).offset(70)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    private func layoutWithAutoLayout(titleLabel: UIView, contentView: UIView, button: UIView) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 50)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
        view.addConstraint(constraint)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        constraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 16)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
        view.addConstraint(constraint)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        constraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 24)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 70)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -30)
        view.addConstraint(constraint)
    }
    
    private func layoutWithAutoLayoutVFL(titleLabel: UIView, contentView: UIView, button: UIView) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[titleLabel]-(20)-|",
                                                         options: [],
                                                         metrics: nil,
                                                         views: ["titleLabel": titleLabel])
        NSLayoutConstraint.activate(constraints)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[contentView]-(20)-|",
                                                     options: [],
                                                     metrics: nil,
                                                     views: ["contentView": contentView])
        view.addConstraints(constraints)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(70)-[button]-(70)-|",
                                                     options: [],
                                                     metrics: nil,
                                                     views: ["button": button])
        view.addConstraints(constraints)

        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(50)-[titleLabel]-(16)-[contentView]-(24)-[button]-(30)-|",
                                                     options: [],
                                                     metrics: nil,
                                                     views: ["titleLabel": titleLabel, "contentView": contentView, "button": button])
        view.addConstraints(constraints)
    }
    
    private func titleLable() -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = "你好，我是标题。"
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .red
        titleLabel.textColor = .white
        return titleLabel
    }
    
    private func contentView() -> UIWebView {
        let contentView = UIWebView()
        contentView.delegate = self
        contentView.loadHTMLString(htmlString, baseURL: nil)
        contentView.isOpaque = false
        return contentView
    }
    
    private func actionButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        button.setTitle("我是按钮", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }
}

extension ViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {}
    
    func webViewDidFinishLoad(_ webView: UIWebView) {}
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {}
}
