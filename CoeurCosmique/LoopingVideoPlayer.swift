import SwiftUI
import AVFoundation

struct LoopingVideoPlayer: UIViewRepresentable {
    let fileName: String

    func makeUIView(context: Context) -> LoopingPlayerUIView {
        LoopingPlayerUIView(fileName: fileName)
    }

    func updateUIView(_ uiView: LoopingPlayerUIView, context: Context) {}

    class LoopingPlayerUIView: UIView {
        private var playerLayer = AVPlayerLayer()
        private var playerLooper: AVPlayerLooper?

        init(fileName: String) {
            super.init(frame: .zero)
            backgroundColor = .clear

            guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") else { return }

            let asset = AVAsset(url: url)
            let item = AVPlayerItem(asset: asset)
            let player = AVQueuePlayer(playerItem: item)

            playerLooper = AVPlayerLooper(player: player, templateItem: item)

            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.backgroundColor = UIColor.clear.cgColor
            layer.addSublayer(playerLayer)

            player.isMuted = true
            player.play()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            playerLayer.frame = bounds
        }
    }
}
