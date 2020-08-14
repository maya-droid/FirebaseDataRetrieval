

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper
import FirebaseAuth

class FeedVC: UITableViewController{
    
    var currentUserImageUrl: String!
    var posts = [postStruct]()
    var selectedPost: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
        getPosts()
        // Do any additional setup after loading the view.
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getUsersData(){

        guard let userID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            if let postDict = snapshot.value as? [String : AnyObject] {
                self.tableView.reloadData()
            }
        }
    }
    
    struct postStruct {
        let firstName : String!
        let lastName : String!
    }
    
    func getPosts() {
        let databaseRef = Database.database().reference()
        databaseRef.child("profiles").queryOrderedByKey().observeSingleEvent(of: .childAdded, with: {
                    snapshot in
                    let firstName = (snapshot.value as? NSDictionary)!["profileForename"] as? String
                    let lastName = (snapshot.value as? NSDictionary
                        )!["profileSurname"] as? String
                    self.posts.append(postStruct(firstName: firstName, lastName: lastName))
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else { return UITableViewCell() }
        cell.firstNameLabel?.text = posts[indexPath.row].firstName
        print(posts[indexPath.row].firstName)
        return cell
    }
}


