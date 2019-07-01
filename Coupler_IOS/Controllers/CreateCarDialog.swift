
import UIKit
import Alamofire

protocol CreateCarDialogDismissDelegate: class {
    func Dismiss(index: Int, selectionCategory: String)
}
class CreateCarDialog: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var filterTable: UITableView!
    @IBOutlet weak var filterName: UILabel!
    var selectonItem = [String?]()
    
    var selectionCategory = String()
    var index = [IndexPath]()
    
    var delegate: CreateCarDialogDismissDelegate?
    
    
    let constants = Constants()
    let utils = Utils()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        utils.setBorder(view: filterTable, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.0417380137), borderWidth: 2, cornerRadius: 4)
        filterTable.tableFooterView = UIView()
        filterTable.rowHeight = UITableView.automaticDimension
        self.definesPresentationContext = true
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectonItem.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isSelected{
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createCarCell", for: indexPath) as! CreateCarCell
        let filterService = selectonItem[indexPath.section]
        utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.0417380137), borderWidth: 1, cornerRadius: 4)
        cell.serviceName.text = filterService
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: CreateCarCell = tableView.cellForRow(at: indexPath) as! CreateCarCell
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
            
        }, completion:nil)
        delegate?.Dismiss(index: indexPath.section, selectionCategory: self.selectionCategory)
        dismiss(animated: true, completion: nil)
       
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: CreateCarCell = tableView.cellForRow(at: indexPath) as! CreateCarCell
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1)
            
        }, completion:nil)
      
    }
    
    
    @IBAction func canselBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
