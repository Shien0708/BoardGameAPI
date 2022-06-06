//
//  VideoCollectionViewController.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/2.
//

import UIKit
class VideoCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "\(VideoCollectionViewCell.self)"
    var videos: [Video]?
    let decoder = JSONDecoder()
    var selectedItem = 0
    var buttons = [UIButton]()
    var items = [Int]()
    
    @IBOutlet weak var videoLoadingView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width-10, height: (view.bounds.width-10)*3/4)
        collectionView.collectionViewLayout = layout as UICollectionViewLayout
        
        getVideoInfo()
    }
    
    func showAlert() {
        videoLoadingView.isHidden = true
        let controller = UIAlertController(title: "error:", message: "Please check your internet.", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            self.videoLoadingView.isHidden = false
            self.getVideoInfo()
        }))
        present(controller, animated: true)
    }
    
    func getVideoInfo() {
        if let url = URL(string: "https://api.boardgameatlas.com/api/game/videos?pretty=true&limit=20&client_id=JLBr5npPhV") {
            
            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                self.showAlert()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let videoResponse = try self.decoder.decode(VideoList.self, from: data)
                        print("has response")
                        self.videos = videoResponse.videos
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.videoLoadingView.isHidden = true
                            timer.invalidate()
                        }
                    } catch { print(error)}
                   
                }
            }.resume()
        }
    }
    
    @IBSegueAction func showYoutube(_ coder: NSCoder) -> UIViewController? {
        var index = 0
        while !buttons[index].isTouchInside {
            index += 1
        }
        selectedItem = Int(buttons[index].titleLabel!.text!)!
        let controller = YoutubeViewController(coder: coder)
        controller?.url = self.videos![self.selectedItem].url
        return controller
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return videos?.count ?? 0
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? VideoCollectionViewCell else { return VideoCollectionViewCell() }
        
        if let videos = videos {
            cell.gameImageView.image = try? UIImage(data: Data(contentsOf: videos[indexPath.item].image_url))
            cell.gameName.text = videos[indexPath.item].title
            cell.channelButton.setTitle("\(indexPath.item)", for: .normal)
            if !items.contains(indexPath.item) {
                buttons.append(cell.channelButton)
                items.append(indexPath.item)
            }
        }
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

   
}
