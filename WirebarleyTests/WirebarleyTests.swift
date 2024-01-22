//
//  WirebarleyTests.swift
//  WirebarleyTests
//
//  Created by rbwo on 1/22/24.
//

import XCTest
@testable import Wirebarley

final class MockNetworkService: NetworkService {
    var requestCalled = false

    override func request<T>(request: URLRequest, type: T.Type, completion: @escaping (Result<T, NetworkErrors>) -> Void) where T: Decodable {
        requestCalled = true
        let sampleData = ExchangeRate(success: true, terms: "https://currencylayer.com/terms", privacy: "https://currencylayer.com/privacy", timestamp: 1705931283, source: "USD", quotes: ["USDKRW": 1339.230206, "USDJPY": 147.682498, "USDPHP": 56.440297])
        completion(.success(sampleData as! T))
    }
}

final class ViewModelTests: XCTestCase {
    private var sampleData: ExchangeRate!
    private var mockNetworkService: MockNetworkService!
    private var viewModel: ViewModel!
    
    override func setUp() {
        super.setUp()
        sampleData = ExchangeRate(success: true, terms: "https://currencylayer.com/terms", privacy: "https://currencylayer.com/privacy", timestamp: 1705931283, source: "USD", quotes: ["USDKRW": 1339.230206, "USDJPY": 147.682498, "USDPHP": 56.440297])
        
        mockNetworkService = MockNetworkService()
        viewModel = ViewModel(networkService: mockNetworkService)
        
        viewModel.fetchExchangeRate(country: .KRW)
        viewModel.setCountry(country: .KRW)
    }
    
    func test_FetchExchangeRate() {
        XCTAssertEqual(sampleData.timestamp, viewModel.viewData.time)
        XCTAssertEqual(sampleData.quotes["USDKRW"], viewModel.viewData.exchangeRates["USDKRW"])
        
        XCTAssertTrue(mockNetworkService.requestCalled)
    }
    
    func test_Contury() {
        XCTAssertEqual(viewModel.getCountry(), .KRW)
    }
    
    func test_환율_문자열_포맷() {
        XCTAssertEqual(viewModel.getExchangeRateString(), "1339.23")
    }
    
    func test_환율_계산_문자열() {
        let amount = 300
        let krw = 1339.230206
        
        let number: Double = Double(amount) * (krw)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let formattedString = numberFormatter.string(from: NSNumber(value: number)) ?? ""
        
        XCTAssertEqual(viewModel.getRemittanceAmountString(amount: amount), formattedString)
    }
    
    override func tearDown() {
        super.tearDown()
        sampleData = nil
        mockNetworkService = nil
        viewModel = nil
    }
}
