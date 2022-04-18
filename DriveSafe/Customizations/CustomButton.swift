//
//  CustomButton.swift
//  DriveSafe
//
//  Created by Chandler Glowicki on 4/11/22.
//

import UIKit

class CustomButton:UIButton{
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        convenience init(title: String) {
            self.init(frame: .zero)
            setTitle(title, for: .normal)
        }

        private func configure() {
            translatesAutoresizingMaskIntoConstraints = false
            titleLabel?.font      = UIFont.systemFont(ofSize: 15, weight: .semibold)
            backgroundColor       = .systemBlue
            self.setTitleColor(UIColor.black, for: .normal)
        }
    }
