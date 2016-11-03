//
//  pruebaViewController.swift
//  mimaga
//
//  Created by ginppian on 01/11/16.
//  Copyright © 2016 ginppian. All rights reserved.
//

import UIKit

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
    
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
    
}
class PrincipalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Arrays
    var arrayFrases = [String]()
    var arrayHorario = [String]()

    //Outlets
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    
    @IBOutlet weak var slider: UISlider!
    
    
    @IBOutlet weak var blur: UIVisualEffectView!
    
    
    //Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayFrases = JSONReader.readJSONToArrayString(fileName: "libro1", type: ".json", key: "frase")
        arrayHorario = JSONReader.readJSONToArrayString(fileName: "libro1", type: ".json", key: "horario")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PrincipalViewController.tap))
        self.textView.addGestureRecognizer(tap)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PrincipalViewController.pan))
        self.textView.addGestureRecognizer(panGesture)
        
    }
    //Funcion que carga las vistas despues de entrar al constructor
    override func viewDidAppear(_ animated: Bool) {
        alignTextVerticalInTextView(textView: self.textView)

    }
    //Funcion que carga las vistas antes de entrar al constructor
    override func viewWillAppear(_ animated: Bool) {
        alignTextVerticalInTextView(textView: self.textView)
        
    }
    //Funcion que alinea en el centro verticalmente el texto del TextView
    func alignTextVerticalInTextView(textView :UITextView) {
        let size = textView.sizeThatFits(CGSize(textView.bounds.width, CGFloat(MAXFLOAT)))
        var topoffset = (textView.bounds.size.height - size.height * textView.zoomScale) / 2.0
        topoffset = topoffset < 0.0 ? 0.0 : topoffset
        textView.contentOffset = CGPoint(0, -topoffset)
    
    }
    //Primero hacemos un screenShot a la pantalla y depues lanzamos opcion de compartir
    @IBAction func shareScreen(_ sender: UIBarButtonItem) {
        //SCREENSHOOT
        let w = self.view.bounds.size.width
        let h = self.view.bounds.size.height + 48.0
        let newFrame = CGRect(0, 0, w, h)
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0.0);
        //self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        self.view.drawHierarchy(in: newFrame, afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        //COMPARTIR Y GUARDAR
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        //NOTA: Trabajamos con NSPhotoLibraryUsageDescription
        
    }
    //Cuando hace tap sobre TextView cambiamos por una FRASE RANDOM
    func tap(sender: UITapGestureRecognizer) {
        let rand = Random.getRand0A(tope: arrayFrases.count)
        let frase = arrayFrases[rand]
        self.textView.text = frase
        
    }
    //Shake Gesture
    override var canBecomeFirstResponder: Bool {
        return true
        
    }
    //Shake Gesture - CREDITOS
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let message = "Programación. David Guillermo López Vázquez 😎\nProgramación. Karla Panque 🐼\nDiseño Gráfico. Anel Maldonado 🙋"
            let alert = UIAlertController(title: "📲Desarrado por:📲", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    //Take Photo
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        //NOTA: en este IF trabajamos con NSCameraUsageDescription, si ya tiene permiso
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }

    }
    //Carrete
    @IBAction func pickUpPhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    //Delegate for "takePhoto:" and "pickUpPhoto"
    //NOTA: Si agregamos PRIVATE a esta funcion no funciona por eso el WARNING
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func pan(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
        
    }

    
    @IBAction func blurAction(_ sender: UIBarButtonItem) {
        self.toolBar.isHidden = true

    }
    @IBAction func okBlurAction(_ sender: UIButton) {
        self.toolBar.isHidden = false
        
    }
    @IBAction func sliderAction(_ sender: UISlider) {
        self.blur.alpha = CGFloat(self.slider.value)
        
    }
    
    
    
    

}
