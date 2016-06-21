//
//  MaterialGridView.swift
//  CorePump Workouts
//
//  Created by Conner Owen on 6/8/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

import UIKit
import Material

class MaterialGridView: MaterialPulseView {
    
    
    override func layoutSubviews() {
        //let cardView: MaterialPulseView = MaterialPulseView(frame: CGRectMake(16, 100, view.bounds.width - 32, 152))
        self.pulseColor = MaterialColor.blueGrey.base
        self.depth = .Depth1
        //view.addSubview(cardView)
        
        var image: UIImage? = UIImage(named: "CosmicMindInverted")
        let imageView: MaterialView = MaterialView()
        imageView.image = image
        imageView.contentsGravityPreset = .ResizeAspectFill
        self.addSubview(imageView)
        
        let contentView: MaterialView = MaterialView()
        contentView.backgroundColor = MaterialColor.clear
        self.addSubview(contentView)
        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Material"
        titleLabel.textColor = MaterialColor.blueGrey.darken4
        titleLabel.backgroundColor = MaterialColor.clear
        contentView.addSubview(titleLabel)
        
        image = MaterialIcon.cm.moreVertical
        let moreButton: IconButton = IconButton()
        moreButton.contentEdgeInsetsPreset = .None
        moreButton.pulseColor = MaterialColor.blueGrey.darken4
        moreButton.tintColor = MaterialColor.blueGrey.darken4
        moreButton.setImage(image, forState: .Normal)
        moreButton.setImage(image, forState: .Highlighted)
        contentView.addSubview(moreButton)
        
        let detailLabel: UILabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .ByTruncatingTail
        detailLabel.font = RobotoFont.regularWithSize(12)
        detailLabel.text = "Express your creativity with Material, an animation and graphics framework for Google's Material Design and Apple's Flat UI in Swift."
        detailLabel.textColor = MaterialColor.blueGrey.darken4
        detailLabel.backgroundColor = MaterialColor.clear
        contentView.addSubview(detailLabel)
        
        let alarmLabel: UILabel = UILabel()
        alarmLabel.font = RobotoFont.regularWithSize(12)
        alarmLabel.text = "34 min"
        alarmLabel.textColor = MaterialColor.blueGrey.darken4
        alarmLabel.backgroundColor = MaterialColor.clear
        contentView.addSubview(alarmLabel)
        
        image = UIImage(named: "ic_alarm_white")?.imageWithRenderingMode(.AlwaysTemplate)
        let alarmButton: IconButton = IconButton()
        alarmButton.contentEdgeInsetsPreset = .None
        alarmButton.pulseColor = MaterialColor.blueGrey.darken4
        alarmButton.tintColor = MaterialColor.red.base
        alarmButton.setImage(image, forState: .Normal)
        alarmButton.setImage(image, forState: .Highlighted)
        contentView.addSubview(alarmButton)
        
        imageView.grid.columns = 4
        
        contentView.grid.columns = 8
        
        //cardView.grid.views = [
        //    imageView,
        //    contentView
        //]
        
        titleLabel.grid.rows = 3
        titleLabel.grid.columns = 9
        
        moreButton.grid.rows = 3
        moreButton.grid.columns = 2
        moreButton.grid.offset.columns = 10
        
        detailLabel.grid.rows = 4
        detailLabel.grid.offset.rows = 4
        
        alarmLabel.grid.rows = 3
        alarmLabel.grid.offset.rows = 9
        alarmLabel.grid.columns = 9
        
        alarmButton.grid.rows = 3
        alarmButton.grid.offset.rows = 9
        alarmButton.grid.columns = 2
        alarmButton.grid.offset.columns = 10
        
        contentView.grid.spacing = 8
        contentView.grid.axis.direction = .None
        contentView.grid.contentInsetPreset = .Square3
        contentView.grid.views = [
            titleLabel,
            moreButton,
            detailLabel,
            alarmLabel,
            alarmButton
        ]

    }
    
}