//
//  PlaylistController.swift
//  PlsPlay
//
//  Created by Frank Steiner on 17.02.15.
//  Copyright (c) 2015 i.S.X. Software. All rights reserved.
//

import UIKit

class PlaylistController: UITableViewController {
    var prev_temp_name = ""
    var request = NSMutableURLRequest(URL: NSURL(string: "http://g33ky.de/static/podcasts/absolute.m3u?foobar=true")!);
    var mediafiles = NSMutableArray();
    var pls_name: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.reloadBtnClick(nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recievedPlaylist(filename: String, content: NSData) {
        var body = NSString(data: content, encoding: NSUTF8StringEncoding)!;
        var lines = body.componentsSeparatedByString("\n");
        if lines.count > 0 {
            pls_name = filename
            mediafiles.removeAllObjects()
            for line in lines {
                mediafiles.addObject(line)
            }
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.tableView.reloadData();
            }
        }
        
    }
    
    func showError(error: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            var alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "sad thing", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.mediafiles.removeAllObjects()
            self.pls_name = nil
            self.tableView.reloadData()
        }
    }

        
    // MARK: - Playlist-Controls
    @IBAction func urlChanged(sender: UITextField) {
        if sender.text == prev_temp_name {
            return;
        }
        var url = NSURL(string:  sender.text);
        
        if let abs = url?.absoluteString? {
            
            var req = NSMutableURLRequest(URL: url!);
            req.HTTPMethod = "GET"
            if (countElements(abs) > 0 && NSURLConnection.canHandleRequest(req)) {
                request = req;
//                fname = sender.text;
            }
        }
        prev_temp_name = sender.text;
    }
    
    
    @IBAction func reloadBtnClick(sender: UIButton?) {
        if let abs = request.URL?.absoluteString? {
            if countElements(abs) > 0 {
                var queue = NSOperationQueue() as NSOperationQueue
                NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    if response == nil && data == nil {
                        self.showError("Error retrieving File");
                        return;
                    }
                    let filename = response.suggestedFilename?
                    NSLog("response %@",response)
                    if data.length <= 0 {
                        var text = String(format: "File \"%@\" was empty", filename!)
                        self.showError(text);
                        return
                    }
                    let httpResponse = response as NSHTTPURLResponse
                    let type = httpResponse.allHeaderFields["Content-Type"] as String
                    switch (httpResponse.statusCode) {
                    case 201, 200, 401:
                        if type.lowercaseString=="application/octet-stream" {
                            self.recievedPlaylist(filename!, content: data);
                        } else {
                            self.showError("Wrong Filetype!!");
                        }
                    case 500:
                        self.showError("Request denied!");
                    case 404:
                        self.showError("File not found!");
                    default:
                        self.showError("File not found or Server Error!");
                    }

                })
                return
            }
        }
        self.showError("URL was invalid!");

    }

    @IBAction func playbackSpeedChanged(sender: UISlider) {
        NSLog("new speed: %f", sender.value / 10.0);
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if mediafiles.count < 1 {
            return 1
        } else {
            // TODO: support multiple playlist-files, enhance this to return n+1 sections (n==number of playlists)
            return 2
        }

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // status, control, filename of playlist
            return 3;
        }
        return mediafiles.count;
    }
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> NSString {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return "control";
            case 1:
                return "status";
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
        
        if indexPath.section > 0 {
            if let label = cell.contentView.viewWithTag(1) as? UILabel {
                if let title = mediafiles.objectAtIndex(indexPath.row) as? String {
                    label.text = title
                } else {
                    label.text = "[data not found]"
                }
            }
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > 0 {
            return pls_name
        }
        return nil;
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
