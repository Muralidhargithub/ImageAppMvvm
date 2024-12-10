//
//  PhotoViewModel.swift
//  ImageAppMvvm
//
//  Created by Muralidhar reddy Kakanuru on 12/9/24.
//



import UIKit

class PhotoViewModel {
    // MARK: - Dependencies
    private let photoService: ImageDef = ImageNetwork.sharedInstance

    // MARK: - Properties
    private var photos: [Photo] = []
    private var imageCache: [URL: UIImage] = [:]

    // MARK: - Closures for Updates
    var onPhotosFetchSuccess: (() -> Void)?
    var onPhotosFetchFailure: ((String) -> Void)?

    // MARK: - Fetch Photos
    func fetchPhotos() {
        guard let url = URL(string: commonUrl.baseURL) else {
            onPhotosFetchFailure?("Invalid URL")
            return
        }

        photoService.getData(url: url.absoluteString) { [weak self] (result: [Photo]?) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let fetchedPhotos = result {
                    self.photos = fetchedPhotos // Store fetched photos internally
                    self.onPhotosFetchSuccess?() // Notify the view
                } else {
                    self.onPhotosFetchFailure?("Failed to fetch data or decode response.")
                }
            }
        }
    }

    // MARK: - Accessors
    func numberOfRows() -> Int {
        return photos.count
    }

    func photo(at index: Int) -> Photo? {
        guard index >= 0 && index < photos.count else { return nil }
        return photos[index]
    }

    // MARK: - Load Image
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Return cached image if available
        if let cachedImage = imageCache[url] {
            completion(cachedImage)
            return
        }

        // Fetch image from network
        photoService.getImage(url: url.absoluteString) { [weak self] image in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let image = image {
                    self.imageCache[url] = image // Cache the image
                }
                completion(image)
            }
        }
    }
    
    // MARK: - Photo Details
    func getPhotoDetails(at index: Int) -> (photo: Photo, loadImage: (@escaping (UIImage?) -> Void) -> Void)? {
        guard let selectedPhoto = photo(at: index) else { return nil }

        let loadImage: (@escaping (UIImage?) -> Void) -> Void = { [weak self] completion in
            guard let self = self, let url = URL(string: selectedPhoto.url ?? "") else {
                completion(nil)
                return
            }
            self.loadImage(from: url, completion: completion)
        }

        return (photo: selectedPhoto, loadImage: loadImage)
    }
}
