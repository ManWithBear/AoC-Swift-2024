struct Point: Hashable {
    let x: Int
    let y: Int
}
extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

func numberOfDigits(in number: Int) -> Int {
    String(number).count
}
