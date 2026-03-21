#!/usr/bin/swift

import AppKit
import Foundation
import ImageIO
import UniformTypeIdentifiers

enum IconError: Error, CustomStringConvertible {
    case missingOutputPath
    case failedToRenderPNG

    var description: String {
        switch self {
        case .missingOutputPath:
            return "missing output path"
        case .failedToRenderPNG:
            return "failed to render PNG data"
        }
    }
}

struct WakeIconRenderer {
    func render(size canvasSize: CGFloat) -> NSImage {
        let image = NSImage(size: NSSize(width: canvasSize, height: canvasSize))
        image.lockFocus()
        defer { image.unlockFocus() }

        guard let context = NSGraphicsContext.current else {
            return image
        }

        context.imageInterpolation = .high
        context.shouldAntialias = true

        let bounds = CGRect(x: 0, y: 0, width: canvasSize, height: canvasSize)
        let inset = canvasSize * 0.055
        let outerBounds = bounds.insetBy(dx: inset, dy: inset)
        let cornerRadius = canvasSize * 0.215

        let backgroundPath = NSBezierPath(roundedRect: outerBounds, xRadius: cornerRadius, yRadius: cornerRadius)
        NSGradient(
            colors: [
                NSColor(calibratedRed: 0.09, green: 0.12, blue: 0.22, alpha: 1.0),
                NSColor(calibratedRed: 0.03, green: 0.05, blue: 0.10, alpha: 1.0),
            ]
        )?.draw(in: backgroundPath, angle: 90)

        backgroundPath.lineWidth = canvasSize * 0.008
        NSColor(calibratedWhite: 1.0, alpha: 0.08).setStroke()
        backgroundPath.stroke()

        let clipPath = NSBezierPath(roundedRect: outerBounds, xRadius: cornerRadius, yRadius: cornerRadius)
        clipPath.addClip()

        let center = CGPoint(x: canvasSize * 0.50, y: canvasSize * 0.50)
        let sunRadius = canvasSize * 0.18

        let glowRect = CGRect(
            x: center.x - canvasSize * 0.30,
            y: center.y - canvasSize * 0.24,
            width: canvasSize * 0.60,
            height: canvasSize * 0.60
        )
        let glowPath = NSBezierPath(ovalIn: glowRect)
        NSGradient(
            colors: [
                NSColor(calibratedRed: 0.98, green: 0.66, blue: 0.18, alpha: 0.50),
                NSColor(calibratedRed: 0.98, green: 0.66, blue: 0.18, alpha: 0.0),
            ]
        )?.draw(in: glowPath, angle: 90)

        let rayColor = NSColor(calibratedRed: 1.00, green: 0.76, blue: 0.30, alpha: 0.88)
        let rayWidth = canvasSize * 0.040
        let rayLength = canvasSize * 0.155
        let rayBase = CGRect(
            x: center.x - rayWidth / 2,
            y: center.y + sunRadius * 0.75,
            width: rayWidth,
            height: rayLength
        )

        for angle in stride(from: -38.0, through: 38.0, by: 19.0) {
            let rayPath = NSBezierPath(roundedRect: rayBase, xRadius: rayWidth / 2, yRadius: rayWidth / 2)
            let transform = NSAffineTransform()
            transform.translateX(by: center.x, yBy: center.y)
            transform.rotate(byDegrees: CGFloat(angle))
            transform.translateX(by: -center.x, yBy: -center.y)
            rayPath.transform(using: transform as AffineTransform)
            rayColor.setFill()
            rayPath.fill()
        }

        let sunFrame = CGRect(
            x: center.x - sunRadius,
            y: center.y - sunRadius + canvasSize * 0.01,
            width: sunRadius * 2,
            height: sunRadius * 2
        )
        let sunPath = NSBezierPath(ovalIn: sunFrame)
        NSColor(calibratedRed: 0.98, green: 0.58, blue: 0.12, alpha: 1.0).setFill()
        sunPath.fill()

        let sunHighlight = NSBezierPath(
            ovalIn: sunFrame.insetBy(dx: canvasSize * 0.045, dy: canvasSize * 0.055)
        )
        NSColor(calibratedRed: 1.00, green: 0.85, blue: 0.34, alpha: 0.35).setFill()
        sunHighlight.fill()

        let horizonHeight = canvasSize * 0.15
        let horizonRect = CGRect(
            x: canvasSize * 0.18,
            y: canvasSize * 0.31,
            width: canvasSize * 0.64,
            height: horizonHeight
        )
        let horizonPath = NSBezierPath(
            roundedRect: horizonRect,
            xRadius: horizonHeight / 2,
            yRadius: horizonHeight / 2
        )

        let horizonGradient = NSGradient(
            colors: [
                NSColor(calibratedRed: 0.06, green: 0.08, blue: 0.14, alpha: 0.96),
                NSColor(calibratedRed: 0.03, green: 0.04, blue: 0.08, alpha: 0.98),
            ]
        )
        horizonGradient?.draw(in: horizonPath, angle: -90)

        let horizonStroke = NSBezierPath(
            roundedRect: horizonRect.insetBy(dx: canvasSize * 0.005, dy: canvasSize * 0.005),
            xRadius: horizonHeight / 2,
            yRadius: horizonHeight / 2
        )
        NSColor(calibratedRed: 0.99, green: 0.68, blue: 0.20, alpha: 0.22).setStroke()
        horizonStroke.lineWidth = canvasSize * 0.006
        horizonStroke.stroke()

        let sparkCenter = CGPoint(x: canvasSize * 0.72, y: canvasSize * 0.74)
        let sparkSize = canvasSize * 0.038
        let sparkPath = NSBezierPath()
        sparkPath.move(to: CGPoint(x: sparkCenter.x, y: sparkCenter.y + sparkSize))
        sparkPath.line(to: CGPoint(x: sparkCenter.x, y: sparkCenter.y - sparkSize))
        sparkPath.move(to: CGPoint(x: sparkCenter.x - sparkSize, y: sparkCenter.y))
        sparkPath.line(to: CGPoint(x: sparkCenter.x + sparkSize, y: sparkCenter.y))
        sparkPath.move(to: CGPoint(x: sparkCenter.x - sparkSize * 0.7, y: sparkCenter.y + sparkSize * 0.7))
        sparkPath.line(to: CGPoint(x: sparkCenter.x + sparkSize * 0.7, y: sparkCenter.y - sparkSize * 0.7))
        sparkPath.move(to: CGPoint(x: sparkCenter.x - sparkSize * 0.7, y: sparkCenter.y - sparkSize * 0.7))
        sparkPath.line(to: CGPoint(x: sparkCenter.x + sparkSize * 0.7, y: sparkCenter.y + sparkSize * 0.7))
        NSColor(calibratedWhite: 1.0, alpha: 0.88).setStroke()
        sparkPath.lineWidth = canvasSize * 0.008
        sparkPath.lineCapStyle = .round
        sparkPath.stroke()

        return image
    }
}

func writePNG(_ image: NSImage, to outputURL: URL) throws {
    guard let tiff = image.tiffRepresentation,
          let representation = NSBitmapImageRep(data: tiff),
          let pngData = representation.representation(using: .png, properties: [:]) else {
        throw IconError.failedToRenderPNG
    }

    try pngData.write(to: outputURL, options: .atomic)
}

do {
    let arguments = CommandLine.arguments
    guard arguments.count >= 2 else {
        throw IconError.missingOutputPath
    }

    let outputURL = URL(fileURLWithPath: arguments[1], isDirectory: false)
    let outputDirectory = outputURL.deletingLastPathComponent()
    try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)

    let renderer = WakeIconRenderer()
    if outputURL.pathExtension.lowercased() == "icns" {
        try writeICNS(renderer, to: outputURL)
    } else {
        let image = renderer.render(size: 1024)
        try writePNG(image, to: outputURL)
    }
} catch {
    fputs("Wake app icon generation failed: \(error)\n", stderr)
    exit(1)
}

func writeICNS(_ renderer: WakeIconRenderer, to outputURL: URL) throws {
    let sizes: [CGFloat] = [16, 32, 64, 128, 256, 512, 1024]
    guard let destination = CGImageDestinationCreateWithURL(
        outputURL as CFURL,
        UTType.icns.identifier as CFString,
        sizes.count,
        nil
    ) else {
        throw IconError.failedToRenderPNG
    }

    for size in sizes {
        let image = renderer.render(size: size)
        var proposedRect = NSRect(origin: .zero, size: NSSize(width: size, height: size))
        guard let cgImage = image.cgImage(forProposedRect: &proposedRect, context: nil, hints: nil) else {
            throw IconError.failedToRenderPNG
        }

        CGImageDestinationAddImage(destination, cgImage, nil)
    }

    guard CGImageDestinationFinalize(destination) else {
        throw IconError.failedToRenderPNG
    }
}
