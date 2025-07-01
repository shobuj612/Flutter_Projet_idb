class Buyer{
  int? buyerId;
String buyerName;
String contactPerson;
String email;
String phone;
String address;

  Buyer({this.buyerId, required this.buyerName,required this.contactPerson,required this.email,
    required this.phone, required this.address});

  //Buyer(this.buyerId, required this.buyerName,required this.contactPerson,required this.email,
    //required this.phone, required this.address);

//Buyer.name(this.buyerId, this.buyerName, this.contactPerson, this.email,
     // this.phone, this.address);

// thisi is the constructor

   factory Buyer.fromJson(Map<String,dynamic> json){// fromJosn is user defined .this convert json to dart object
     return Buyer(
       buyerId: json['buyerId'],
       buyerName: json['buyerName'],
       contactPerson: json['contactPerson'],
       email: json['email'],
       phone: json['phone'],
       address: json['address']
     );
   }

   Map<String ,dynamic> toJson(){// this is toJson is a userdefinded method. this convert dart object to Json
     return{
       'buyerId':buyerId,
       'buyerName':buyerName,
       'contactPerson':contactPerson,
       'email':email,
       'phone':phone,
       'address':address
     };
   }
}