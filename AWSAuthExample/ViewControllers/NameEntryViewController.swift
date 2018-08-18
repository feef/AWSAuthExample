//
//  NameEntryViewController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/8/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

class NameEntryViewController: UIViewController {
    typealias Completion = (String, String) -> Void
    
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var firstNameTextField: BorderedTextField!
    @IBOutlet private var lastNameTextField: BorderedTextField!
    
    private let completion: Completion
    private let cancelHandler: CancelHandler
    
    // MARK: - Init
    
    init(completion: @escaping Completion, andCancelHandler cancelHandler: @escaping CancelHandler) {
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
        firstNameTextField.onEdit = textFieldDidChangeText
        lastNameTextField.onEdit = textFieldDidChangeText
        continueButton.setBackgroundImage(ResizableImage.solid.image.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    // MARK: - TextField text checking
    
    private func textFieldDidChangeText(_ textField: BorderedTextField) {
        continueButton.isEnabled = firstNameTextField.text?.isEmpty == false && lastNameTextField.text?.isEmpty == false
        textField.borderColor = textField.text?.isEmpty == false ? .greenishTeal : .dustyLavender
    }
    
    // MARK: - Button response
    
    @IBAction private func continueTapped() {
        guard
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text
        else {
            // TODO: Log error, show error on screen. Should never get here.
            return
        }
        completion(firstName, lastName)
    }
    
    @objc private func cancel() {
        cancelHandler()
    }
}
