//
//  ImageCarouselVC.swift
//  DemoImageCarousel
//
//  Created by Priyanka Sahani on 01/09/24.
//

import UIKit
import SDWebImage

class ImageCarouselVC: UIViewController, UITextFieldDelegate {

     var ViewModel = CarouselViewModel()
     var users: [CarouselModel] = []
    var filteredItems: [CarouselModel] = []
   
    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var pagingImage: UIPageControl!
    @IBOutlet weak var searchTextField: TextField!
    @IBOutlet weak var carouselTableView: UITableView!
    @IBOutlet weak var optionBtn: UIButton!
    
    var currentPage = 0
    {
        didSet
        {
            pagingImage.currentPage = currentPage
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carouselTableView.delegate = self
        carouselTableView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        searchTextField.delegate = self
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 250)
        carouselCollectionView.collectionViewLayout = layout
        layout.minimumLineSpacing = 0
        carouselCollectionView.isPagingEnabled = true
        searchTextField.layer.cornerRadius = 12
        
        ViewModel.onUsersFetched = { [weak self] users in
                    self?.users = users
            self!.filteredItems = self!.users
            if self?.users.count ?? 0 > 1
            {
                self?.pagingImage.isHidden = false
                self?.pagingImage.numberOfPages = self?.users.count ?? 0
            }
            else
            {
                self?.pagingImage.isHidden = true
                
            }
                    self?.carouselTableView.reloadData()
                    self?.carouselCollectionView.reloadData()
        }
        
        ViewModel.fetchUsers()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            filterContentForSearchText(textField.text ?? "")
        }
        
        // MARK: - Filtering Logic
        
        func filterContentForSearchText(_ searchText: String) {
            if searchText.isEmpty {
                filteredItems = users
            } else {
                filteredItems = users.filter { item in
                    item.caption.lowercased().contains(searchText.lowercased())
                }
            }
            
            carouselTableView.reloadData()
        }
    
    
    
    @IBAction func optionBtnAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Options", message: "Choose an option", preferredStyle: .actionSheet)
                
        let option1 = UIAlertAction(title: "Option1", style: .default) { _ in
                    print("Option1 selected")
        }
                
        let option2 = UIAlertAction(title: "Option2", style: .default) { _ in
                    print("Option2 selected")
       }
                
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
        alertController.addAction(option1)
        alertController.addAction(option2)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


extension ImageCarouselVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = carouselCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCarouselCollectionViewCell", for: indexPath) as! ImageCarouselCollectionViewCell
        cell.carouselImage.sd_setImage(with: users[indexPath.item].imageUrl, placeholderImage: UIImage(named: "placeholder"))
        cell.carouselImage.layer.cornerRadius = 18
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let widht = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / widht)
        
    }
}

extension ImageCarouselVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = carouselTableView.dequeueReusableCell(withIdentifier: "ImageCarouselTableViewCell", for: indexPath) as! ImageCarouselTableViewCell
        cell.carouselImage.layer.cornerRadius = 10
        cell.carouselName.text = filteredItems[indexPath.row].caption
        cell.carouselSecondName.text = filteredItems[indexPath.row].caption
        cell.carouselImage.sd_setImage(with: filteredItems[indexPath.row].imageUrl)
        return cell
    }
}


class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
