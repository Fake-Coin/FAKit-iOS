//
//  Amount.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-01-15.
//  Copyright © 2017 breadwallet LLC. All rights reserved.
//

import Foundation

struct Amount {

    //MARK: - Public
    let amount: UInt64 //amount in satoshis
    let maxDigits: Int
    
    var amountForBtcFormat: Double {
        var decimal = Decimal(self.amount)
        var amount: Decimal = 0.0
        NSDecimalMultiplyByPowerOf10(&amount, &decimal, Int16(-maxDigits), .up)
        return NSDecimalNumber(decimal: amount).doubleValue
    }

    var bits: String {
        var decimal = Decimal(self.amount)
        var amount: Decimal = 0.0
        NSDecimalMultiplyByPowerOf10(&amount, &decimal, Int16(-maxDigits), .up)
        let number = NSDecimalNumber(decimal: amount)
        guard let string = btcFormat.string(from: number) else { return "" }
        return string
    }

    func string(isBtcSwapped: Bool) -> String {
        return bits
    }

    var btcFormat: NumberFormatter {
        let format = NumberFormatter()
        format.isLenient = true
        format.numberStyle = .currency
        format.generatesDecimalNumbers = true
        format.negativeFormat = format.positiveFormat.replacingCharacters(in: format.positiveFormat.range(of: "#")!, with: "-#")
        format.currencyCode = "FAK"

        switch maxDigits {
        case 2: // photons
            format.currencySymbol = "m\(S.Symbols.bits)\(S.Symbols.narrowSpace)"
            format.maximum = (C.maxMoney/C.satoshis)*100000 as NSNumber
        case 5: // lites
            format.currencySymbol = "\(S.Symbols.bits)\(S.Symbols.narrowSpace)"
            format.maximum = (C.maxMoney/C.satoshis)*1000 as NSNumber
        case 8: // litecoin
            format.currencySymbol = "\(S.Symbols.btc)\(S.Symbols.narrowSpace)"
            format.maximum = C.maxMoney/C.satoshis as NSNumber
        default:
            format.currencySymbol = "\(S.Symbols.bits)\(S.Symbols.narrowSpace)"
        }

        format.maximumFractionDigits = maxDigits
        format.minimumFractionDigits = 0 // iOS 8 bug, minimumFractionDigits now has to be set after currencySymbol
        format.maximum = Decimal(C.maxMoney)/(pow(10.0, maxDigits)) as NSNumber

        return format
    }
}

struct DisplayAmount {
    let amount: Satoshis
    let state: State
    let minimumFractionDigits: Int?

    var description: String {
        return bitcoinDescription
    }

    private var bitcoinDescription: String {
        var decimal = Decimal(self.amount.rawValue)
        var amount: Decimal = 0.0
        NSDecimalMultiplyByPowerOf10(&amount, &decimal, Int16(-state.maxDigits), .up)
        let number = NSDecimalNumber(decimal: amount)
        guard let string = btcFormat.string(from: number) else { return "" }
        return string
    }

    var localFormat: NumberFormatter {
        let format = NumberFormatter()
        format.isLenient = true
        format.numberStyle = .currency
        format.generatesDecimalNumbers = true
        format.negativeFormat = format.positiveFormat.replacingCharacters(in: format.positiveFormat.range(of: "#")!, with: "-#")
        if let minimumFractionDigits = minimumFractionDigits {
            format.minimumFractionDigits = minimumFractionDigits
        }
        return format
    }

    var btcFormat: NumberFormatter {
        let format = NumberFormatter()
        format.isLenient = true
        format.numberStyle = .currency
        format.generatesDecimalNumbers = true
        format.negativeFormat = format.positiveFormat.replacingCharacters(in: format.positiveFormat.range(of: "#")!, with: "-#")
        format.currencyCode = "FAK"

        switch state.maxDigits {
        case 2:
            format.currencySymbol = "m\(S.Symbols.bits)\(S.Symbols.narrowSpace)"
            format.maximum = (C.maxMoney/C.satoshis)*100000 as NSNumber
        case 5:
            format.currencySymbol = "\(S.Symbols.bits)\(S.Symbols.narrowSpace)"
            format.maximum = (C.maxMoney/C.satoshis)*1000 as NSNumber
        case 8:
            format.currencySymbol = "\(S.Symbols.btc)\(S.Symbols.narrowSpace)"
            format.maximum = C.maxMoney/C.satoshis as NSNumber
        default:
            format.currencySymbol = "\(S.Symbols.bits)\(S.Symbols.narrowSpace)"
        }

        format.maximumFractionDigits = state.maxDigits
        if let minimumFractionDigits = minimumFractionDigits {
            format.minimumFractionDigits = minimumFractionDigits
        }
        format.maximum = Decimal(C.maxMoney)/(pow(10.0, state.maxDigits)) as NSNumber

        return format
    }
}
