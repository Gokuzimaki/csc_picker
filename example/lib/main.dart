import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

/// This is a implementation of the Country State City Picker.
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSC Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'CSC Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, this.title='',}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Variables to store country state city data in onChanged method.
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 600,
            child: Column(
              children: [
                ///Adding CSC Picker Widget in app
                CSCPicker(
                  ///Enable disable state dropdown [OPTIONAL PARAMETER]
                  showStates: true,

                  /// Enable disable city drop down [OPTIONAL PARAMETER]
                  showCities: false,
                  defaultTitle: 'Your Country',
                  defaultTitleState: 'Your Location',
                  ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                  layout: Layout.vertical,

                  ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.yellow,
                      border: Border.all(color: Colors.transparent, width:0)),

                  ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 0)),

                  ///selected item style [OPTIONAL PARAMETER]
                  selectedItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),

                  hasLabel: false,

                  ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                  dropdownHeadingStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),

                  ///DropdownDialog Item style [OPTIONAL PARAMETER]
                  dropdownItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  ///Dialog box radius [OPTIONAL PARAMETER]
                  dropdownDialogRadius: 10.0,

                  ///Search bar radius [OPTIONAL PARAMETER]
                  searchBarRadius: 10.0,
                  selectedItemHeight: 56,
                  selectedItemPadding: EdgeInsets.only(top:15, left: 15),

                  ///triggers once country selected in dropdown
                  onCountryChanged: (value) {
                    setState(() {
                      ///store value in country variable
                      countryValue = value;
                    });
                  },



                  ///triggers once state selected in dropdown
                  onStateChanged: (value) {
                    setState(() {
                      ///store value in state variable
                      stateValue = value;
                    });
                  },

                  ///triggers once city selected in dropdown
                  onCityChanged: (value) {
                    setState(() {
                      ///store value in city variable
                      cityValue = value;
                    });
                  },
                ),

                ///print newly selected country state and city in Text Widget
                TextButton(
                    onPressed: () {
                      setState(() {
                        address = "$cityValue, $stateValue, $countryValue";
                      });
                    },
                    child: Text("Print Data")),
                Text(address)
              ],
            )),
      ),
    );
  }
}
