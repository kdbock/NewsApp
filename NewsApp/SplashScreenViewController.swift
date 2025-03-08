import UIKit

class SplashScreenViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "neusenewslogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = BrandColors.gold
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(logoImageView)
        view.addSubview(getStartedButton)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),

            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            getStartedButton.widthAnchor.constraint(equalToConstant: 140),
            getStartedButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        getStartedButton.addTarget(self, action: #selector(didTapGetStarted), for: .touchUpInside)
    }

    @objc private func didTapGetStarted() {
        // Create your main Nav Controller or Tab Bar here
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}
