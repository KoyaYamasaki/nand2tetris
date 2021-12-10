import Foundation

class Code {
    static func comp(str: String) -> UInt8 {
        if !str.contains("M") {
            switch str {
            case "0":
                return 0b0101010
            case "1":
                return 0b0111111
            case "-1":
                return 0b0111010
            case "D":
                return 0b0001100
            case "A":
                return 0b0110000
            case "!D":
                return 0b0001101
            case "!A":
                return 0b0110001
            case "-D":
                return 0b0001111
            case "-A":
                return 0b0110011
            case "D+1":
                return 0b0011111
            case "A+1":
                return 0b0110111
            case "D-1":
                return 0b0001110
            case "A-1":
                return 0b0110010
            case "D+A", "A+D":
                return 0b0000010
            case "D-A":
                return 0b0010011
            case "A-D":
                return 0b0000111
            case "D&A":
                return 0b0000000
            case "D|A":
                return 0b0010101
            default:
                return 0b0000000
            }
        } else {
            switch str {
            case "M":
                return 0b1110000
            case "!M":
                return 0b1110001
            case "-M":
                return 0b1110011
            case "M+1":
                return 0b1110111
            case "M-1":
                return 0b1110010
            case "D+M", "M+D":
                return 0b1000010
            case "D-M":
                return 0b1010011
            case "M-D":
                return 0b1000111
            case "D&M", "M&D":
                return 0b1000000
            case "D|M", "M|D":
                return 0b1010101
            default:
                return 0b1000000
            }
        }
    }

    static func jump(str: String?) -> UInt8 {
        guard let unwrappedStr = str else {
            return 0b000
        }

        switch unwrappedStr {
        case "JGT":
            return 0b001
        case "JEQ":
            return 0b010
        case "JGE":
            return 0b011
        case "JLT":
            return 0b100
        case "JNE":
            return 0b101
        case "JLE":
            return 0b110
        case "JMP":
            return 0b111
        default:
            return 0b000
        }

    }

    static func dest(str: String?) -> UInt8 {
        var bit: UInt8 = 0b000
        guard let unwrappedStr = str else {
            return bit
        }

        if unwrappedStr.contains("A") {
            bit = 0b100
        }

        if unwrappedStr.contains("D") {
            bit = bit | 0b010
        }

        if unwrappedStr.contains("M") {
            bit = bit | 0b001
        }

        return bit
    }
}
