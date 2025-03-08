import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Add a custom top nav
        let topNav = TopNavigationView()
        topNav.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topNav)
        
        NSLayoutConstraint.activate([
            topNav.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topNav.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topNav.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topNav.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // The rest of your HomeViewController UI can go below
    }
}
