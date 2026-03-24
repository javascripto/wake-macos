import AppKit

@MainActor
enum WakeStatusIconRenderer {
    static func makeImage(isActive: Bool, size: NSSize, accessibilityDescription: String) -> NSImage? {
        let image = NSImage(size: size)
        image.isTemplate = true
        image.accessibilityDescription = accessibilityDescription
        image.lockFocus()
        defer { image.unlockFocus() }

        let strokeColor = NSColor.black
        strokeColor.setStroke()

        let canvasSize = min(size.width, size.height) * 0.95
        let origin = CGPoint(
            x: (size.width - canvasSize) / 2,
            y: (size.height - canvasSize) / 2
        )
        let lineWidth = max(canvasSize * 0.1, 1.4)

        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(
                x: origin.x + canvasSize * x,
                y: origin.y + canvasSize * (1 - y)
            )
        }

        func strokeLine(from start: CGPoint, to end: CGPoint, width: CGFloat) {
            let path = NSBezierPath()
            path.move(to: start)
            path.line(to: end)
            path.lineWidth = width
            path.lineCapStyle = .round
            path.stroke()
        }

        strokeLine(from: point(0.18, 0.72), to: point(0.82, 0.72), width: lineWidth)

        let arc = NSBezierPath()
        arc.appendArc(
            withCenter: point(0.5, 0.72),
            radius: canvasSize * 0.18,
            startAngle: 180,
            endAngle: 0,
            clockwise: true
        )
        arc.lineWidth = lineWidth
        arc.lineCapStyle = .round
        arc.stroke()

        strokeLine(from: point(0.5, 0.18), to: point(0.5, 0.34), width: lineWidth * 0.92)
        strokeLine(from: point(0.3, 0.28), to: point(0.38, 0.40), width: lineWidth * 0.92)
        strokeLine(from: point(0.7, 0.28), to: point(0.62, 0.40), width: lineWidth * 0.92)

        if !isActive {
            strokeLine(from: point(0.23, 0.2), to: point(0.77, 0.8), width: lineWidth)
        }

        return image
    }
}
