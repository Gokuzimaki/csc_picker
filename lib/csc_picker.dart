library csc_picker;

import 'package:csc_picker/dropdown_with_search.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'model/select_status_model.dart';

enum Layout { vertical, horizontal }
enum CountryFlag { SHOW_IN_DROP_DOWN_ONLY, ENABLE, DISABLE }

class CSCPicker extends StatefulWidget {
  final ValueChanged<String>? onCountryChanged;
  final ValueChanged<String?>? onStateChanged;
  final ValueChanged<String?>? onCityChanged;

  ///Parameters to change style of CSC Picker
  final TextStyle? selectedItemStyle, labelStyle, dropdownHeadingStyle, dropdownItemStyle;
  final BoxDecoration? dropdownDecoration, disabledDropdownDecoration;
  final bool showStates, showCities;
  final CountryFlag flagState;
  final Layout layout;
  final double? searchBarRadius, selectedItemHeight;
  final String defaultTitle,defaultTitleState,defaultTitleCity;
  final String? selectedItemPlaceholder,selectedItemPlaceholderState, selectedItemPlaceholderCity;


  final double? dropdownDialogRadius,labelPositionTop,labelPositionLeft;
  final EdgeInsets? selectedItemPadding;
  final bool hasLabel;
  final String labelText;
  final IconData pointerIcon;

  ///CSC Picker Constructor
  const CSCPicker({
        Key? key,
        this.onCountryChanged,
        this.onStateChanged,
        this.onCityChanged,
        this.selectedItemStyle,
        this.selectedItemHeight,
        this.selectedItemPadding,
        this.selectedItemPlaceholder,
        this.selectedItemPlaceholderState,
        this.selectedItemPlaceholderCity,
        this.pointerIcon = Icons.keyboard_arrow_down_rounded,
        this.hasLabel = false,
        this.labelText = 'Choose',
        this.labelStyle,
        this.labelPositionTop,
        this.labelPositionLeft,
        this.defaultTitle = "Country",
        this.defaultTitleState = "State",
        this.defaultTitleCity = "City",
        this.dropdownHeadingStyle,
        this.dropdownItemStyle,
        this.dropdownDecoration,
        this.disabledDropdownDecoration,
        this.searchBarRadius,
        this.dropdownDialogRadius,
        this.flagState = CountryFlag.ENABLE,
        this.layout = Layout.horizontal,
        this.showStates = true,
        this.showCities = true,
    }) : super(key: key);

  @override
  _CSCPickerState createState() => _CSCPickerState();
}

class _CSCPickerState extends State<CSCPicker> {
  List<String?> _cities = [];
  List<String?> _country = [];
  List<String?> _states = [];

  String _selectedCity = "City";
  String? _selectedCountry;
  String _selectedState = "State";
  var responses;

  @override
  void initState() {
    // TODO: implement initState
    getCounty();
    super.initState();
  }

  ///Read JSON country data from assets
  Future getResponse() async {
    var res = await rootBundle
        .loadString('packages/csc_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  ///get countries from json response
  Future getCounty() async {
    _country.clear();
    var countries = await getResponse() as List;
    countries.forEach((data) {
      var model = Country();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) return;
      setState(() {
        widget.flagState == CountryFlag.ENABLE ||
                widget.flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY
            ? _country.add(model.emoji! +
                "    " +
                model.name!) /* : _country.add(model.name)*/
            : _country.add(model.name);
      });
    });
    return _country;
  }

  ///get states from json response
  Future getState() async {
    _states.clear();
    //print(_selectedCountry);
    var response = await getResponse();
    var takeState = widget.flagState == CountryFlag.ENABLE ||
            widget.flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY
        ? response
            .map((map) => Country.fromJson(map))
            .where(
                (item) => item.emoji + "    " + item.name == _selectedCountry)
            .map((item) => item.state)
            .toList()
        : response
            .map((map) => Country.fromJson(map))
            .where((item) => item.name == _selectedCountry)
            .map((item) => item.state)
            .toList();
    var states = takeState as List;
    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        for (var stateName in name) {
          //print(stateName.toString());
          _states.add(stateName.toString());
        }
      });
    });
    _states.sort((a, b) => a!.compareTo(b!));
    return _states;
  }

  ///get cities from json response
  Future getCity() async {
    _cities.clear();
    var response = await getResponse();
    var takeCity = widget.flagState == CountryFlag.ENABLE ||
            widget.flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY
        ? response
            .map((map) => Country.fromJson(map))
            .where(
                (item) => item.emoji + "    " + item.name == _selectedCountry)
            .map((item) => item.state)
            .toList()
        : response
            .map((map) => Country.fromJson(map))
            .where((item) => item.name == _selectedCountry)
            .map((item) => item.state)
            .toList();
    var cities = takeCity as List;
    cities.forEach((f) {
      var name = f.where((item) => item.name == _selectedState);
      var cityName = name.map((item) => item.city).toList();
      cityName.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesName = ci.map((item) => item.name).toList();
          for (var cityName in citiesName) {
            //print(cityName.toString());
            _cities.add(cityName.toString());
          }
        });
      });
    });
    _cities.sort((a, b) => a!.compareTo(b!));
    return _cities;
  }

  ///get methods to catch newly selected country state and city and populate state based on country, and city based on state
  void _onSelectedCountry(String value) {
    if (!mounted) return;
    setState(() {
      if (widget.flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY) {
        try {
          this.widget.onCountryChanged!(value.substring(6).trim());
        } catch (e) {}
      } else
        this.widget.onCountryChanged!(value);
      //code added in if condition
      if (value != _selectedCountry) {
        _states.clear();
        _cities.clear();
        _selectedState = "State";
        _selectedCity = "City";
        this.widget.onStateChanged!(null);
        this.widget.onCityChanged!(null);
        _selectedCountry = value;
        getState();
      } else {
        this.widget.onStateChanged!(_selectedState);
        this.widget.onCityChanged!(_selectedCity);
      }
    });
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      this.widget.onStateChanged!(value);
      //code added in if condition
      if (value != _selectedState) {
        _cities.clear();
        _selectedCity = "City";
        this.widget.onCityChanged!(null);
        _selectedState = value;
        getCity();
      } else {
        this.widget.onCityChanged!(_selectedCity);
      }
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      //code added in if condition
      if (value != _selectedCity) {
        _selectedCity = value;
        this.widget.onCityChanged!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.layout == Layout.vertical
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  countryDropdown(title: widget.defaultTitle,
                      placeholder: widget.selectedItemPlaceholder),
                  SizedBox(
                    height: 10.0,
                  ),
                  stateDropdown(title: widget.defaultTitleState,
                      placeholder: widget.selectedItemPlaceholderState),
                  SizedBox(
                    height: 10.0,
                  ),
                  cityDropdown(title: widget.defaultTitleCity,
                      placeholder: widget.selectedItemPlaceholderCity)
                ],
              )
            : Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(/*fit: FlexFit.loose,*/
                        flex: 6,
                        child: countryDropdown(title: widget.defaultTitle,
                            placeholder: widget.selectedItemPlaceholder),
                      ),
                      widget.showStates
                          ? SizedBox(
                              width: 10.0,
                            )
                          : Container(),
                      widget.showStates
                          ?
                      Expanded(/*fit: FlexFit.loose,*/
                        flex: 6,
                        child: stateDropdown(title: widget.defaultTitleState,
                            placeholder: widget.selectedItemPlaceholderState)
                      )
                      : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  widget.showStates && widget.showCities
                      ? cityDropdown(title: widget.defaultTitleCity,
                      placeholder: widget.selectedItemPlaceholderCity)
                      : Container()
                ],
              ),
      ],
    );
  }

  ///filter Country Data according to user input
  Future<List<String?>> getCountryData(filter) async {
    var filteredList = _country
        .where(
            (country) => country!.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    if (filteredList.isEmpty)
      return _country;
    else
      return filteredList;
  }

  ///filter Sate Data according to user input
  Future<List<String?>> getStateData(filter) async {
    var filteredList = _states
        .where((state) => state!.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    if (filteredList.isEmpty)
      return _states;
    else
      return filteredList;
  }

  ///filter City Data according to user input
  Future<List<String?>> getCityData(filter) async {
    var filteredList = _cities
        .where((city) => city!.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    if (filteredList.isEmpty)
      return _cities;
    else
      return filteredList;
  }

  ///Country Dropdown Widget
  Widget countryDropdown({title,Layout layout:Layout.horizontal,placeholder:'Search Country',}) {
    return DropdownWithSearch(
      title: title,
      placeHolder: placeholder,
      selectedItemStyle: widget.selectedItemStyle,
      dropdownHeadingStyle: widget.dropdownHeadingStyle,
      selectedItemHeight: widget.selectedItemHeight,
      selectedItemPadding: widget.selectedItemPadding,
      itemStyle: widget.dropdownItemStyle,
      hasLabel: widget.hasLabel,
      labelText: widget.labelText,
      labelTextStyle: widget.labelStyle,
      labelPositionTop: widget.labelPositionTop,
      labelPositionLeft: widget.labelPositionLeft,
      pointerIcon: widget.pointerIcon,
      decoration: widget.dropdownDecoration,
      disabledDecoration: widget.disabledDropdownDecoration,
      disabled: _country.length == 0 ? true : false,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      items: _country.map((String? dropDownStringItem) {
        return dropDownStringItem;
      }).toList(),
      selected: _selectedCountry != null ? _selectedCountry : "Country",
      //selected: _selectedCountry != null ? _selectedCountry : "Country",
      //onChanged: (value) => _onSelectedCountry(value),
      onChanged: (value) {
        print("countryChanged $value $_selectedCountry");
        if (value != null) {
          _onSelectedCountry(value);
        }
      },
    );
  }

  ///State Dropdown Widget
  Widget stateDropdown({title, placeholder:'Search State'}) {
    return DropdownWithSearch(
      title: title,
      placeHolder: placeholder,
      disabled: _states.length == 0 ? true : false,
      items: _states.map((String? dropDownStringItem) {
        return dropDownStringItem;
      }).toList(),
      selectedItemStyle: widget.selectedItemStyle,
      dropdownHeadingStyle: widget.dropdownHeadingStyle,
      itemStyle: widget.dropdownItemStyle,
      hasLabel: widget.hasLabel,
      labelText: widget.labelText,
      labelTextStyle: widget.labelStyle,
      labelPositionTop: widget.labelPositionTop,
      labelPositionLeft: widget.labelPositionLeft,
      pointerIcon: widget.pointerIcon,
      selectedItemHeight: widget.selectedItemHeight,
      selectedItemPadding: widget.selectedItemPadding,
      decoration: widget.dropdownDecoration,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      disabledDecoration: widget.disabledDropdownDecoration,
      selected: _selectedState,
      //onChanged: (value) => _onSelectedState(value),
      onChanged: (value) {
        //print("stateChanged $value $_selectedState");
        value != null
            ? _onSelectedState(value)
            : _onSelectedState(_selectedState);
      },
    );
  }

  ///City Dropdown Widget
  Widget cityDropdown({ title, placeholder: 'Search City'}) {
    return DropdownWithSearch(
      title: title,
      placeHolder: placeholder,
      disabled: _cities.length == 0 ? true : false,
      items: _cities.map((String? dropDownStringItem) {
        return dropDownStringItem;
      }).toList(),
      selectedItemStyle: widget.selectedItemStyle,
      dropdownHeadingStyle: widget.dropdownHeadingStyle,
      itemStyle: widget.dropdownItemStyle,
      hasLabel: widget.hasLabel,
      labelText: widget.labelText,
      labelTextStyle: widget.labelStyle,
      labelPositionTop: widget.labelPositionTop,
      labelPositionLeft: widget.labelPositionLeft,
      pointerIcon: widget.pointerIcon,
      selectedItemHeight: widget.selectedItemHeight,
      selectedItemPadding: widget.selectedItemPadding,
      decoration: widget.dropdownDecoration,
      dialogRadius: widget.dropdownDialogRadius,
      searchBarRadius: widget.searchBarRadius,
      disabledDecoration: widget.disabledDropdownDecoration,
      selected: _selectedCity,
      //onChanged: (value) => _onSelectedCity(value),
      onChanged: (value) {
        //print("cityChanged $value $_selectedCity");
        value != null ? _onSelectedCity(value) : _onSelectedCity(_selectedCity);
      },
    );
  }
}
