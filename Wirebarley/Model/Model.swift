//
//  ExchangeLate.swift
//  Wirebarley
//
//  Created by rbwo on 1/22/24.
//

import Foundation

struct ExchangeRate: Codable {
    let success: Bool
    let terms, privacy: String
    let timestamp: Int
    let source: String
    let quotes: [String: Double]
}

enum Country: String, CaseIterable {
    case KRW = "USDKRW"
    case JPY = "USDJPY"
    case PHP = "USDPHP"
    
    var countryText: String {
        switch self {
        case .KRW: return "한국 (KRW)"
        case .JPY: return "일본 (JPY)"
        case .PHP: return "필리핀 (PHP)"
        }
    }
    
    var exchangeRateText: String {
        switch self {
        case .KRW: return "KRW"
        case .JPY: return "JPY"
        case .PHP: return "PHP"
        }
    }
    
    var countryList: String {
        return Country.allCases.map { $0.exchangeRateText }.joined(separator: ",")
    }
}
