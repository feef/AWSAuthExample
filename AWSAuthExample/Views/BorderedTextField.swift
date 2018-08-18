//
//  BorderedTextField.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/9/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

class BorderedTextField: UIView {
    private static let horizontalTextInset: CGFloat = 28
    
    private var internalInputView: UIView?
    
    override var inputView: UIView? {
        get {
            return internalInputView
        }
        set {
            internalInputView = newValue
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private var internalAccessoryView: UIView?
    
    override var inputAccessoryView: UIView? {
        get {
            return internalAccessoryView
        }
        set {
            internalAccessoryView = newValue
        }
    }
    
    private let borderImageView: UIImageView = {
        let image = ResizableImage.blackBorder.image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let textField: AccessoryFriendlyTextField = {
        let textField = AccessoryFriendlyTextField()
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            borderImageView.tintColor = borderColor
        }
    }
    
    @IBInspectable var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable var text: String? {
        return textField.text
    }
    
    @IBInspectable var textColor: UIColor = .black {
        didSet {
            textField.textColor = textColor
        }
    }
    
    @IBInspectable var font: UIFont = .bodyText {
        didSet {
            textField.font = font
        }
    }
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
    @IBOutlet weak var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    
    var onEdit: ((BorderedTextField) -> Void)? = nil
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    private func sharedSetup() {
        addSubview(borderImageView)
        borderImageView.translatesAutoresizingMaskIntoConstraints = false
        borderImageView.addFitToParentContraints()
        addSubview(textField)
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BorderedTextField.horizontalTextInset).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -BorderedTextField.horizontalTextInset).isActive = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Editing response
    
    @objc private func textFieldDidChange() {
        onEdit?(self)
    }
}

struct BorderedTextFieldPopulator {
    static func add(leftView view: UIView, to borderedTextField: BorderedTextField) {
        borderedTextField.textField.leftView = view
        borderedTextField.textField.leftViewMode = .always
    }
    
    static func removeLeftInputView(from borderedTextField: BorderedTextField) {
        borderedTextField.textField.leftView?.removeFromSuperview()
    }
}


