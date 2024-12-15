struct Point: Hashable {
    let x: Int
    let y: Int
}
extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}
