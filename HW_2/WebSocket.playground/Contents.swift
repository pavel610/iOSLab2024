import UIKit

@MainActor
final class SocketManager: NSObject {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession!

    override init() {
        super.init()
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    }
    
    func connect() {
        let url = URL(string: "wss://demo.piesocket.com/v3/channel_123?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self")!
        webSocketTask = urlSession.webSocketTask(with: URLRequest(url: url))
        webSocketTask?.resume()
    }
    
    func ping() {
        webSocketTask?.sendPing{ error in
            if let error = error {
                print(error)
            }
        }
    }
}

extension SocketManager: URLSessionWebSocketDelegate {
    private func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) async {
        print("Connected to socket")
    }
    
    @nonobjc func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("disconnected socket")
    }
}

var sm = SocketManager()
sm.connect()


