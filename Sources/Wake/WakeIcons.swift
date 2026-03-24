import AppKit
import SwiftUI

enum WakeIconKind {
    case statusActive
    case statusInactive
}

struct WakeIconView: View {
    let kind: WakeIconKind

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let lineWidth = max(size * 0.1, 1.4)

            ZStack {
                switch kind {
                case .statusActive:
                    sunriseIcon(size: size, lineWidth: lineWidth, slashed: false)
                case .statusInactive:
                    sunriseIcon(size: size, lineWidth: lineWidth, slashed: true)
                }
            }
            .frame(width: size, height: size)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityHidden(true)
    }

    private func sunriseIcon(size: CGFloat, lineWidth: CGFloat, slashed: Bool) -> some View {
        ZStack {
            Path { path in
                path.move(to: point(0.18, 0.72, in: size))
                path.addLine(to: point(0.82, 0.72, in: size))
            }
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            Path { path in
                path.addArc(
                    center: point(0.5, 0.72, in: size),
                    radius: size * 0.18,
                    startAngle: .degrees(180),
                    endAngle: .degrees(360),
                    clockwise: false
                )
            }
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            ray(from: point(0.5, 0.18, in: size), to: point(0.5, 0.34, in: size), lineWidth: lineWidth)
            ray(from: point(0.3, 0.28, in: size), to: point(0.38, 0.40, in: size), lineWidth: lineWidth)
            ray(from: point(0.7, 0.28, in: size), to: point(0.62, 0.40, in: size), lineWidth: lineWidth)

            if slashed {
                Path { path in
                    path.move(to: point(0.23, 0.2, in: size))
                    path.addLine(to: point(0.77, 0.8, in: size))
                }
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            }
        }
        .scaleEffect(0.95)
    }

    private func ray(from start: CGPoint, to end: CGPoint, lineWidth: CGFloat) -> some View {
        Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
        .stroke(style: StrokeStyle(lineWidth: lineWidth * 0.92, lineCap: .round))
    }

    private func point(_ x: CGFloat, _ y: CGFloat, in size: CGFloat) -> CGPoint {
        CGPoint(x: size * x, y: size * y)
    }
}

@MainActor
enum WakeStatusIconRenderer {
    static func makeImage(isActive: Bool, size: NSSize, accessibilityDescription: String) -> NSImage? {
        let icon = WakeIconView(kind: isActive ? .statusActive : .statusInactive)
            .frame(width: size.width, height: size.height)
            .foregroundStyle(.black)

        let renderer = ImageRenderer(content: icon)
        renderer.scale = NSScreen.main?.backingScaleFactor ?? 2

        guard let image = renderer.nsImage else {
            return nil
        }

        image.isTemplate = true
        image.accessibilityDescription = accessibilityDescription
        return image
    }
}
