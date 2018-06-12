import Flutter
import UIKit
import GooglePlaces
import GooglePlacePicker

public class SwiftFlutterGooglePlacePickerPlugin: NSObject, FlutterPlugin, GMSPlacePickerViewControllerDelegate {
    
    var globalResult : FlutterResult? = nil
    
    //    let controller : UIViewController?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_google_place_picker", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterGooglePlacePickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        globalResult = result;
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        let controller = UIApplication.shared.delegate!.window!?.rootViewController
        placePicker.delegate = self
        controller?.present(placePicker, animated: true, completion: nil)
    }
    
    public func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        let dictionary: NSDictionary = [
            "latitude" : "\(place.coordinate.latitude)",
            "longitude" : "\(place.coordinate.longitude)",
            "id" : place.placeID,
            "name" : place.name,
            "address": place.formattedAddress ?? "unknown"
        ]
        globalResult?(dictionary)
    }
    
    public func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
}
