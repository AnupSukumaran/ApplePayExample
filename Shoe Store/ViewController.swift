//
//  ViewController.swift
//  Shoe Store
//
//  Created by Pranav Wadhwa on 12/28/18.
//  Copyright © 2018 Pranav Wadhwa. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController {
    
    @IBOutlet weak var shoePickerView: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    // Data Setup
    
    struct Shoe {
        var name: String
        var price: Double
    }
    
    let shoeData = [
        Shoe(name: "Nike Air Force 1 High LV8", price: 110.00),
        Shoe(name: "adidas Ultra Boost Clima", price: 139.99),
        Shoe(name: "Jordan Retro 10", price: 190.00),
        Shoe(name: "adidas Originals Prophere", price: 49.99),
        Shoe(name: "New Balance 574 Classic", price: 90.00)
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoePickerView.delegate = self
        shoePickerView.dataSource = self
        
    }
    
    // Storyboard outlets
    @IBAction func buyShoeTapped(_ sender: UIButton) {
        
        let selectedIndex = shoePickerView.selectedRow(inComponent: 0)
        print("selectedIndex = \(selectedIndex)")
        let shoe = shoeData[selectedIndex]
        
//        let request = PKPaymentRequest()
//        request.paymentSummaryItems = [PKPaymentSummaryItem(label: shoe.name, amount: NSDecimalNumber(value: shoe.price))]
//        request.currencyCode = "USD" // 1
//        request.countryCode = "US" // 2
//        request.merchantIdentifier = "merchant.com.qaptive.Shoe-Store" // 3
//        request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
//        request.supportedNetworks = [.quicPay,  .masterCard, .visa] // 5
//        //request.paymentSummaryItems = [paymentItem] // 6
//
//        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
//        if controller != nil {
//            controller!.delegate = self
//            present(controller!, animated: true, completion: nil)
//        }
//
//        if !textFieldAmount.text!.isEmpty {
//            let amount = textFieldAmount.text!
//            payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "iPhone XR 128 GB", amount: NSDecimalNumber(string: amount))]
//
//            let controller = PKPaymentAuthorizationViewController(paymentRequest: payment)
//            if controller != nil {
//                controller!.delegate = self
//                present(controller!, animated: true, completion: nil)
//            }
//        }
//
//
        let paymentItem = PKPaymentSummaryItem(label: shoe.name, amount: NSDecimalNumber(value: shoe.price))
        let paymentNetworks = [PKPaymentNetwork.quicPay,  .masterCard, .visa, .discover]


        // let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentItem)

        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()

            request.currencyCode = "USD" // 1
            request.countryCode = "US" // 2
            request.merchantIdentifier = "merchant.com.qaptive.Shoe-Store" // 3
            request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
            request.supportedNetworks = paymentNetworks // 5
            request.paymentSummaryItems = [paymentItem] // 6

            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
                return
            }

            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)

    } else {
            displayDefaultAlert(title: "Error", message: "Unable to make Apple Pay transaction.")
        }
        
    }
    
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
  
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
        displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
    }
    
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Pickerview update
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shoeData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shoeData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let priceString = String(format: "%.02f", shoeData[row].price)
        priceLabel.text = "Price = $\(priceString)"
    }
}
