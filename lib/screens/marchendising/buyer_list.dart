import 'package:flutter/material.dart';
import 'package:menu_bar/model/buyer.dart';
import 'package:menu_bar/screens/marchendising/add_buyer.dart';
import 'package:menu_bar/services/buyer_service.dart';

class BuyerListScreen extends StatefulWidget {
  const BuyerListScreen({super.key});

  @override
  BuyerListScreenState createState() => BuyerListScreenState();
}

class BuyerListScreenState extends State<BuyerListScreen> {
  List<Buyer> buyers = [];
  //this is for making the object from the service
  final ApiService apiService =ApiService();
  // this is initState method that loads at the begining of the component loads
  @override
   void initState(){
    super.initState();
    fetchAllBuyers();// this method to call here
   }
   // this is the method to fetch all the buyers from the database
   void fetchAllBuyers() async{
    try{
      final data=await apiService.getAllBuyers();
      setState(() {
        buyers=data;
      });
    }//end of try
    catch(e){
      debugPrint('Error fetching the buyers:$e');
    }
   }//end of fetchAllBuyers()
   // this is deleteBuyer method
  void deleteBuyer(int buyerId) {
    setState(() {
      apiService.deleteBuyer(buyerId);
     // buyers.remove(buyer);
    });
  }
// this is  the method to the edetBuyer mthod
  void editBuyer(Buyer buyer) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddBuyerScreen(buyer: buyer),
    ),
  );
  fetchAllBuyers(); // refresh the list after return
}


  void downloadReport() async {
  try {
    
    await apiService.downloadBuyerReport();
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF downloaded and opened')),
    );
  } catch (e) {
    if (!mounted) return;
     debugPrint('Download error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(content: Text('Failed to download report')),
    );
    
  }
}

  // end of deleteBuyer method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buyer List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: downloadReport,
                child: const Text("Download"),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Buyer ID")),
                    DataColumn(label: Text("Buyer Name")),
                    DataColumn(label: Text("Contact Person")),
                    DataColumn(label: Text("Email")),
                    DataColumn(label: Text("Phone")),
                    DataColumn(label: Text("Address")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: buyers.map((buyer) {
                    return DataRow(
                      cells: [
                        DataCell(Text(buyer.buyerId?.toString() ?? '')),
                        DataCell(Text(buyer.buyerName)),
                        DataCell(Text(buyer.contactPerson)),
                        DataCell(Text(buyer.email)),
                        DataCell(Text(buyer.phone)),
                        DataCell(Text(buyer.address)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => editBuyer(buyer),
                                icon:const Icon(Icons.edit, color: Colors.green),
                              ),
                              IconButton(
                                onPressed:(){
                                  if (buyer.buyerId !=null){
                                    deleteBuyer(buyer.buyerId!);
                                  }
                                  else{
                                    debugPrint('buyerId is null');
                                  }
                                }, //deleteBuyer(buyer.buyerId),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
void editBuyer(Buyer buyer) async {
  await Navigator.pushNamed(
    context,
    '/ab',
    arguments: buyer,
  );
  fetchAllBuyers(); // Refresh the list
}

 */