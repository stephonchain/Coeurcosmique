import SwiftUI
import PDFKit

// MARK: - Guided Prompt Card

struct GuidedPromptCard: View {
    let prompt: String
    let cardName: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.cosmicGold)
                .padding(10)
                .background(
                    Circle()
                        .fill(Color.cosmicGold.opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Réflexion guidée")
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicGold)
                    .textCase(.uppercase)
                
                Text(prompt)
                    .font(.cosmicBody(14))
                    .foregroundStyle(Color.cosmicText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cosmicGold.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.cosmicGold.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Tag Pill

struct TagPill: View {
    let tag: JournalTag
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: tag.icon)
                    .font(.system(size: 10))
                
                Text(tag.rawValue)
                    .font(.cosmicCaption(12))
            }
            .foregroundStyle(isSelected ? .white : tag.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isSelected ? tag.color : tag.color.opacity(0.15))
            )
            .overlay(
                Capsule()
                    .strokeBorder(tag.color.opacity(isSelected ? 0 : 0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - PDF Export

class JournalPDFExporter {
    
    static func generatePDF(
        entries: [ReadingHistoryEntry],
        title: String = "Mon Journal Cosmique"
    ) -> URL? {
        let pageSize = CGSize(width: 612, height: 792) // Letter size
        let margin: CGFloat = 50
        let contentWidth = pageSize.width - (margin * 2)
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("Journal_\(Date().formatted(date: .numeric, time: .omitted)).pdf")
        
        do {
            try renderer.writePDF(to: tempURL) { context in
                var yPosition: CGFloat = margin
                
                // Title page
                context.beginPage()
                drawText(
                    title,
                    at: CGPoint(x: margin, y: yPosition),
                    width: contentWidth,
                    font: UIFont.systemFont(ofSize: 28, weight: .bold),
                    color: .label
                )
                yPosition += 50
                
                drawText(
                    "Généré le \(Date().formatted(date: .long, time: .omitted))",
                    at: CGPoint(x: margin, y: yPosition),
                    width: contentWidth,
                    font: UIFont.systemFont(ofSize: 12, weight: .regular),
                    color: .secondaryLabel
                )
                
                // Entries
                for (index, entry) in entries.enumerated() {
                    // Start new page if needed
                    if yPosition > pageSize.height - 200 || index > 0 {
                        context.beginPage()
                        yPosition = margin
                    } else {
                        yPosition += 60
                    }
                    
                    // Date
                    drawText(
                        entry.createdAt.formatted(date: .long, time: .shortened),
                        at: CGPoint(x: margin, y: yPosition),
                        width: contentWidth,
                        font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                        color: .label
                    )
                    yPosition += 25
                    
                    // Spread title
                    drawText(
                        entry.spread.title,
                        at: CGPoint(x: margin, y: yPosition),
                        width: contentWidth,
                        font: UIFont.systemFont(ofSize: 16, weight: .bold),
                        color: .label
                    )
                    yPosition += 30
                    
                    // Question
                    if !entry.question.isEmpty {
                        drawText(
                            "Question: \(entry.question)",
                            at: CGPoint(x: margin, y: yPosition),
                            width: contentWidth,
                            font: UIFont.italicSystemFont(ofSize: 13),
                            color: .secondaryLabel
                        )
                        yPosition += 25
                    }
                    
                    // Cards
                    let cardsText = "Cartes: \(entry.cardNames.joined(separator: ", "))"
                    drawText(
                        cardsText,
                        at: CGPoint(x: margin, y: yPosition),
                        width: contentWidth,
                        font: UIFont.systemFont(ofSize: 12),
                        color: .secondaryLabel
                    )
                    yPosition += 30
                    
                    // Notes
                    if !entry.notes.isEmpty {
                        let notesHeight = drawText(
                            entry.notes,
                            at: CGPoint(x: margin, y: yPosition),
                            width: contentWidth,
                            font: UIFont.systemFont(ofSize: 13),
                            color: .label
                        )
                        yPosition += notesHeight + 20
                    }
                    
                    // Separator
                    context.cgContext.setStrokeColor(UIColor.separator.cgColor)
                    context.cgContext.setLineWidth(0.5)
                    context.cgContext.move(to: CGPoint(x: margin, y: yPosition))
                    context.cgContext.addLine(to: CGPoint(x: pageSize.width - margin, y: yPosition))
                    context.cgContext.strokePath()
                    yPosition += 20
                }
            }
            
            return tempURL
        } catch {
            print("Error generating PDF: \(error)")
            return nil
        }
    }
    
    @discardableResult
    private static func drawText(
        _ text: String,
        at point: CGPoint,
        width: CGFloat,
        font: UIFont,
        color: UIColor
    ) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .left
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let textSize = attributedText.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            context: nil
        ).size
        
        attributedText.draw(in: CGRect(origin: point, size: CGSize(width: width, height: textSize.height)))
        
        return textSize.height
    }
}
