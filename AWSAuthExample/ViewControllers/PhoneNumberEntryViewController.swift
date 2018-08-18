//
//  PhoneNumberEntryViewController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/10/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

class PhoneNumberEntryViewController: UIViewController {
    typealias Completion = (UserLocale, String, PhoneNumberEntryViewController) -> Void
    
    private static let userLocaleSelectionControlWidth = CGFloat(82)
    private static let doneButtonHeight = CGFloat(42)
    
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var phoneNumberTextField: BorderedTextField!
    
    private let completion: Completion
    private let cancelHandler: CancelHandler
    private let userLocaleSelectionView = UserLocaleSelectionView()
    private let reachabilityMonitor = ReachabilityMonitor()
    private let dropDownAlertView: DropDownAlertView = {
        let dropDownAlertView = DropDownAlertView()
        DropDownAlertViewPopulator.populate(dropDownAlertView, with: .noNetwork)
        return dropDownAlertView
    }()
    
    private var shouldStopRotation = false
    private var userLocale = UserLocale.bestUserLocale()
    
    private lazy var doneButton: UIButton = {
        let buttonFrame = CGRect(origin: .zero, size: CGSize(width: 0, height: PhoneNumberEntryViewController.doneButtonHeight))
        let doneButton = UIButton(frame: buttonFrame)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        doneButton.titleLabel?.font = .buttonText
        doneButton.setTitle(LocalizedString.done, for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .greenishTealTwo
        return doneButton
    }()
    private lazy var pickerViewWrapper: PickerViewWrapper = {
        let sortedLocales = UserLocale.all.sorted { $0.name < $1.name }
        let selectedLocaleIndex: Array<UserLocale>.Index
        if let foundIndex = sortedLocales.index(of: userLocale) {
            selectedLocaleIndex = foundIndex
        } else {
            // TODO: Log error here, should never get here
            selectedLocaleIndex = 0
        }
        let pickerItems = sortedLocales.map { PickerItem.countryCode($0) }
        return PickerViewWrapper(pickerItems, currentlySelectedIndex: selectedLocaleIndex)
    }()
    
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
        
        // userLocaleSelectionView
        
        UserLocaleSelectionViewPopulator.populate(userLocaleSelectionView, with: userLocale)
        BorderedTextFieldPopulator.add(leftView: userLocaleSelectionView, to: phoneNumberTextField)
        userLocaleSelectionView.pickerButton.addTarget(self, action: #selector(showCountryCodePicker), for: .touchUpInside)
        
        // continueButton
        
        let buttonImage = ResizableImage.solid.image.withRenderingMode(.alwaysTemplate)
        continueButton.setBackgroundImage(buttonImage, for: .normal)
        continueButton.setBackgroundImage(buttonImage, for: .selected)
        let selectedButtonImage = #imageLiteral(resourceName: "msHorseshoeWhite").withRenderingMode(.alwaysOriginal)
        continueButton.setImage(selectedButtonImage, for: .selected)
        continueButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8)
        
        // phoneNumberTextField
        
        phoneNumberTextField.onEdit = textFieldDidChangeText
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.inputView = pickerViewWrapper.pickerView
        phoneNumberTextField.inputAccessoryView = doneButton
        phoneNumberTextField.textField.viewRectCaluclationBlock = { textField, side, bounds in
            guard side == .left else {
                return .zero
            }
            return CGRect(x: 0, y: -textField.bounds.height.truncatingRemainder(dividingBy: 2) / 2, width: PhoneNumberEntryViewController.userLocaleSelectionControlWidth, height: textField.bounds.height)
        }
        
        // Network monitoring
        
        reachabilityMonitor.onReachabilityChanged = { [weak self] reachable in
            guard let strongSelf = self else {
                return
            }
            
            let dropDownState: DropDownAlertView.State = reachable ? .hidden : .visible
            DropDownAlertViewDisplayer.update(strongSelf.dropDownAlertView, toState: dropDownState, in: strongSelf.view)
        }
    }
    
    // MARK: - View updating
    
    private func updateUserLocaleText() {
        userLocaleSelectionView.areaCodeLabel.text = userLocale.phoneNumberCode
        userLocaleSelectionView.pickerButton.setTitle(userLocale.abbreviation, for: .normal)
    }
    
    private func updateContinueButtonState() {
        var phoneNumberIsValid: Bool
        defer {
            continueButton.isEnabled = phoneNumberIsValid
            phoneNumberTextField.borderColor = phoneNumberIsValid ? .greenishTeal : .dustyLavender
        }
        
        guard let phoneNumber = phoneNumberTextField.text else {
            phoneNumberIsValid = false
            return
        }
        phoneNumberIsValid = userLocale.phoneNumberIsValid(phoneNumber)
    }
    
    private func resignInputViews() {
        phoneNumberTextField.textField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
    }
    
    // MARK: - TextField text checking
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateContinueButtonState()
    }
    
    private func textFieldDidChangeText(_ textField: BorderedTextField) {
        updateContinueButtonState()
    }
    
    // MARK: - Button response
    
    @objc private func showCountryCodePicker() {
        phoneNumberTextField.becomeFirstResponder()
        updateContinueButtonState()
    }
    
    @objc private func doneButtonPressed() {
        defer {
            resignInputViews()
            updateContinueButtonState()
        }
        guard case .countryCode(let userLocale) = pickerViewWrapper.currentlySelectedItem else {
            return
        }
        self.userLocale = userLocale
        updateUserLocaleText()
    }
    
    @IBAction private func continueTapped() {
        resignInputViews()
        guard let phoneNumber = phoneNumberTextField.text else {
            // TODO: Log error, show error on screen. Should never get here.
            return
        }
        completion(userLocale, phoneNumber, self)
    }
    
    @objc private func cancel() {
        cancelHandler()
    }
    
    // MARK: - Animation
    
    private func rotateImageView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            let loadingImageView = self.continueButton.imageView!
            loadingImageView.transform = loadingImageView.transform.rotated(by: CGFloat(Double.pi / 2))
        }) { _ in
            guard !self.shouldStopRotation else {
                self.shouldStopRotation = false
                return
            }
            self.rotateImageView()
        }
    }
    
    func showLoadingUI(_ show: Bool) {
        phoneNumberTextField.isUserInteractionEnabled = !show
        continueButton.isUserInteractionEnabled = !show
        shouldStopRotation = !show
        continueButton.isSelected = show
        if show {
            rotateImageView()
        }
    }
}

// MARK: - UITextFieldDelegate

extension PhoneNumberEntryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.containsOnlyDigits
    }
}
