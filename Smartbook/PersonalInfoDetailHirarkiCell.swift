//
//  PersonalInfoDetailHirarkiCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/23/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class PersonalInfoDetailHirarkiCell: UITableViewCell {

    var hirarkiView: PersonalInfoDetailHirarkiViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPersonalInfoDetailHirarki(itemNpp: String, itemRekan: Array<AnyObject>, delegate: PersonalInfoListDetailViewController, itemNppAtasan: String, itemNamaAtasan: String,
                                        itemUrl: String, itemUrlAtasan: String) {
        hirarkiView = PersonalInfoDetailHirarkiViewController(nibName: "PersonalInfoDetailHirarkiViewController", bundle: nil)
        hirarkiView.personalInfoDetailDelegate = delegate
        hirarkiView.infoDetailNpp = itemNpp
        hirarkiView.infoDetailNppAtasan = itemNppAtasan
        hirarkiView.infoDetailNamaAtasan = itemNamaAtasan
        hirarkiView.infoDetailUrl = itemUrl
        hirarkiView.infoDetailUrlAtasan = itemUrlAtasan
        hirarkiView.infoDetailRekan = itemRekan
        delegate.addChildViewController(hirarkiView)
        hirarkiView.view.frame = contentView.bounds
        contentView.addSubview(hirarkiView.view)
        hirarkiView.didMoveToParentViewController(delegate)
    }

    
}
