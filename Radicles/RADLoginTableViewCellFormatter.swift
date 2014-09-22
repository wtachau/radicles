//
//  RADLoginTableViewCellFormatter.swift
//  Radicles
//
//  Created by William Tachau on 9/17/14.
//  Copyright (c) 2014 Radicles. All rights reserved.
//

import Foundation

extension RADLoginViewController {
    
    // format the cells
    func setUpCell(row: Int) -> UITableViewCell! {
        var Cell : UITableViewCell?
        Cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        
        // Customize cell
        if let cell = Cell  {
            
            cell.backgroundColor = buttonColor
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if row < 0 {
                cell.backgroundColor = backgroundColor
            } else {
                
                switch row {
                case 0:
                    var loginText = UILabel(frame: cell.frame)
                    loginText.textColor = UIColor.whiteColor()
                    loginText.font = UIFont(name: "HelveticaNeue-Light", size: 20)
                    if onSignup {
                        loginText.text = "sign up below (tap to login)"
                    } else {
                        loginText.text = "login below (tap to signup)"
                    }
                    loginText.textAlignment = NSTextAlignment.Center
                    cell.backgroundColor = backgroundColor
                    cell.contentView.addSubview(loginText)
                case 1 :
                    setUpNameCell(cell)
                    nameField.textColor = darkGreen
                    cell.contentView.addSubview(nameField)
                case 2:
                    setUpPasswordCell(cell)
                    passwordField.textColor = darkGreen
                    cell.contentView.addSubview(passwordField)
                case 3:
                    setUpDoneCell(cell)
                    cell.contentView.addSubview(loginIndicator)
                    cell.backgroundColor = backgroundColor
                    cell.contentView.addSubview(doneText)
                default:
                    cell.backgroundColor = backgroundColor
                }
            }
        }
        return Cell
    }
    
    func setUpNameCell(cell :UITableViewCell) {
        nameField.clearButtonMode = UITextFieldViewMode.WhileEditing
        nameField.textAlignment = NSTextAlignment.Center
        nameField.textColor = UIColor.whiteColor()
        nameField.attributedPlaceholder = NSAttributedString(string: "your name", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        nameField.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        nameField.frame = cell.frame
        nameField.autocorrectionType = UITextAutocorrectionType.No
    }
    
    // Format the password cell
    func setUpPasswordCell(cell : UITableViewCell) {
        passwordField.clearButtonMode = UITextFieldViewMode.WhileEditing
        passwordField.textAlignment = NSTextAlignment.Center
        passwordField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        passwordField.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        passwordField.frame = cell.frame
        passwordField.textColor = UIColor.whiteColor()
        passwordField.autocorrectionType = UITextAutocorrectionType.No
        passwordField.secureTextEntry = true
    }
    
    // Format the done cell
    func setUpDoneCell(cell : UITableViewCell) {
        doneText.frame = cell.frame
        doneText.textColor = UIColor.whiteColor()
        doneText.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        doneText.text = doneString
        doneText.textAlignment = NSTextAlignment.Center
        
        let loginIndicatorSize = loginIndicator.frame.size.width
        loginIndicator.frame = CGRectMake((cell.frame.size.width - loginIndicatorSize)/2, 10, loginIndicatorSize, loginIndicatorSize)
    }

}
