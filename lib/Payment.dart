import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {

  Razorpay razorpay;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void openCheckout(){
    var options = {
      "key" : "rzp_test_8QZIaleHjtz7vR",
      "amount" : num.parse(textEditingController.text)*100,
      "name" : "Notes App",
      "description" : "Payment for developer",
    //   "prefill" : {
    //     "contact" : "2323232323",
    //     "email" : "shdjsdh@gmail.com"
    //   },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razorpay.open(options);

    }catch(e){
      print(e.toString());
    }

  }

  void handlerPaymentSuccess(){
    print("Pament success");
    Toast.show("Pament success", context);
  }

  void handlerErrorFailure(){
    print("Pament error");
    Toast.show("Pament error", context);
  }

  void handlerExternalWallet(){
    print("External Wallet");
    Toast.show("External Wallet", context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
        child: Column(
          children: [
           // RichText(text: InlineSpan(Text.rich("")) ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(child: CircleAvatar(backgroundColor: Colors.grey,child: Icon(Icons.arrow_back)),onTap: (){Navigator.pop(context);},),
                SizedBox(width: 50,),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("PLEASE",style: TextStyle(color: Colors.black,fontSize: 22),),
                      SizedBox(width: 5,),
                      Text("DONATE",style: TextStyle(color: Colors.black38,fontSize: 22),),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)),borderSide: BorderSide(color: Colors.black45)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)),borderSide: BorderSide(color: Colors.black45)
                        ),
                        hintText: "Please enter Amount to Pay",
                        labelText: "Please enter Amount to Pay",
                        labelStyle: TextStyle(color: Colors.black45)
                    ),
                  ),
                  SizedBox(height: 12,),
                  ElevatedButton(
                    child: Text("Donate Now", style: TextStyle(
                        color: Colors.white
                    ),),
                    onPressed: (){
                      openCheckout();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}