//
//  TealeafSettingsScreen.swift
//  Shake2TealeafSettings
//
//  Created by Shridhar Damale on 6/19/20.
//  Copyright © 2020 Acoustic. All rights reserved.
//

import SwiftUI
import Tealeaf
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first as UIWindow?
            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                if topController is UINavigationController
                {
                    let navigationCtrl = topController as! UINavigationController
                    let vc = UIHostingController(rootView: TealeafSettingsScreen(dismissAction: {}))
                    //topController.present(vc, animated: true, completion: nil)
                    navigationCtrl.pushViewController(vc, animated: true)
                }
                else
                {
                    let vc = UIHostingController(rootView: TealeafSettingsScreen(dismissAction: {topController.dismiss( animated: true, completion: nil )}))
                    topController.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}

struct TealeafSettingsScreen : View {

    @Environment(\.presentationMode) private var presentationMode
    @State private var appKey: String = "c7759ff3abb1435993e99a52ba6c0c96"
    @State private var postMessageUrl: String = "http://lib-us-2.brilliantcollector.com/collector/collectorPost"
    var dismissAction: (() -> Void)
    
  var body: some View {
    VStack {
        HStack {
            Text("AppKey : ")
            TextField("Enter AppKey", text: $appKey)
        }
        HStack {
            Text("PostMessageUrl : ")
            TextField("Enter PostMessageUrl", text: $postMessageUrl)
        }
        Button(action: {
            TLFApplicationHelper.sharedInstance()?.setPostMessageUrl(self.postMessageUrl)
            TLFApplicationHelper.sharedInstance()?.setConfigurableItem("AppKey", value: self.appKey)
            self.presentationMode.wrappedValue.dismiss()
            self.dismissAction()
        }) {
          Text("Save and Back")
        }
    }
  }
}

struct TealeafSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TealeafSettingsScreen(dismissAction: {})
    }
}
