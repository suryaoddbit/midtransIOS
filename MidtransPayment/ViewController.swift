//
//  ViewController.swift
//  MidtransPayment
//
//  Created by I Wayan Surya Adi Yasa on 4/12/17.
//  Copyright © 2017 ODDBIT. All rights reserved.
//

import UIKit
import MidtransCoreKit
import MidtransKit
class ViewController: UIViewController {

    let btnOrder : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.setTitle("ORDER", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(btnOrder)
        btnOrder.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        btnOrder.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        btnOrder.widthAnchor.constraint(equalToConstant: 150).isActive = true
        btnOrder.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        btnOrder.addTarget(self, action: #selector(clickOrder), for: .touchUpInside)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickOrder(){
        MidtransCreditCardConfig.shared().secure3DEnabled = true
        MidtransCreditCardConfig.shared().paymentType = .oneclick
        MidtransCreditCardConfig.shared().saveCardEnabled = true
        MidtransCreditCardConfig.shared().tokenStorageEnabled = true
        MidtransCreditCardConfig.shared().secure3DEnabled = true
        let itemDetail = MidtransItemDetail.init(itemID: "00414", name: "sample item 3", price:
            5000, quantity: 2)
        let addr : MidtransAddress = MidtransAddress(firstName: "Surya 2", lastName: "oddbit 2", phone: "0890891", address: "Jalan", city: "denpasar", postalCode: "80226", countryCode: "IDN")
        
        
        let customerDetail = MidtransCustomerDetails.init(firstName: "surya", lastName: "odbit", email: "surya@oddbit.id", phone: "089089", shippingAddress: addr, billingAddress: addr)
        let transactionDetail = MidtransTransactionDetails.init(orderID: "00414", andGrossAmount: 10000)
        //var data : NSData = MDOp
        
        MidtransMerchantClient.shared().requestTransactionToken(with: transactionDetail!,
                                                                itemDetails: [itemDetail!], customerDetails: customerDetail) { (response, error) in
                if (response != nil) {
                    //handle response
                    let vc = MidtransUIPaymentViewController.init(token: response)
                    vc?.paymentDelegate = self;
                    self.present(vc!, animated: true, completion: nil)
                }
                else {
                    //handle error
                    print(error ?? "")
                }
        }
        

    }
    
    


}

extension ViewController : MidtransUIPaymentViewControllerDelegate{
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!,
                               paymentFailed error: Error!) {
        print("paymentFailed : \(error)")
    }
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!,
                               paymentPending result: MidtransTransactionResult!) {
          print("paymentPending")
    }
    func paymentViewController(_ viewController: MidtransUIPaymentViewController!,
                               paymentSuccess result: MidtransTransactionResult!) {
        print("paymentSuccess")
    }
    func paymentViewController_paymentCanceled(_ viewController:
        MidtransUIPaymentViewController!) {
        print("paymentViewController_paymentCanceled")
    }
}



