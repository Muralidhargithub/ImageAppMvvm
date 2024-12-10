import UIKit

class PhotoDetailViewController: UIViewController {
    // MARK: - Properties
    private let photo: Photo

    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializer
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureView()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Configure View
    private func configureView() {
        if let urlString = photo.url, let url = URL(string: urlString) {
            // Assuming you have a way to load an image from URL (e.g., viewModel.loadImage)
            PhotoViewModel().loadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }

        descriptionLabel.text = """
        Photo ID: \(photo.id ?? 0)
        Album ID: \(photo.albumId ?? 0)
        Title: \(photo.title ?? "No Title")
        """
    }
}
