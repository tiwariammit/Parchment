import UIKit
import Parchment

// Create our own custom paging view and override the layout
// constraints. The default implementation positions the menu view
// above the page view controller, but since we're going to put the
// menu view inside the navigation bar we don't want to setup any
// layout constraints for the menu view.
class CustomPagingView: PagingView {
  
  override func setupConstraints() {
    // Use our convenience extension to constrain the page view to all
    // of the edges of the super view.
    constrainToEdges(pageView)
  }
}

// Create a custom paging view controller and override the view with
// our own custom subclass.
class CustomPagingViewController: FixedPagingViewController {
  override func loadView() {
    view = CustomPagingView(
      pageView: pageViewController.view,
      collectionView: collectionView,
      options: options)
  }
}

// Create our own custom theme
struct Theme: PagingTheme {
  let headerBackgroundColor = UIColor.clear
  let indicatorColor = UIColor(white: 0, alpha: 0.4)
  let textColor = UIColor(white: 1, alpha: 0.6)
  let selectedTextColor = UIColor.white
}

// We need create our own options struct so that we can customize it
// to our needs. We want to remove the bottom border as well as
// changing the height of the menu view.
struct Options: PagingOptions {
  let theme: PagingTheme = Theme()
  let borderOptions: PagingBorderOptions = .hidden
  let menuItemSize: PagingMenuItemSize = .fixed(width: 100, height: 44)
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create some view controllers that we're going to display
    let viewControllers = (0...5).map { IndexViewController(index: $0) }
    
    // Initialize our custom paging view controller with our options
    let pagingViewController = CustomPagingViewController(
      viewControllers: viewControllers,
      options: Options())
    
    // Make sure you add the PagingViewController as a child view
    // controller and contrain it to the edges of the view.
    addChildViewController(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParentViewController: self)
    
    // Set the menu view as the title view on the navigation bar. This
    // will remove the menu view from the view hierachy and put it
    // into the navigation bar.
    navigationItem.titleView = pagingViewController.collectionView
  }

  override func viewDidLayoutSubviews() {
    // Update the frame of the menu view based on the size of the
    // navigation bar.
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationItem.titleView?.frame = CGRect(origin: .zero, size: navigationBar.bounds.size)
  }
  
}
