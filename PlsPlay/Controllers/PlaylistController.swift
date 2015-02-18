//
//  PlaylistController.swift
//  PlsPlay
//
//  Created by Frank Steiner on 17.02.15.
//  Copyright (c) 2015 i.S.X. Software. All rights reserved.
//

import UIKit

class PlaylistController: UITableViewController {
    var fname = "" as String
    var prev_temp_name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
    // MARK: - Playlist-Controls
    @IBAction func urlChanged(sender: UITextField) {
        if sender.text == prev_temp_name {
            sender.backgroundColor = UIColor.clearColor();
            return;
        }
        var url = NSURL(fileURLWithPath: sender.text);
        var req = NSURLRequest(URL: url!);
        if (NSURLConnection.canHandleRequest(req)) {
            sender.backgroundColor = UIColor.blueColor();
            fname = sender.text;
        } else {
            sender.backgroundColor = UIColor.redColor();
        }
        prev_temp_name = sender.text;
        
    }
    @IBAction func reloadBtnClick(sender: UIButton) {
        NSLog("test");
    }
    @IBAction func playbackSpeedChanged(sender: UISlider) {
        NSLog("new speed: %f", sender.value / 10.0);
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if fname.isEmpty {
            return 1
        } else {
            return 2
        }

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 3;
        }
        return 0
    }
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> NSString {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return "control";
            case 1:
                return "status"
            default:
                return "filename";
            }

        } else {
            return "file";
        }
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ident = self.cellIdentifierForIndexPath(indexPath);
        let cell = tableView.dequeueReusableCellWithIdentifier(ident, forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
