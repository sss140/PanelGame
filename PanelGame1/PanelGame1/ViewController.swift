
//

import UIKit
class MakePanel{
    var panelUIImageView = UIImageView()
    init(myRect:CGRect,myImage:UIImage){
        let cropCGImage:CGImage = (myImage.cgImage?.cropping(to: myRect))!
        let cropUIImage:UIImage = UIImage(cgImage: cropCGImage)
        panelUIImageView = UIImageView(image: cropUIImage)
        panelUIImageView.isUserInteractionEnabled = true
    }
}

class ViewController: UIViewController {
    var blancX:Int = 0
    var blancY:Int = 0
    
    let devidedNumber:Int = 3
    
    var bgView:UIImageView = UIImageView()
    
    var panelLength:CGFloat = CGFloat()
    var panelHalfLength:CGFloat = CGFloat()
    var panelSize:CGSize = CGSize()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let masterLength:CGFloat = self.view.bounds.width//画面の幅
        let masterHeight:CGFloat = self.view.bounds.height//画面の高さ
        let masterImageName:String = "20.White-and-Yellow-Flower.jpg"//使用する画像
        
        let backgroundImage:UIImage = makeBackground(myLength: masterLength)//まずはじめにグレーの背景を作成します。大きさはなるべく画面いっぱい
        bgView = UIImageView(image: backgroundImage)//グレーの背景をUIImageViewに入れて
        bgView.center = self.view.center//画面の中央にセットして
        bgView.isUserInteractionEnabled = true//タップを認識できるようにしておいて。
        self.view.addSubview(bgView)//表示します。
        
        let masterImage:UIImage = makeMasterImage(imageName: masterImageName, imageLength: masterLength, imageHeight: masterHeight)
        
        panelLength = masterLength / CGFloat(devidedNumber)
        panelHalfLength = panelLength/2
        panelSize = CGSize(width: panelLength, height: panelLength)
        
        for x in 0..<devidedNumber{
            let floatX = CGFloat(x)/CGFloat(devidedNumber)
            for y in 0..<devidedNumber{
                if !((x==0)&&(y==0)) {
                    let floatY = CGFloat(y)/CGFloat(devidedNumber)
                    let xPos:CGFloat = floatX * masterLength
                    let yPos:CGFloat = floatY * masterLength
                    let targetRect:CGRect = CGRect(origin: CGPoint(x: xPos, y: yPos), size: CGSize(width: panelLength, height: panelLength))
                    let initialPanel:UIImageView = MakePanel(myRect: targetRect,myImage: masterImage).panelUIImageView
                    initialPanel.layer.position = CGPoint(x: xPos + panelHalfLength, y: yPos + panelHalfLength)
                    initialPanel.tag = x + y * devidedNumber
                    bgView.addSubview(initialPanel)
                }
            }
        }
        shuffle(times: 100 * devidedNumber)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let target = touches.first!.view
        let targetTag:Int = target!.tag
        if targetTag>0{
            let pos = getPos(myPos: target!)
            initialPanel(myPos: pos)
        }
    }
    func makeBackground(myLength:CGFloat)->UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSize(width: myLength, height: myLength), false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        let drawRect:CGRect = CGRect(x: 0, y: 0, width: myLength, height: myLength)
        let drawPath = UIBezierPath(rect: drawRect)
        context?.setFillColor(UIColor.gray.cgColor)
        drawPath.fill()
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    func makeMasterImage(imageName:String,imageLength:CGFloat,imageHeight:CGFloat) -> UIImage{
        let myUIImage:UIImage = UIImage(named: imageName)!
        let myCropRect = CGRect(origin: CGPoint(x: 0, y: myUIImage.size.height/2 - myUIImage.size.width/2), size: CGSize(width: myUIImage.size.width, height: myUIImage.size.width))
        let myCropCGImage = (myUIImage.cgImage?.cropping(to: myCropRect))!
        let myCropUIImage = UIImage(cgImage: myCropCGImage)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageLength, height: imageLength), false, 1.0)
        myCropUIImage.draw(in: CGRect(x: 0, y: 0,  width: imageLength, height: imageLength))
        let myNewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return myNewImage!
    }
    func getPos(myPos:UIView)->(Int,Int){
        let posX:Int = Int(round(((myPos.layer.position.x)-panelHalfLength)/panelLength))
        let posY:Int = Int(round(((myPos.layer.position.y)-panelHalfLength)/panelLength))
        return (posX,posY)
    }
    func initialPanel(myPos: (Int,Int)){
        var startInt = Int()
        var endInt = Int()
        var moveDirection = Int()
        if blancX == myPos.0{
            print("moveVertically")
            if blancY < myPos.1 {
                startInt = blancY
                endInt = myPos.1
                moveDirection = -1
                moveVertically(startI: startInt, endI: endInt, directionI: moveDirection)
            }else{
                startInt = myPos.1
                endInt = blancY
                moveDirection = +1
                moveVertically(startI: startInt, endI: endInt, directionI: moveDirection)
            }
            blancY = myPos.1
        }else if blancY == myPos.1{
            print("moveHorizontally")
            if blancX < myPos.0 {
                startInt = blancX
                endInt = myPos.0
                moveDirection = -1
                moveHorizontally(startI: startInt, endI: endInt, directionI: moveDirection)
            }else{
                startInt = myPos.0
                endInt = blancX
                moveDirection = +1
                moveHorizontally(startI: startInt, endI: endInt, directionI: moveDirection)
            }
            blancX = myPos.0
            checkResult()
        }
    }
    func moveHorizontally(startI:Int,endI:Int,directionI:Int){
        for v in bgView.subviews{
            let posV = getPos(myPos: v)
            if posV.1 == blancY {
                switch posV.0{
                case (startI...endI):
                    UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options:[] , animations: {v.layer.position.x += self.panelLength * CGFloat(directionI)}, completion:nil)
                default:
                    print("")
                }
            }
        }
    }
    func moveVertically(startI:Int,endI:Int,directionI:Int){
        for v in bgView.subviews{
            let posV = getPos(myPos: v)
            if posV.0 == blancX {
                switch posV.1{
                case (startI...endI):
                    UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options:[] , animations: {v.layer.position.y += self.panelLength * CGFloat(directionI)}, completion: nil)
                default:
                    print("")
                }
            }
        }
    }
    func checkResult(){
        var checkFlg:Bool = true
        for v in bgView.subviews{
            let posC = getPos(myPos: v)
            let tgtTag = posC.0 + posC.1 * devidedNumber
            if v.tag != tgtTag {
                checkFlg = false
            }
        }
        print(checkFlg)
    }
    func shuffle(times:Int){
        for i in 0..<times{
            initialPanel(myPos: (Int(arc4random_uniform(UInt32(devidedNumber))),Int(arc4random_uniform(UInt32(devidedNumber)))))
        }
    }
}
