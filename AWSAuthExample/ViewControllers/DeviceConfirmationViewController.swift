//
//  DeviceConfirmationViewController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/11/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class DeviceConfirmationViewController: UIViewController {
    private struct Constants {
        static let AWSCodeLength = 6
    }
    
    typealias Completion = (String, DeviceConfirmationViewController) -> Void
    
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var loadingIndicatorImageView: UIImageView!
    @IBOutlet private var continueLabel: UILabel!
    @IBOutlet private var resendCodeButton: UIButton!
    @IBOutlet private var entryCodeTextField: BorderedTextField!
    
    private let cognitoWrapper: CognitoWrapper
    private let completion: Completion
    private let cancelHandler: CancelHandler
    
    private var defaultContinueButtonFrame = CGRect.zero
    private var loadingUIIsVisible = false
    
    // MARK: - Init
    
    init(_ cognitoWrapper: CognitoWrapper, completion: @escaping Completion, andCancelHandler cancelHandler: @escaping CancelHandler) {
        self.cognitoWrapper = cognitoWrapper
        self.completion = completion
        self.cancelHandler = cancelHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setLeftBarButton(UIBarButtonItem(title: LocalizedString.cancel, style: .plain, target: self, action: #selector(cancel)), animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryCodeTextField.onEdit = textFieldDidChangeText
        entryCodeTextField.keyboardType = .numberPad
        continueButton.setBackgroundImage(ResizableImage.solid.image.withRenderingMode(.alwaysTemplate), for: .normal)
        resendCodeButton.setBackgroundImage(ResizableImage.blackBorder.image.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    // MARK: - TextField text checking
    
    private func textFieldDidChangeText(_ textField: BorderedTextField) {
        let enteredCode = (entryCodeTextField.text?.count ?? 0) == Constants.AWSCodeLength
        continueButton.isEnabled = enteredCode
        textField.borderColor = enteredCode ? .greenishTeal : .dustyLavender
    }
    
    // MARK: - Button response
    
    @IBAction private func continueButtonPressed() {
        guard let enteredCode = entryCodeTextField.text else {
            showDefaultErrorAlert()
            return
        }
        animateButton()
        completion(enteredCode, self)
    }
    
    private func animateButton() {
        let fadeAndShrinkDuration = 0.5
        let fadeInImageDuration = 0.15
        defaultContinueButtonFrame = continueButton.frame
        let disposableWidth = defaultContinueButtonFrame.width - defaultContinueButtonFrame.height
        let finalFrame = CGRect(x: defaultContinueButtonFrame.minX + disposableWidth / 2, y: defaultContinueButtonFrame.minY, width: defaultContinueButtonFrame.width - disposableWidth, height: defaultContinueButtonFrame.height)
        self.rotateImageView()
        UIView.animate(withDuration: fadeInImageDuration, delay: fadeAndShrinkDuration / 2, options: [.beginFromCurrentState], animations: {
            self.loadingIndicatorImageView.alpha = 1
        })
        UIView.animate(withDuration: fadeAndShrinkDuration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
            self.continueLabel.alpha = 0
            self.continueButton.frame = finalFrame
        })
    }
    
    @objc private func cancel() {
        cancelHandler()
    }
    
    // MARK: - Animation
    
    private func rotateImageView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            let loadingImageView = self.loadingIndicatorImageView!
            loadingImageView.transform = loadingImageView.transform.rotated(by: CGFloat(Double.pi / 2))
        }) { _ in
            guard self.loadingUIIsVisible else {
                return
            }
            self.rotateImageView()
        }
    }
    
    // MARK: - Resetting
    
    func showLoadingUI(_ show: Bool) {
        guard loadingUIIsVisible != show else {
            return
        }
        loadingUIIsVisible = show
        
        continueButton.isUserInteractionEnabled = !show
        resendCodeButton.isUserInteractionEnabled = !show
        
        if show {
            animateButton()
        } else {
            continueButton.layer.removeAllAnimations()
            continueButton.frame = defaultContinueButtonFrame
            continueLabel.alpha = 1
            loadingIndicatorImageView.alpha = 0
        }
    }
}
