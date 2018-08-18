//
//  LandingPageViewController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/8/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    @IBOutlet private var signUpButton: UIButton!
    @IBOutlet private var loginButton: UIButton!
    
    private let authenticationFlowController: AuthenticationFlowController
    
    // MARK: - Init
    
    init(with authenticationFlowController: AuthenticationFlowController) {
        self.authenticationFlowController = authenticationFlowController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.setBackgroundImage(ResizableImage.solid.image.withRenderingMode(.alwaysTemplate), for: .normal)
        loginButton.setBackgroundImage(ResizableImage.greenWhiteBorder.image, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        checkForJailbreak()
    }
    
    // MARK: - Jailbreak detection
    
    private func checkForJailbreak() {
        guard JailbreakDetector.isDeviceJailbroken() else {
            return
        }
        
        loginButton.isUserInteractionEnabled = false
        signUpButton.isUserInteractionEnabled = false
        let jailbreakAlert = UIAlertController(title: LocalizedString.jailbreakAlertTitle, message: LocalizedString.jailbreakAlertMessage, preferredStyle: .alert)
        let okayAction = UIAlertAction.okayAction { _ in
            exit(0)
        }
        jailbreakAlert.addAction(okayAction)
        let getInfoAction = UIAlertAction(title: LocalizedString.getInfo, style: .default) { _ in
            UIApplication.shared.open(ExternalURLs.defaultURLs.deviceSecurityHelp, options: [:]) { _ in
                exit(0)
            }
        }
        jailbreakAlert.addAction(getInfoAction)
        present(jailbreakAlert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction private func signUpTapped() {
        authenticationFlowController.startSignUpFlow()
    }
    
    @IBAction private func loginTapped() {
        authenticationFlowController.startLoginFlow()
    }
}
