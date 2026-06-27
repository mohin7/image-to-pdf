import PDFKit
import UIKit

class PDFKitService {

  // MARK: - Page Count

  func pageCount(path: String) throws -> Int {
    guard let doc = PDFDocument(url: URL(fileURLWithPath: path)) else {
      throw PDFKitError.invalidDocument(path)
    }
    return doc.pageCount
  }

  // MARK: - Merge

  func merge(paths: [String], outputPath: String) throws -> String {
    let merged = PDFDocument()
    for path in paths {
      guard let doc = PDFDocument(url: URL(fileURLWithPath: path)) else {
        throw PDFKitError.invalidDocument(path)
      }
      for i in 0 ..< doc.pageCount {
        if let page = doc.page(at: i) {
          merged.insert(page, at: merged.pageCount)
        }
      }
    }
    let outURL = URL(fileURLWithPath: outputPath)
    guard merged.write(to: outURL) else {
      throw PDFKitError.writeFailed(outputPath)
    }
    return outputPath
  }

  // MARK: - Split (extract page subset)

  func split(path: String, pageIndexes: [Int], outputPath: String) throws -> String {
    guard let doc = PDFDocument(url: URL(fileURLWithPath: path)) else {
      throw PDFKitError.invalidDocument(path)
    }
    let result = PDFDocument()
    for idx in pageIndexes {
      guard idx >= 0 && idx < doc.pageCount, let page = doc.page(at: idx) else { continue }
      result.insert(page, at: result.pageCount)
    }
    let outURL = URL(fileURLWithPath: outputPath)
    guard result.write(to: outURL) else {
      throw PDFKitError.writeFailed(outputPath)
    }
    return outputPath
  }

  // MARK: - Compress (re-render pages at lower image quality)

  func compress(path: String, quality: CGFloat, outputPath: String) throws -> String {
    guard let doc = PDFDocument(url: URL(fileURLWithPath: path)) else {
      throw PDFKitError.invalidDocument(path)
    }

    let result = PDFDocument()
    for i in 0 ..< doc.pageCount {
      guard let page = doc.page(at: i) else { continue }
      let bounds = page.bounds(for: .mediaBox)

      // Render page to UIImage at 150 DPI (compressed from native 72 DPI render default)
      let scale: CGFloat = quality > 0.6 ? 1.5 : (quality > 0.3 ? 1.0 : 0.75)
      let size = CGSize(width: bounds.width * scale, height: bounds.height * scale)

      let renderer = UIGraphicsImageRenderer(size: size)
      let image = renderer.image { ctx in
        UIColor.white.setFill()
        ctx.fill(CGRect(origin: .zero, size: size))
        ctx.cgContext.scaleBy(x: scale, y: scale)
        page.draw(with: .mediaBox, to: ctx.cgContext)
      }

      guard let jpegData = image.jpegData(compressionQuality: quality),
            let compressed = UIImage(data: jpegData),
            let newPage = PDFPage(image: compressed)
      else { continue }

      result.insert(newPage, at: result.pageCount)
    }

    let outURL = URL(fileURLWithPath: outputPath)
    guard result.write(to: outURL) else {
      throw PDFKitError.writeFailed(outputPath)
    }
    return outputPath
  }
}

// MARK: - Errors

enum PDFKitError: Error {
  case invalidDocument(String)
  case writeFailed(String)

  var localizedDescription: String {
    switch self {
    case .invalidDocument(let path): return "Could not open PDF at \(path)"
    case .writeFailed(let path): return "Could not write PDF to \(path)"
    }
  }
}
