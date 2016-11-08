//
//  pruebaViewController.swift
//  mimaga
//
//  Created by ginppian on 01/11/16.
//  Copyright © 2016 ginppian. All rights reserved.
//

import UIKit
extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}
//Estension para agregarle CONSTRAINS, para que tenga el mismo tamano que su vista padre/superior.
extension UIView {
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}
//Obtener la altura de un label
extension UILabel{
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(0, 0, self.frame.width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
}
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
class PrincipalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    //Arrays
    var arrayFrases = [String]()
    var arrayFrasesRespaldo = [String]()
    var arrayHorario = [String]()
    let arrayNameImages = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44"]

    //Outlets
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewLabel: UIView!
    
    //Propertys
    var blurEffectView: UIVisualEffectView!
    var indexScroll = Int()
    
    //Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Llenamos los arreglos
        arrayFrases = JSONReader.readJSONToArrayString(fileName: "libro1", type: ".json", key: "frase")
        arrayFrasesRespaldo = arrayFrases
        arrayHorario = JSONReader.readJSONToArrayString(fileName: "libro1", type: ".json", key: "horario")
        
        let tapSV = UITapGestureRecognizer(target: self, action: #selector(PrincipalViewController.tapScrollView))
        self.scrollView.addGestureRecognizer(tapSV)
        
        let tapLinV = UITapGestureRecognizer(target: self, action: #selector(PrincipalViewController.tapLabelInView))
        //Agregamos el Gesto Tap tambien al View que contiene al Label
        self.viewLabel.addGestureRecognizer(tapLinV)
        //Agregamos Gesto Pan TextView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PrincipalViewController.pan))
        self.viewLabel.addGestureRecognizer(panGesture)
        
        //Agregamos slide imagenes
        //Ajustamos el frame
        let adjustFrame = CGRect(0, 0, self.view.frame.width, self.view.frame.height)
        self.scrollView.frame = adjustFrame
        
        let maxImageSlide = 6
        let arrayRandom = Random.get(number: maxImageSlide, objectsIn: arrayNameImages)

        for (index, name) in arrayRandom.enumerated(){
            let imageView = UIImageView()
            imageView.image = UIImage(named: name)
            //let xPos = self.view.frame.width * CGFloat(index)
            let xPos = self.scrollView.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: xPos, y: 0.0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            self.scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(index+1)
            self.scrollView.addSubview(imageView)
    
        }
        //Usamos el delegado para la función "scrollViewDidScroll:" (aun que en este programa no la usamos)
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        //Agregamos la frase en la Label
        let rand = Random.getRandZeroA(tope: arrayFrases.count)
        let frase = arrayFrases[rand]
        self.label.text = frase


    }
    //Funcion que carga las vistas antes de entrar al constructor
    override func viewWillAppear(_ animated: Bool) {
        self.viewLabel.frame = resizeViewContent(label: self.label)
        resizeLabel(label: self.label, newFrame: self.viewLabel.frame)
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
    //Cuando hace tap sobre ScrollView cambiamos por una FRASE RANDOM
    func tapScrollView(sender: UITapGestureRecognizer) {
        var rand = Int()
        var frase = String()
        
        //Toma una frase aleatoria del arregloFrasesAux la agrega a la Label y la quita del array
        //Si se terminan las frases reasigna las frases de un arreglo de respaldo
        if arrayFrases.count > 0{
            rand = Random.getRandZeroA(tope: arrayFrases.count)
            frase = arrayFrases[rand]
            self.label.text = frase
            arrayFrases.remove(at: rand)
            
        } else {
            arrayFrases = arrayFrasesRespaldo
        }
        
        //Redimenciona la Label
        self.viewLabel.frame = resizeViewContent(label: self.label)
        resizeLabel(label: self.label, newFrame: self.viewLabel.frame)
        
    }
    func tapLabelInView(sender: UITapGestureRecognizer){
        var rand = Int()
        var frase = String()
        
        //Toma una frase aleatoria del arregloFrasesAux la agrega a la Label y la quita del array
        //Si se terminan las frases reasigna las frases de un arreglo de respaldo
        if arrayFrases.count > 0{
            rand = Random.getRandZeroA(tope: arrayFrases.count)
            frase = arrayFrases[rand]
            self.label.text = frase
            arrayFrases.remove(at: rand)
            
        } else {
            arrayFrases = arrayFrasesRespaldo
        }
        
        //Redimenciona la Label
        self.viewLabel.frame = resizeViewContent(label: self.label)
        resizeLabel(label: self.label, newFrame: self.viewLabel.frame)
        
    }
    func resizeLabel(label: UILabel, newFrame: CGRect){
        
        //Obtenemos la altura del frame
        let newHeight = newFrame.size.height
        
        //Despejando obtenemos el numero de lineas requiere Label
        let newNumberOfLines = ceil(newHeight / label.requiredHeight())
        //Asignamos el nuevo nuemero de lineas
        label.numberOfLines = Int(newNumberOfLines)
        
        //Asignamos el mismo frame que el de el View
        label.frame = newFrame
        label.bindFrameToSuperviewBounds()
        
        //Redimensionamos
        label.sizeToFit()
        
        //Quitamos los puntitos ...
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
    }
    func resizeViewContent(label: UILabel) -> CGRect{
        /*Esta funcion es especialmente hecha PORQUE dentro de la LABEL
         hay un VIEW el cual permite hacer el gesto PAN sin confundir al 
         SCROLLVIEW (cambios de imagenes). Por esta razon se debe redimencionar 
         el VIEW y el LABEL dentro del VIEW y CENTRARLOS.
         */
        

        //Nos aseguramos que la etiqueta contenga el texto en una sola linea
        label.numberOfLines = 1
        //Redimencionamos la label para que abarque todo el texto
        label.sizeToFit()
        //Obtenemos la longitud del ancho de la label
        let widthLabel = label.bounds.width
        //Obtenemos la longitud del ancho de la pantalla
        let widthScreenWithMargins = UIScreen.main.bounds.width - 34.0
        //Obtenemos cuantas lineas debe tener la label
        let newNumberOfLines = ceil(widthLabel / widthScreenWithMargins) + 1.0
        //Creamos un nuevo FRAME con el nuevo tamano
        let newHeight = label.requiredHeight()*newNumberOfLines
        
        
        var newFrame = CGRect()
        //Mantener la misma Posicion y no necesariamente regresar al origen
        if label.tag == 1{
            newFrame = CGRect(self.viewLabel.frame.origin.x, self.viewLabel.frame.origin.y, widthScreenWithMargins, newHeight)
        } else {
            label.tag = 1
            newFrame = CGRect(17.0, self.view.center.x, widthScreenWithMargins, newHeight)
        }
        
        
        return newFrame
    }


    //Shake Gesture
    override var canBecomeFirstResponder: Bool {
        return true
        
    }
    //Shake Gesture - CREDITOS
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let message = "Programación. David Guillermo López Vázquez 😎\nCorreo. ginppian@icloud.com\nProgramación. Karla Panque 🐼\nCorreo. panque@gmail.com\nDiseño Gráfico. Anel Maldonado 🙋\nCorreo. anel@gmail.com\n"
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
            
            let arraySubViews = self.scrollView.subviews
            let i = self.getIndexScrollViewWithSubViews(arraySubViews: arraySubViews)
            let imageView = arraySubViews[i] as! UIImageView
            
            imageView.contentMode = .scaleAspectFit
            let resizeImage = pickedImage.imageResize(sizeChange: imageView.frame.size)
            imageView.image = resizeImage
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
    func getIndexScrollViewWithSubViews(arraySubViews: [UIView]) -> Int{
        //Obtenemos la primer subView para medir su ancho
        let firstImageViewInScroll = arraySubViews[0]
        //Obtenemos el ancho de la subView
        let widthImageView = firstImageViewInScroll.bounds.width
        //Obtenemos el index en el que nos encontramos en el Scroll, dividiento el OFFSET / tamanoIndividual RESTAMOS 1 porque empezamos desde cero
        return Int(scrollView.contentOffset.x / widthImageView)
        
    }
    @IBAction func blurAction(_ sender: UIBarButtonItem) {
        //Ocultamos la Barra de Herramientas
        self.toolBar.isHidden = true
        self.scrollView.isScrollEnabled = false
        
        //Obtenemos la UIIMageView en la que estamos
        let arraySubViews = self.scrollView.subviews
        self.indexScroll = getIndexScrollViewWithSubViews(arraySubViews: arraySubViews)
        let thisImageView = arraySubViews[self.indexScroll] as! UIImageView
        
        //Si ya tiene Blur
        if thisImageView.tag == 1 {
            //Obtenemos el Blur
            self.blurEffectView = thisImageView.subviews[0] as! UIVisualEffectView
            self.slider.value = Float(self.blurEffectView.alpha)
            
        } else {
            //Marcamos con una bandera que le agregamos Blur
            // 1: Tiene blur
            // 0: No tiene blur
            thisImageView.tag = 1
            
            //Le agregamos efecto blur
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurEffectView.frame = thisImageView.bounds
            //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            self.blurEffectView.alpha = 0
            thisImageView.addSubview(self.blurEffectView)
        }
    
    }
    @IBAction func okBlurAction(_ sender: UIButton) {
        self.toolBar.isHidden = false
        self.scrollView.isScrollEnabled = true
        
        //Regresamos el Slider a sus Valor original
        self.slider.value = 0
    }
    @IBAction func sliderAction(_ sender: UISlider) {
        self.blurEffectView.alpha = CGFloat(self.slider.value)

    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        //No hacemos nada realmente, se puede omitir
        print(scrollView.contentOffset.x)
        
    }
    
    

}
