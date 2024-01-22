//
//  ViewController.swift
//  Wirebarley
//
//  Created by rbwo on 1/22/24.
//

import UIKit

final class ViewController: UIViewController {
    
    private let countrys = [Country.KRW, .JPY, .PHP]
    private let viewModel: ViewModel
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "환율 계산"
        view.font = .preferredFont(forTextStyle: .largeTitle)
        view.adjustsFontForContentSizeCategory = true
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        view.distribution = .equalSpacing
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var remittanceCountry: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.numberOfLines = 0
        view.text = "송금국가 : 미국 (USD)"
        
        return view
    }()
    
    private lazy var receivingCountry: UIButton = {
        let view = UIButton()
        view.setTitleColor(.systemBlue, for: .normal)
        view.setTitle("수취국가 : 한국 (KRW)", for: .normal)
        view.titleLabel?.numberOfLines = 0
        view.titleLabel?.font = .preferredFont(forTextStyle: .body)
        view.titleLabel?.adjustsFontForContentSizeCategory = true
        
        view.addTarget(self, action: #selector(showPickerView), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var receivingCountryPickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var dismissPickerViewButton: UIButton = {
        let view = UIButton()
        view.setTitle("선택하기", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.titleLabel?.font = .preferredFont(forTextStyle: .body)
        view.titleLabel?.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        view.addTarget(self, action: #selector(dismissPickerView), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var exchangeRateLabel: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.numberOfLines = 0
        view.text = "환율 : "
        
        return view
    }()
    
    private lazy var checkTime: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.numberOfLines = 0
        view.text = "조회시간 : "
        
        return view
    }()
    
    private lazy var receivingAmount: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .headline)
        view.adjustsFontForContentSizeCategory = true
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "수취금액은 121,303.02 KRW 입니다"
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let remittanceView = RemittanceView()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        configureLayout()
        remittanceView.delegate = self
        
        /// viewModel이 업데이트 되면
        /// 업데이트할 UI 요소들을 내부에 작성했습니다
        viewModel.onUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                
                self.receivingCountry.setTitle("수취국가 : \(self.viewModel.getCountry().countryText)", for: .normal)
                
                self.exchangeRateLabel.text = "환율 : " +
                self.viewModel.getExchangeRateString() +
                " \(self.viewModel.getCountry().exchangeRateText) / USD"
                
                self.checkTime.text = "조회 시간 : " + self.viewModel.getCheckTime()
                
                self.receivingAmount.text = "수취금액은 " + 
                self.viewModel.getRemittanceAmountString(amount: Int(self.remittanceView.remittanceAmountTextField.text ?? "0") ?? 0) + " " +
                self.viewModel.getCountry().exchangeRateText + " 입니다"
            }
        }
    }
    
    private func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(receivingCountryPickerView)
        view.addSubview(dismissPickerViewButton)
        view.addSubview(receivingAmount)
        
        [remittanceCountry, receivingCountry, exchangeRateLabel, checkTime, remittanceView].forEach { view in
            stackView.addArrangedSubview(view)
        }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 70),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            receivingAmount.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            receivingAmount.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            receivingAmount.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            receivingAmount.heightAnchor.constraint(greaterThanOrEqualToConstant: 32),
            receivingAmount.bottomAnchor.constraint(lessThanOrEqualTo: dismissPickerViewButton.topAnchor, constant: -16),
            
            dismissPickerViewButton.bottomAnchor.constraint(equalTo: receivingCountryPickerView.topAnchor),
            dismissPickerViewButton.trailingAnchor.constraint(equalTo: receivingCountryPickerView.trailingAnchor, constant: -16),
            dismissPickerViewButton.heightAnchor.constraint(lessThanOrEqualToConstant: 44),
            
            receivingCountryPickerView.topAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: 200),
            receivingCountryPickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            receivingCountryPickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            receivingCountryPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func showPickerView() {
        receivingCountryPickerView.isHidden = false
        dismissPickerViewButton.isHidden = false
    }
    
    @objc private func dismissPickerView() {
        receivingCountryPickerView.isHidden = true
        dismissPickerViewButton.isHidden = true

        viewModel.reload()
    }

}

extension ViewController: RemittanceViewDelegate {
    /// 텍스트필드의 값을 검사하여 유효하면 reload 하고
    /// 아니면 팝업을 띄우는 함수
    func changeAmount(value: String) {
        if let value = Int(value), value > 10000 || value < 0 {
            let alert = UIAlertController(title: "알림", message: "송금액이 바르지 않습니다", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(confirm)
            self.present(alert, animated: true) {
                self.remittanceView.remittanceAmountTextField.text = "0"
            }
        }
        else { viewModel.reload() }
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        countrys[row].countryText
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setCountry(country: countrys[row])
    }
}

extension ViewController:  UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countrys.count
    }
}
