import Foundation
import SwiftTerm

public class HeadlessTerminal : TerminalDelegate, LocalProcessDelegate {
  public private(set) var terminal: Terminal!
  var process: LocalProcess!
  
  public init (queue: DispatchQueue? = nil, options: TerminalOptions = TerminalOptions.default) {
      terminal = Terminal(delegate: self, options: options)
      process = LocalProcess(delegate: self, dispatchQueue: queue)
  }
  
  public func processTerminated(_ source: LocalProcess, exitCode: Int32?) {
    exit(exitCode ?? 1)
  }
  
  public func dataReceived(slice: ArraySlice<UInt8>) {
    terminal.feed(buffer: slice)
  }
  
  func execute(_ command: String) {
    print("Running \(command)")
    process.send(data: ([UInt8] ((command + "\r\n").utf8))[...])
  }

  public func send(source: Terminal, data: ArraySlice<UInt8>) {
    process.send(data: data)
  }

  public func getWindowSize() -> winsize {
      return winsize(ws_row: UInt16(terminal.rows), ws_col: UInt16(terminal.cols), ws_xpixel: UInt16 (16), ws_ypixel: UInt16 (16))
  }
}

let headless = HeadlessTerminal()
headless.process.startProcess(executable: "/bin/bash", args: [ "--norc", "--noprofile", "--noediting"])

var idx = 0
while true {
  print("Enter command to run (default 'echo hello'):")
  var command = readLine() ?? ""
  command = command.count > 0 ? command : "echo hello"
  if (command == "exit") {
    headless.execute("exit")
  }

  print("Enter number of times to run (default 1):")
  let n = Int(readLine() ?? "") ?? 1

  for _ in 1...n {
    headless.execute("\(command) > /tmp/\(idx).txt")
    idx += 1
  }
}
