//
//  ViewModel.swift
//  Wirebarley
//
//  Created by rbwo on 1/22/24.
//

import Foundation

final class ViewModel {
    
    var onUpdated: () -> Void = { }
    
    private let networkService: NetworkService
    private var exchangeRates: [String: Double] = [:]
    private var country: Country = .KRW
    
    var viewData: (exchangeRates: [String: Double], time: Int) = ([:], 0) {
        didSet { onUpdated() }
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        fetchExchangeRate(country: .KRW)
    }
    
    /// 환율 API의 URL을 설정하는 함수
    func getLiveExchangeRateURL() -> URLRequest? {
        var urlRequest = URLRequestBuilder(url: Secret.baseURL)
        urlRequest.appendQuery(name: "access_key", value: Secret.access_key)
        urlRequest.appendQuery(name: "currencies", value: country.countryList)
        urlRequest.appendQuery(name: "source", value: "USD")
        urlRequest.appendQuery(name: "format", value: "1")
        return urlRequest.build()
    }
    
    /// NetworkService를 사용하여 데이터를 얻어오는 함수
    func fetchExchangeRate(country: Country) {
        guard let request = getLiveExchangeRateURL() else { return }
        
        networkService.request(request: request, type: ExchangeRate.self) { result in
            switch result {
            case .success(let success):
                self.viewData.exchangeRates = success.quotes
                self.viewData.time = success.timestamp
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    /// ViewModel 환율 업데이트 하는 함수
    func reload() {
        self.fetchExchangeRate(country: self.country)
    }
    
    /// 나라를 설정하는 함수
    func setCountry(country: Country) {
        self.country = country
    }
    
    /// 현재 선택된 나라를 반환하는 함수
    func getCountry() -> Country {
        return self.country
    }
    
    /// 송금액과 환율을 곱한 후 문자열 포맷에 맞게 리턴하는 함수
    func getRemittanceAmountString(amount: Int) -> String {
        let number: Double = Double(amount) * (self.viewData.exchangeRates[country.rawValue] ?? 0)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2

        let formattedString = numberFormatter.string(from: NSNumber(value: number)) ?? ""
        
        return formattedString
    }
    
    /// 환율 문자열만 리턴하는 함수
    func getExchangeRateString() -> String {
        return String(format: "%.2f", self.viewData.exchangeRates[self.country.rawValue] ?? 0)
    }
    
    /// 조회시간을 리턴하는 함수
    func getCheckTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD HH:mm"
        formatter.timeZone = .current
        let date = Date(timeIntervalSince1970: TimeInterval(self.viewData.time))
        let convertStr = formatter.string(from: date)
        
        return convertStr
    }
    
}
