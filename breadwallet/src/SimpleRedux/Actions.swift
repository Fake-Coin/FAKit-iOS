//
//  Actions.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-22.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit

//MARK: - Startup Modals
struct ShowStartFlow : Action {
    let reduce: Reducer = {
        return $0.clone(isStartFlowVisible: true)
    }
}

struct HideStartFlow : Action {
    let reduce: Reducer = { state in
        return State(isStartFlowVisible: false,
                     isLoginRequired: state.isLoginRequired,
                     rootModal: .none,
                     walletState: state.walletState,
                     isBtcSwapped: state.isBtcSwapped,
                     alert: state.alert,
                     isTouchIdEnabled: state.isTouchIdEnabled,
                     recommendRescan: state.recommendRescan,
                     isLoadingTransactions: state.isLoadingTransactions,
                     maxDigits: state.maxDigits,
                     isPushNotificationsEnabled: state.isPushNotificationsEnabled,
                     isPromptingTouchId: state.isPromptingTouchId,
                     pinLength: state.pinLength,
                     fees: state.fees)
    }
}

struct Reset : Action {
    let reduce: Reducer = { _ in
        return State.initial.clone(isLoginRequired: false)
    }
}

struct RequireLogin : Action {
    let reduce: Reducer = {
        return $0.clone(isLoginRequired: true)
    }
}

struct LoginSuccess : Action {
    let reduce: Reducer = {
        return $0.clone(isLoginRequired: false)
    }
}

//MARK: - Root Modals
struct RootModalActions {
    struct Present: Action {
        let reduce: Reducer
        init(modal: RootModal) {
            reduce = { $0.rootModal(modal) }
        }
    }
}

//MARK: - Wallet State
enum WalletChange {
    struct setProgress: Action {
        let reduce: Reducer
        init(progress: Double, timestamp: UInt32) {
            reduce = { $0.clone(walletSyncProgress: progress, timestamp: timestamp) }
        }
    }
    struct setSyncingState: Action {
        let reduce: Reducer
        init(_ syncState: SyncState) {
            reduce = { $0.clone(syncState: syncState) }
        }
    }
    struct setBalance: Action {
        let reduce: Reducer
        init(_ balance: UInt64) {
            reduce = { $0.clone(balance: balance) }
        }
    }
    struct setTransactions: Action {
        let reduce: Reducer
        init(_ transactions: [Transaction]) {
            reduce = { $0.clone(transactions: transactions) }
        }
    }
    struct setWalletName: Action {
        let reduce: Reducer
        init(_ name: String) {
            reduce = { $0.clone(walletName: name) }
        }
    }
    struct setWalletCreationDate: Action {
        let reduce: Reducer
        init(_ date: Date) {
            reduce = { $0.clone(walletCreationDate: date) }
        }
    }
    struct setIsRescanning: Action {
        let reduce: Reducer
        init(_ isRescanning: Bool) {
            reduce = { $0.clone(isRescanning: isRescanning) }
        }
    }
}

//MARK: - Currency
enum CurrencyChange {
    struct toggle: Action {
        let reduce: Reducer = {
            UserDefaults.isBtcSwapped = !$0.isBtcSwapped
            return $0.clone(isBtcSwapped: !$0.isBtcSwapped)
        }
    }
}

//MARK: - Alerts
enum Alert {
    struct Show : Action {
        let reduce: Reducer
        init(_ type: AlertType) {
            reduce = { $0.clone(alert: type) }
        }
    }
    struct Hide : Action {
        let reduce: Reducer = { $0.clone(alert: nil) }
    }
}

enum TouchId {
    struct setIsEnabled : Action, Trackable {
        let reduce: Reducer
        init(_ isTouchIdEnabled: Bool) {
            UserDefaults.isTouchIdEnabled = isTouchIdEnabled
            reduce = { $0.clone(isTouchIdEnabled: isTouchIdEnabled) }
            saveEvent("event.enableTouchId", attributes: ["isEnabled": "\(isTouchIdEnabled)"])
        }
    }
}

enum RecommendRescan {
    struct set : Action, Trackable {
        let reduce: Reducer
        init(_ recommendRescan: Bool) {
            reduce = { $0.clone(recommendRescan: recommendRescan) }
            saveEvent("event.recommendRescan")
        }
    }
}

enum LoadTransactions {
    struct set : Action {
        let reduce: Reducer
        init(_ isLoadingTransactions: Bool) {
            reduce = { $0.clone(isLoadingTransactions: isLoadingTransactions) }
        }
    }
}

enum MaxDigits {
    struct set : Action, Trackable {
        let reduce: Reducer
        init(_ maxDigits: Int) {
            UserDefaults.maxDigits = maxDigits
            reduce = { $0.clone(maxDigits: maxDigits)}
            saveEvent("maxDigits.set", attributes: ["maxDigits": "\(maxDigits)"])
        }
    }
}

enum PushNotifications {
    struct setIsEnabled : Action {
        let reduce: Reducer
        init(_ isEnabled: Bool) {
            reduce = { $0.clone(isPushNotificationsEnabled: isEnabled) }
        }
    }
}

enum TouchIdActions {
    struct setIsPrompting : Action {
        let reduce: Reducer
        init(_ isPrompting: Bool) {
            reduce = { $0.clone(isPromptingTouchId: isPrompting) }
        }
    }
}

enum PinLength {
    struct set : Action {
        let reduce: Reducer
        init(_ pinLength: Int) {
            reduce = { $0.clone(pinLength: pinLength) }
        }
    }
}

enum UpdateFees {
    struct set : Action {
        let reduce: Reducer
        init(_ fees: Fees) {
            reduce = { $0.clone(fees: fees) }
        }
    }
}


//MARK: - State Creation Helpers
extension State {
    func clone(isStartFlowVisible: Bool) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func rootModal(_ type: RootModal) -> State {
        return State(isStartFlowVisible: false,
                     isLoginRequired: isLoginRequired,
                     rootModal: type,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(pasteboard: String?) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(walletSyncProgress: Double, timestamp: UInt32) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: WalletState(isConnected: walletState.isConnected, syncProgress: walletSyncProgress, syncState: walletState.syncState, balance: walletState.balance, transactions: walletState.transactions, lastBlockTimestamp: timestamp, name: walletState.name, creationDate: walletState.creationDate, isRescanning: walletState.isRescanning),
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(syncState: SyncState) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: WalletState(isConnected: walletState.isConnected, syncProgress: walletState.syncProgress, syncState: syncState, balance: walletState.balance, transactions: walletState.transactions, lastBlockTimestamp: walletState.lastBlockTimestamp, name: walletState.name, creationDate: walletState.creationDate, isRescanning: walletState.isRescanning),
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(balance: UInt64) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: WalletState(isConnected: walletState.isConnected, syncProgress: walletState.syncProgress, syncState: walletState.syncState, balance: balance, transactions: walletState.transactions, lastBlockTimestamp: walletState.lastBlockTimestamp, name: walletState.name, creationDate: walletState.creationDate, isRescanning: walletState.isRescanning),
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(transactions: [Transaction]) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: WalletState(isConnected: walletState.isConnected, syncProgress: walletState.syncProgress, syncState: walletState.syncState, balance: walletState.balance, transactions: transactions, lastBlockTimestamp: walletState.lastBlockTimestamp, name: walletState.name, creationDate: walletState.creationDate, isRescanning: walletState.isRescanning),
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(walletName: String) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: WalletState(isConnected: walletState.isConnected, syncProgress: walletState.syncProgress, syncState: walletState.syncState, balance: walletState.balance, transactions: walletState.transactions, lastBlockTimestamp: walletState.lastBlockTimestamp, name: walletName, creationDate: walletState.creationDate, isRescanning: walletState.isRescanning),
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(walletSyncingErrorMessage: String?) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: WalletState(isConnected: walletState.isConnected, syncProgress: walletState.syncProgress, syncState: walletState.syncState, balance: walletState.balance, transactions: walletState.transactions, lastBlockTimestamp: walletState.lastBlockTimestamp, name: walletState.name, creationDate: walletState.creationDate, isRescanning: walletState.isRescanning),
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(walletCreationDate: Date) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: WalletState(isConnected: walletState.isConnected, syncProgress: walletState.syncProgress, syncState: walletState.syncState, balance: walletState.balance, transactions: walletState.transactions, lastBlockTimestamp: walletState.lastBlockTimestamp, name: walletState.name, creationDate: walletCreationDate, isRescanning: walletState.isRescanning),
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(isRescanning: Bool) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: WalletState(isConnected: walletState.isConnected, syncProgress: walletState.syncProgress, syncState: walletState.syncState, balance: walletState.balance, transactions: walletState.transactions, lastBlockTimestamp: walletState.lastBlockTimestamp, name: walletState.name, creationDate: walletState.creationDate, isRescanning: isRescanning),
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(isBtcSwapped: Bool) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(isLoginRequired: Bool) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(currentRate: Rate, rates: [Rate]) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(currentRate: Rate) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(alert: AlertType?) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(isTouchIdEnabled: Bool) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(defaultCurrencyCode: String) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(recommendRescan: Bool) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(isLoadingTransactions: Bool) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(maxDigits: Int) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(isPushNotificationsEnabled: Bool) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(isPromptingTouchId: Bool) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(pinLength: Int) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
    func clone(fees: Fees) -> State {
        return State(isStartFlowVisible: isStartFlowVisible,
                     isLoginRequired: isLoginRequired,
                     rootModal: rootModal,
                     walletState: walletState,
                     isBtcSwapped: isBtcSwapped,
                     alert: alert,
                     isTouchIdEnabled: isTouchIdEnabled,
                     recommendRescan: recommendRescan,
                     isLoadingTransactions: isLoadingTransactions,
                     maxDigits: maxDigits,
                     isPushNotificationsEnabled: isPushNotificationsEnabled,
                     isPromptingTouchId: isPromptingTouchId,
                     pinLength: pinLength,
                     fees: fees)
    }
}
