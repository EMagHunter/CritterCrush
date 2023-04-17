//
//  SpeciesDetailViewController.swift
//  CritterCrush
//  Created by min joo on 3/9/23.
//

import UIKit

class SpeciesDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var speciesName: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bugDescribe: UILabel!
    
    var titleStringViaSegue: String!
    var bugID: Int!
    
    //bug naming convention:
    //id_species{ID}_{0}.png
    var images: [String] = []
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //API
    var apiURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.speciesName.text = self.titleStringViaSegue
        
        scrollView.delegate = self
        
        let bug: Int = bugID
        images = ["id_species\(bug)_1","id_species\(bug)_2","id_species\(bug)_3"]
        
        // Do any additional setup after loading the view.
        //image scrolling gallery
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[index])
           
            self.scrollView.addSubview(imageView)
            self.scrollView.contentMode = .scaleAspectFill
            
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
        //SCROLL
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        //self.scrollView.bringSubviewToFront(pageControl)
        style()
        
        /*
        //text
        self.bugDescribe.text = "\(speciesList[(bug - 1)].desc)\n\(speciesList[(bug - 1)].risk)\nFrom: \(speciesList[(bug - 1)].link)"
        */
        
        //text
        self.bugDescribe.text = "\(speciesList[(bug - 1)].desc)\nFrom: \(speciesList[(bug - 1)].link)"
        
    }//view
    
    func style(){
        self.scrollView.contentMode = .scaleAspectFill
        self.scrollView.layer.masksToBounds = true
        self.scrollView.layer.cornerRadius = 10
        self.scrollView.contentMode = .scaleAspectFill
        
        self.topView.layer.shadowColor = UIColor.black.cgColor
        self.topView.layer.shadowOpacity = 0.3
        self.topView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.topView.layer.shadowRadius = 15
        self.topView.layer.cornerRadius = 20
        

    }
    //Image scrolling
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var page = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(page)
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
