import SwiftUI

func calculatePath(outer: Int, inner: Int, inset: Double) -> Path {
    var path = Path()
    let radius: Double = 1

    let greatestCommonDivisor = gcd(outer, inner)
    let divisor = inner / greatestCommonDivisor

    let scaleFactor: Double = radius / Double(outer)

    let a = Double(outer) * scaleFactor
    let b = Double(inner) * scaleFactor
    let h: Double = inset * scaleFactor

    let x1 = x(a, b: b, h: h, t: 0)
    let y1 = y(a, b: b, h: h, t: 0)
    path.move(to: CGPoint(x: x1, y: y1))
    let count = 1000
    for i in 0 ... (count * divisor) {
        let t = Double(i * 2) * .pi / Double(count)

        let x = x(a, b: b, h: h, t: t)
        let y = y(a, b: b, h: h, t: t)

        path.addLine(to: CGPoint(x: x, y: y))
    }
    return path
}

public struct Hypotrochoid: Shape {
    private var basePath: Path

    public func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.midY, rect.midX)

        let transform = CGAffineTransform(translationX: center.x, y: center.y)
            .scaledBy(x: radius, y: radius)
        return basePath.applying(transform)
    }
    var inner: Int
    var outer: Int
    var inset: Double {
        didSet {
            basePath = calculatePath(outer: outer, inner: inner, inset: inset)
        }
    }
    public var animatableData: Double {
        get { inset }
        set { inset = newValue }
    }

    public init(outer: Int, inner: Int, inset: Double) {
        self.inset = inset
        self.outer = outer
        self.inner = inner
        self.basePath = calculatePath(outer: outer, inner: inner, inset: inset)
    }
}

private func gcd(_ a: Int, _ b: Int) -> Int {
    b == 0 ? a : a > b ? gcd(a - b, b) : gcd(a, b - a)
}

private func x(_ a: CGFloat, b: CGFloat, h: CGFloat, t: CGFloat) -> CGFloat {
    (a - b) * cos(t) + h * cos(t * (a - b) / b)
}

private func y(_ a: CGFloat, b: CGFloat, h: CGFloat, t: CGFloat) -> CGFloat {
    (a - b) * sin(t) - h * sin(t * (a - b) / b)
}
