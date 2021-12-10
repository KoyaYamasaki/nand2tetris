import Foundation

class Parser {

    var currentCommand = ""
    private var position: Int = -1

    private var commandByLine: [String] = []

    init(fileURLStr: String) {

        let fileURL = URL(fileURLWithPath: fileURLStr)

        guard let fileContents = try? String(contentsOf: fileURL) else {
            fatalError("File could not be read.")
        }

        let separatedByLine = fileContents.components(separatedBy: "\n")

        // Remove line break lines.
        let removeEmptySpace = separatedByLine.filter({ $0 != "\r" && !$0.isEmpty })

        // Remove comment lines.
        let removeComment = removeEmptySpace.filter {
            !$0.hasPrefix("//")
        }

        // Remove spaces
        let removeLeadingSpace = removeComment.map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })

        commandByLine = removeLeadingSpace.map({
            $0.replacingOccurrences(of: " ", with: "")
        })

        // Remove Same line comment
        commandByLine = commandByLine.map({
            if let commentIndex = $0.range(of: "//") {
                return String($0[..<commentIndex.lowerBound])
            } else { return $0 }
        })


        for aOrder in commandByLine {
            print(aOrder)
        }
    }

    func hasMoreCommands() -> Bool {
        return position + 1 != commandByLine.count
    }

    func resetPosition() {
        position = -1
    }

    func advance() {
        
        if hasMoreCommands() {
            position += 1
            currentCommand = commandByLine[position]
        }
    }

    var commandType: CommandType {
        if currentCommand.first! == "@" {
            return .A_COMMAND
        } else if currentCommand.first! == "(" {
            return .L_COMMAND
        } else if !currentCommand.isEmpty {
            return .C_COMMAND
        } else {
            return .UNKNOWN
        }
    }

    func symbol() -> String {
        guard commandType == .A_COMMAND || commandType == .L_COMMAND else {
            fatalError("Current command is not A_COMMAND or L_COMMAND.")
        }

        return currentCommand
    }

    func comp() -> String {
        guard commandType == .C_COMMAND else {
            fatalError("Current command is not C_COMMAND.")
        }

        let result = parseCCommand(command: currentCommand)
        return result["comp"]!
    }

    func dest() -> String? {
        guard commandType == .C_COMMAND else {
            fatalError("Current command is not C_COMMAND.")
        }

        let result = parseCCommand(command: currentCommand)
        return result["dest"]
    }

    func jump() -> String? {
        guard commandType == .C_COMMAND else {
            fatalError("Current command is not C_COMMAND.")
        }

        let result = parseCCommand(command: currentCommand)
        return result["jump"]
    }

    private func parseCCommand(command: String) -> [String: String] {
        var cCommandDict: [String: String] = [:]
        if command.contains("=") {
            let cCommand = command.components(separatedBy: "=")
            cCommandDict = [
                "dest": cCommand[0],
                "comp": cCommand[1]]
        } else if command.contains(";") {
            let cCommand = command.components(separatedBy: ";")
            cCommandDict = [
                "comp": cCommand[0],
                "jump": cCommand[1]]
        }

        return cCommandDict
    }
}
