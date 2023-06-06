//
//  TangramClassifier.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 5/8/23.
//

//import CoreML
//import Vision
//import UIKit
//
//
//public class TangramClassifier: ObservableObject {
//    private let model: VNCoreMLModel
//
//    public init?() {
//        guard let modelURL = Bundle.main.url(forResource: "Tangram", withExtension: "mlmodelc"),
//              let model = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else {
//            return nil
//        }
//        self.model = model
//    }
//
//    func classify(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let cgImage = image.cgImage else {
//            completion(.failure(ClassificationError.invalidImage))
//            return
//        }
//
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        let request = VNCoreMLRequest(model: model) { request, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let classification = request.results?.first as? VNClassificationObservation {
//                completion(.success(classification.identifier))
//            } else {
//                completion(.failure(ClassificationError.noResult))
//            }
//        }
//
//        do {
//            try handler.perform([request])
//        } catch {
//            completion(.failure(error))
//        }
//    }
//
//    enum ClassificationError: Error {
//        case invalidImage
//        case noResult
//    }
//}


//import UIKit
//import Vision
//import CoreML
//
//class TangramClassifier {
//    enum ClassificationError: Error {
//        case modelLoadingError
//        case imageConversionError
//        case requestExecutionError(String)
//    }
//
//    func classify(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let model = try? VNCoreMLModel(for: TangramClassifier1().model) else {
//            print("Error: Failed to load VNCoreMLModel")
//            completion(.failure(ClassificationError.modelLoadingError))
//            return
//        }
//
//        let request = VNCoreMLRequest(model: model) { request, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                completion(.failure(ClassificationError.requestExecutionError(error.localizedDescription)))
//                return
//            }
//
//            guard let results = request.results as? [VNClassificationObservation],
//                  let bestResult = results.first else {
//                print("Error: Failed to get classification results")
//                completion(.failure(ClassificationError.modelLoadingError))
//                return
//            }
//
//            completion(.success(bestResult.identifier))
//        }
//
//        let targetSize = CGSize(width: 299, height: 299) // 替换为适合您的模型的尺寸
//        let resizedImage = image.resize(targetSize: targetSize)
//        guard let resizedCGImage = resizedImage.cgImage else {
//            print("Error: Failed to convert resized UIImage to CGImage")
//            completion(.failure(ClassificationError.imageConversionError))
//            return
//        }
//
//        let handler = VNImageRequestHandler(cgImage: resizedCGImage, options: [:])
//        do {
//            try handler.perform([request])
//        } catch {
//            print("Error: Failed to perform classification request")
//            completion(.failure(ClassificationError.requestExecutionError(error.localizedDescription)))
//        }
//    }
//}
//
//extension UIImage {
//    func resize(targetSize: CGSize) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        let resizedImage = renderer.image { _ in
//            self.draw(in: CGRect(origin: .zero, size: targetSize))
//        }
//        return resizedImage
//    }
//}
//








import UIKit
import Vision
import CoreML

class TangramClassifier {
    enum ClassificationError: Error {
        case modelLoadingError
        case imageConversionError
        case requestExecutionError(String)
    }

    func classify(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let configuration = MLModelConfiguration()
            let model = try TangramClassifier1(configuration: configuration).model
            let modelContainer = try VNCoreMLModel(for: model)
            
            let request = VNCoreMLRequest(model: modelContainer) { request, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(ClassificationError.requestExecutionError(error.localizedDescription)))
                    return
                }

                guard let results = request.results as? [VNClassificationObservation],
                      let bestResult = results.first else {
                    print("Error: Failed to get classification results")
                    completion(.failure(ClassificationError.modelLoadingError))
                    return
                }

                completion(.success(bestResult.identifier))
            }

            let targetSize = CGSize(width: 299, height: 299) // 替换为适合您的模型的尺寸
            let resizedImage = image.resize(targetSize: targetSize)
            guard let resizedCGImage = resizedImage.cgImage else {
                print("Error: Failed to convert resized UIImage to CGImage")
                completion(.failure(ClassificationError.imageConversionError))
                return
            }

            let handler = VNImageRequestHandler(cgImage: resizedCGImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("Error: Failed to perform classification request")
                completion(.failure(ClassificationError.requestExecutionError(error.localizedDescription)))
            }
        } catch {
            print("Error: Failed to load VNCoreMLModel")
            completion(.failure(ClassificationError.modelLoadingError))
        }
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }
}
