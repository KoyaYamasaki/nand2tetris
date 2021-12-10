import Foundation

class SymbolTable {

    private var _currentAddress = 0

    private var _currentVarAddress = 16

    private var symbolDict: [String: Int] = [:]

    var currentAddress: Int {
        get {
            return _currentAddress
        }

        set {
            _currentAddress = newValue
        }
    }

    var currentVarAddress: Int {
        get {
            return _currentVarAddress
        }
        set {
            _currentVarAddress = newValue
        }
    }

    init() {
        addEntry(symbol: "SP", address: 0b0000000000000000)
        addEntry(symbol: "LCL", address: 0b0000000000000001)
        addEntry(symbol: "ARG", address: 0b0000000000000010)
        addEntry(symbol: "THIS", address: 0b0000000000000011)
        addEntry(symbol: "THAT", address: 0b0000000000000100)
        addEntry(symbol: "R0", address: 0b0000000000000000)
        addEntry(symbol: "R1", address: 0b0000000000000001)
        addEntry(symbol: "R2", address: 0b0000000000000010)
        addEntry(symbol: "R3", address: 0b0000000000000011)
        addEntry(symbol: "R4", address: 0b0000000000000100)
        addEntry(symbol: "R5", address: 0b0000000000000101)
        addEntry(symbol: "R6", address: 0b0000000000000110)
        addEntry(symbol: "R7", address: 0b0000000000000111)
        addEntry(symbol: "R8", address: 0b0000000000001000)
        addEntry(symbol: "R9", address: 0b0000000000001001)
        addEntry(symbol: "R10", address: 0b0000000000001010)
        addEntry(symbol: "R11", address: 0b0000000000001011)
        addEntry(symbol: "R12", address: 0b0000000000001100)
        addEntry(symbol: "R13", address: 0b0000000000001101)
        addEntry(symbol: "R14", address: 0b0000000000001110)
        addEntry(symbol: "R15", address: 0b0000000000001111)
        addEntry(symbol: "SCREEN", address: 0b0100000000000000)
        addEntry(symbol: "KBD", address: 0b0110000000000000)
    }

    func addEntry(symbol: String, address: Int) {
        symbolDict[symbol] = address
    }

    func contains(symbol: String) -> Bool {
        if symbolDict[symbol] != nil {
            return true
        } else {
            return false
        }
    }

    func getAddress(symbol: String) -> Int {
        return symbolDict[symbol]!
    }
}
