import Foundation

struct Assembler {

    static var fileHandle: FileHandle!
    static var outputFileUrl: URL!

    static var defaultComment: String = ""
    static var parser: Parser!

    static let symbolTable = SymbolTable()

    static func main() {
        let arguments = ProcessInfo().arguments
        let currentPath = FileManager.default.currentDirectoryPath

        guard arguments.count > 1 else {
            fatalError("target .asm file is not specified.")
        }

        let fileUrl = currentPath + "/" + arguments[1]
        let url = URL(fileURLWithPath: arguments[1])
        let fileName = url.lastPathComponent

        guard fileName.hasSuffix(".asm") else {
            fatalError("Selected file is not .asm format")
        }

        let outputFile = fileName.replacingOccurrences(of: "asm", with: "hack")
        parser = Parser(fileURLStr: fileUrl)

        createOutputFile(path: currentPath, outputFile: outputFile)
        start()
    }

    static func createOutputFile(path: String, outputFile: String) {
        let outputDir = "/output/"
        let dir = URL(fileURLWithPath: path + outputDir)
        outputFileUrl = dir.appendingPathComponent(outputFile)
        
        
        do {
            try FileManager
                .default
                .createDirectory(
                    atPath: dir.path,
                    withIntermediateDirectories: true,
                    attributes: nil
            )
        } catch {
            fatalError("Failed to create output directory")
        }

        FileManager
            .default
            .createFile(
                atPath: outputFileUrl.path,
                contents: defaultComment.data(using: .utf8),
                attributes: nil
        )
        
        fileHandle = FileHandle(forWritingAtPath: outputFileUrl.path)
    }

    static func start() {
        createSymbolTable()
        startParse()
    }

    static func createSymbolTable() {

        while parser.hasMoreCommands() {
            parser.advance()
            switch parser.commandType {
            case .A_COMMAND:
                symbolTable.currentAddress += 1
            case .L_COMMAND:
                let lSymbol = shapeLCommand(lCommand: parser.symbol())
                symbolTable.addEntry(symbol: lSymbol, address: symbolTable.currentAddress)
            case .C_COMMAND:
                symbolTable.currentAddress += 1
            default:
                fatalError("Failed to create symbol table")
            }

        }

        parser.resetPosition()
    }

    static func startParse() {
        var line = 1

        while parser.hasMoreCommands() {
            parser.advance()
            print("LINE = \(line)")
            print("\(parser.commandType.rawValue) : \(parser.currentCommand)")
            switch parser.commandType {
            case .A_COMMAND:
                let aCommand = parser.symbol()
                let removePrefix = aCommand.replacingOccurrences(of: "@", with: "")
                var aAddress: Int = 0

                if Int(removePrefix) != nil {
                    aAddress = Int(removePrefix)!
                } else {
                    if !symbolTable.contains(symbol: removePrefix) {
                        symbolTable.addEntry(symbol: removePrefix, address: symbolTable.currentVarAddress)
                        symbolTable.currentVarAddress += 1
                    }
                    aAddress = symbolTable.getAddress(symbol: removePrefix)
                }

                let aBinary15bit = pad(string: String(UInt16(aAddress), radix: 2), toSize: 15)
                let aBinary = "0" + aBinary15bit

                print("aBinary = \(aBinary)")
                writeCommand(binary: aBinary)

            case .L_COMMAND:
                let lSymbol = shapeLCommand(lCommand: parser.symbol())
                if symbolTable.contains(symbol: lSymbol) {
                    let lAddress = symbolTable.getAddress(symbol: lSymbol)
                    let lBinary15bit = pad(string: String(UInt16(lAddress), radix: 2), toSize: 15)
                    print("lBinary = \(lBinary15bit)")
                }

            case .C_COMMAND:
                let dest = Code.dest(str: parser.dest())
                let comp = Code.comp(str: parser.comp())
                let jump = Code.jump(str: parser.jump())

                let binaryDest = pad(string: String(dest, radix: 2), toSize: 3)
                let binaryComp = pad(string: String(comp, radix: 2), toSize: 7)
                let binaryJump = pad(string: String(jump, radix: 2), toSize: 3)

                let cBinary = "111" + binaryComp + binaryDest + binaryJump
                print("cBinary = \(cBinary)")
                writeCommand(binary: cBinary)

            default :
                fatalError("Parse failed.")
            }

            print("=========================")
            line += 1
        }
    }

    static func writeCommand(binary: String) {
        fileHandle!.write(binary.data(using: .utf8)!)
        fileHandle!.write("\n".data(using: .utf8)!)
    }

    static func shapeLCommand(lCommand: String) -> String {
        let removePrefix = lCommand.replacingOccurrences(of: "(", with: "")
        let lSymbol = removePrefix.replacingOccurrences(of: ")", with: "")
        return lSymbol
    }

    static func pad(string: String, toSize: Int) -> String {
      var padded = string
      for _ in 0..<(toSize - string.count) {
        padded = "0" + padded
      }
        return padded
    }
}

Assembler.main()
