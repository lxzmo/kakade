import Flutter

class FullScreenFlutterViewController: FlutterViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.modalPresentationStyle = .fullScreen
    }
}
