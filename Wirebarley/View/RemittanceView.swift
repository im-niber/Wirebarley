//
//  RemittanceView.swift
//  Wirebarley
//
//  Created by rbwo on 1/22/24.
//

import UIKit

protocol RemittanceViewDelegate: AnyObject {
    func changeAmount(value: String)
}

final class RemittanceView: UIStackView {
    
    weak var delegate: RemittanceViewDelegate?

    private lazy var remittanceAmountLabel: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.text = "송금액 : "
        
        return view
    }()
    
    lazy var remittanceAmountTextField: UITextField = {
        let view = UITextField()
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.delegate = self
        view.text = "100"
        view.textAlignment = .right
        view.borderStyle = .line
        view.keyboardType = .numberPad
        
        return view
    }()
    
    private lazy var countryLabel: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.text = " USD"
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .fill
        alignment = .fill
        
        setDoneOnKeyboard()
        addArrangedSubview(remittanceAmountLabel)
        addArrangedSubview(remittanceAmountTextField)
        addArrangedSubview(countryLabel)
        
        remittanceAmountTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let doneBarButton = UIBarButtonItem(title: "계산하기", style: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [doneBarButton]
        self.remittanceAmountTextField.inputAccessoryView = keyboardToolbar
    }

    @objc private func dismissKeyboard() {
        remittanceAmountTextField.endEditing(true)
        delegate?.changeAmount(value: remittanceAmountTextField.text ?? "")
    }
}

extension RemittanceView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text?.removeAll()
    }
}
