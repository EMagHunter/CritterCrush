//
//  SpeciesDetailViewController.swift
//  CritterCrush
//  Created by min joo on 3/9/23.
//

import UIKit

class SpeciesDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var speciesName: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
        //SCROLL
        
        apiURL = wikiMedia()
        apiCall(url:apiURL!)
        
    }
    
    //Image scrolling
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var page = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(page)
        }
    
    //detail information
    //MARK: do API calls
    func wikiMedia() -> URL {
        var bugName = ""
        
        if let i = speciesList.firstIndex(where: { $0.id == bugID }) {
            bugName = speciesList[i].name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        }
        
        let urlSearch = String("https://en.wikipedia.org/w/api.php?action=query&exlimit=1&explaintext=1&exsentences=3&formatversion=2&prop=extracts&titles=\(bugName)&format=json")
        
       let wikiURL = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts%7Cpageimages&titles=\(bugName)&formatversion=2&exsentences=3&exlimit=1&explaintext=1&piprop=thumbnail%7Cname&pithumbsize=300"
        
        let url = URL(string: wikiURL)
        return (url)!
    } //get wiki URL
    
    func apiCall(url: URL) {
        //session
        let session = URLSession.shared
        //
        let dataTask = session.dataTask(with: url) {data, response, error in
            if let error = error {
                print("FAIL! \(error.localizedDescription)")
            }
            else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Data retrieved: \(data!)")
                let jsonString = String(data: data!, encoding: .utf8)
                //test.json = "\(jsonString)"
                print(jsonString)
                var resultText = jsonString
                do {
                   let decoder = JSONDecoder()
                   decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                   let result = try decoder.decode(WikiImage.self, from: data!)
                    
                    //let imgLink = URL(string:imgURLString)
                    
                    //print(result.query.pages?[0].extract!)
                    resultText = (result.query.pages?[0].extract!) ?? ""
                    
                    
                    //var apiResult:APIResults = result.items!
                   // print("\(apiResult)")
                } catch {
                  print(error)
                }
                
               // print("THIS SHOULD BE UPDATED \(test.json)")
                DispatchQueue.main.async {
                    self.bugDescribe.text =  "(From Wikipedia.org)  \(resultText)"
                    //var wikiIMG = imgLink
                    //self.wikiImage.image
                }
                
            }
            else {
                print("nice!\(response!)")
            }
        }
        dataTask.resume()
    }
    
    func apiDisplay(searchResult:WikiImage)-> String {
        
        var text = ""
        
        text = (searchResult.query.pages?[0].extract)!
        
        return text
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
