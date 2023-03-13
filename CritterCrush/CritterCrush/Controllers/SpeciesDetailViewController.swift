//
//  SpeciesDetailViewController.swift
//  CritterCrush
//horizontal gallery:
//https://github.com/zhiyao92/Horizontal-Sliding-Image
//images:
//https://www.dec.ny.gov/animals/113303.html
//  Created by min joo on 3/9/23.
//

import UIKit

class SpeciesDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var speciesName: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var titleStringViaSegue: String!
    var bugID: Int!
    
    //bug naming convention:
    //id_species{ID}_{0}.png
    var images: [String] = []
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.speciesName.text = self.titleStringViaSegue
        
        
        if (bugID == 1){
            //images = ["id_species\(bugID)_1","id_species\(bugID)_2","id_species\(bugID)_3"]
            images = ["id_species1_1","id_species1_2","id_species1_3"]
        }
        
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
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    //Image scrolling
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var page = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(page)
        }
    
    //detail information
    //do API calls
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
