import UIKit

class TrainingTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    //Remove the title of the back button
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
    tableView.separatorColor = UIColor.estonianBlue.opacity(percentage: 50)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //Prevent from hiding the bar on swipe
    navigationController?.hidesBarsOnSwipe = false
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Automatically deselect cell when touched
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
