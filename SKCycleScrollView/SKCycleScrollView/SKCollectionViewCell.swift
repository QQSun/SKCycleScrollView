//
//  SKCollectionViewCell.swift
//  SKCycleScrollView
//
//  Created by nachuan on 2016/10/29.
//  Copyright © 2016年 nachuan. All rights reserved.
//

import UIKit

extension SKCollectionViewCell {
    var titleLabelTextColor: UIColor! {
        get {
            return _titleLabelTextColor;
        }
        set {
            _titleLabelTextColor = newValue;
            _titleLabel!.textColor = _titleLabelTextColor;
        }
    }
    
    var titleLabelBackgroundColor: UIColor? {
        get {
            return _titleLabelBackgroundColor;
        }
        set {
            _titleLabelBackgroundColor = newValue;
            _titleLabel.backgroundColor = _titleLabelBackgroundColor;
        }
    }
    
    var titleLabelFont: UIFont! {
        get {
            return _titleLabelFont;
        }
        set {
            _titleLabelFont = newValue;
            _titleLabel.font = _titleLabelFont;
        }
    }
    
    var title: String? {
        get {
            return _title;
        }
        set {
            _title = newValue;
            _titleLabel.text = _title;
            if _title != nil {
                _titleLabel.isHidden = false;
            }else{
                _titleLabel.isHidden = true;
            }
        }
    }
    
    var imageView: UIImageView! {
        get {
            return _imageView;
        }
        set {
            _imageView = newValue;
        }
    }
    
    var hasConfigured: Bool {
        get {
            return _hasConfigured;
        }
        set {
            _hasConfigured = newValue;
        }
    }
    
    var onlyDisplayText: Bool {
        get {
            return _onlyDisplayText;
        }
        set {
            _onlyDisplayText = newValue;
        }
    }
    
    var titleLabelHeight: CGFloat {
        get {
            return _titleLabelHeight;
        }
        set {
            _titleLabelHeight = newValue;
        }
    }
    
}

class SKCollectionViewCell: UICollectionViewCell {
    var _title: String?
    var _titleLabel: UILabel!
    var _imageView: UIImageView!
    var _titleLabelTextColor: UIColor! = UIColor.black;
    var _titleLabelFont: UIFont!
    var _titleLabelBackgroundColor: UIColor?
    var _titleLabelHeight: CGFloat = 0;
    
    var _hasConfigured: Bool = false;
    var _onlyDisplayText: Bool = true;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupImageView();
        setupTitleLabel();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupImageView();
        setupTitleLabel();
    }
    
    
    func setupImageView() -> Void {
        _imageView = UIImageView();
        self.contentView.addSubview(_imageView);
    }
    
    func setupTitleLabel() -> Void {
        _titleLabel = UILabel();
        _titleLabel.isHidden = true;
        self.contentView.addSubview(_titleLabel);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        if _onlyDisplayText == true {
            _titleLabel.frame = self.bounds;
        }else{
            _imageView.frame = self.bounds;
            let titleLabelW: CGFloat = self.sk_width;
            let titleLabelH: CGFloat = _titleLabelHeight;
            let titleLabelX: CGFloat = 0;
            let titleLabelY: CGFloat = self.sk_height - titleLabelH;
            _titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH);
        }
    }
    
}








































