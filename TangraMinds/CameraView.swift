//
//  CameraView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 4/15/23.
//

//import SwiftUI
//import AVFoundation
//
//struct CameraView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let viewController = UIViewController()
//        let captureSession = AVCaptureSession()
//
//        guard let captureDevice = AVCaptureDevice.default(for: .video),
//              let input = try? AVCaptureDeviceInput(device: captureDevice),
//              captureSession.canAddInput(input) else { return viewController }
//
//        captureSession.addInput(input)
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = viewController.view.layer.bounds
//        viewController.view.layer.addSublayer(previewLayer)
//
//        captureSession.startRunning()
//
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//}
//
//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView()
//    }
//}
import SwiftUI
import AVFoundation
import Photos

struct CameraView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice),
              captureSession.canAddInput(input) else { return viewController }

        captureSession.addInput(input)

        let photoOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            context.coordinator.photoOutput = photoOutput
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        viewController.view.layer.addSublayer(previewLayer)

        captureSession.startRunning()

        let captureButton = UIButton(type: .system)
        captureButton.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        captureButton.tintColor = .white
        captureButton.addTarget(context.coordinator, action: #selector(Coordinator.capturePhoto), for: .touchUpInside)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(captureButton)
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView
        var photoOutput: AVCapturePhotoOutput?

        init(_ parent: CameraView) {
            self.parent = parent
        }

        @objc func capturePhoto() {
            guard let photoOutput = photoOutput else { return }
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                print("Error capturing photo: \(error.localizedDescription)")
            } else {
                guard let imageData = photo.fileDataRepresentation(),
                      let image = UIImage(data: imageData) else { return }

                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: { success, error in
                    if success {
                        print("Photo saved to library")
                    } else {
                        print("Error saving photo: \(error?.localizedDescription ?? "Unknown error")")
                    }
                })
            }
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
