import 'package:flutter/material.dart';
enum Layout { vertical, horizontal }
class DropdownWithSearch<T> extends StatelessWidget {

  final String title;
  final String placeHolder;
  final T selected;
  final List items;
  final EdgeInsets? selectedItemPadding,selectedIconPadding;
  final TextStyle? selectedItemStyle;
  final double? selectedItemHeight;
  final TextStyle? dropdownHeadingStyle;
  final TextStyle? itemStyle;
  final BoxDecoration? decoration, disabledDecoration;
  final double? searchBarRadius,labelPositionTop,labelPositionLeft;
  final double? iconSize;
  final double? dialogRadius;
  final bool disabled,isElevated;
  final Layout layout;
  final Function onChanged;
  final IconData? pointerIcon;
  final bool hasLabel;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final BoxShadow? boxShadow;
  const DropdownWithSearch(
      {Key? key,
      /// The title of the field
      required this.title,
      required this.placeHolder,
      required this.items,
      required this.selected,
      required this.onChanged,
      this.selectedItemPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      this.selectedIconPadding = const EdgeInsets.only(bottom: 0,),
      this.selectedItemStyle,
      this.selectedItemHeight = 56,
      this.dropdownHeadingStyle,
      this.itemStyle,
      this.pointerIcon = Icons.keyboard_arrow_down_rounded,
      this.layout = Layout.horizontal,
      this.hasLabel = false,
      this.isElevated = false,
      this.boxShadow,
      this.labelText = 'Label Text',
      this.labelPositionTop = 20,
      this.labelPositionLeft = 10,
      this.labelTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 12,
      ),
      this.iconSize = 25,
      this.decoration,
      this.disabledDecoration,
      this.searchBarRadius,
      this.dialogRadius,
      this.disabled = false})
      : super(key: key);


  @override
  Widget build(BuildContext context) {


    Widget labelTextOutputPlain (){
      return hasLabel == true ? Container(
        padding: EdgeInsets.only(left:8, top: 8, right: 8,),
        height: 25,
        width: double.maxFinite,
        child: Text(
              labelText!,
              style: labelTextStyle,
            ),
      ) : SizedBox(width:0,height: 0,);
    }

    BoxShadow elevatedShadow(){
      if(isElevated == true && boxShadow != null){
        return boxShadow!;
      }

      return BoxShadow(
        color: isElevated == false ? Colors.transparent :Colors.black.withOpacity(0.3),
        offset: Offset.fromDirection(20,4),
        blurRadius: 5,
        spreadRadius: 0,
      );
    }

    double contentHeight(){
      return hasLabel == true ? selectedItemHeight! - 20 : selectedItemHeight!;
    }



    BoxDecoration? containerDecor(){
      return !disabled
        ? decoration != null
        ? decoration
        : BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
        border: Border.all(
            color: Colors.grey.shade300,
            width: 1),
        )
        : disabledDecoration != null
        ? disabledDecoration
          : BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.grey.shade300,
          border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
          )
        );
    }

    return AbsorbPointer(
      absorbing: disabled,
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => SearchDialog(
                  placeHolder: placeHolder,
                  title: title,
                  searchInputRadius: searchBarRadius,
                  dialogRadius: dialogRadius,
                  titleStyle: dropdownHeadingStyle,
                  itemStyle: itemStyle,
                  items: items)).then((value) {
            onChanged(value);
            /* if(value!=null)
                    {
                      onChanged(value);
                      _lastSelected = value;
                    }
                    else {
                      print("Value NULL $value $_lastSelected");
                      onChanged(_lastSelected);
                    }*/
          });
        },
        child: Container(
          height: selectedItemHeight! + 10.0,
          width: double.maxFinite,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            boxShadow: [
              elevatedShadow(),
            ],
          ),
          child: Container(
            decoration: containerDecor(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: hasLabel == true ? MainAxisAlignment.start: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                labelTextOutputPlain(),
                // Text('Hello World'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      // fit: FlexFit.loose,
                      flex: 9,
                      child: Container(
                        height: contentHeight(),
                        padding: selectedItemPadding,
                        child: Text(
                          selected.toString() == "Country"
                            || selected.toString() == "State"
                            || selected.toString() == "City"
                            ? title : selected.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: selectedItemStyle != null
                              ? selectedItemStyle
                              : TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      // fit: FlexFit.loose,
                      flex: 3,
                      child: Container(
                        height: contentHeight(),
                        padding: selectedIconPadding,
                        child: Icon(
                          pointerIcon,
                          color: Colors.black,
                          size: iconSize,
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}

class SearchDialog extends StatefulWidget {
  final String title;
  final String placeHolder;
  final List items;
  final TextStyle? titleStyle;
  final TextStyle? itemStyle;
  final double? searchInputRadius;

  final double? dialogRadius;

  const SearchDialog(
      {Key? key,
      required this.title,
      required this.placeHolder,
      required this.items,
      this.titleStyle,
      this.searchInputRadius,
      this.dialogRadius,
      this.itemStyle})
      : super(key: key);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState<T> extends State<SearchDialog> {
  TextEditingController textController = TextEditingController();
  late List filteredList;

  @override
  void initState() {
    filteredList = widget.items;
    textController.addListener(() {
      setState(() {
        if (textController.text.isEmpty) {
          filteredList = widget.items;
        } else {
          filteredList = widget.items
              .where((element) => element
                  .toString()
                  .toLowerCase()
                  .contains(textController.text.toLowerCase()))
              .toList();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      shape: RoundedRectangleBorder(
          borderRadius: widget.dialogRadius != null
              ? BorderRadius.circular(widget.dialogRadius!)
              : BorderRadius.circular(14)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.title,
                    style: widget.titleStyle != null
                        ? widget.titleStyle
                        : TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    })
                /*Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: widget.titleStyle != null
                          ? widget.titleStyle
                          : TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )),
              )*/
              ],
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: widget.placeHolder,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        widget.searchInputRadius != null
                            ? Radius.circular(widget.searchInputRadius!)
                            : Radius.circular(5)),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        widget.searchInputRadius != null
                            ? Radius.circular(widget.searchInputRadius!)
                            : Radius.circular(5)),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
                style: widget.itemStyle != null
                    ? widget.itemStyle
                    : TextStyle(fontSize: 14),
                controller: textController,
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(widget.dialogRadius != null
                    ? Radius.circular(widget.dialogRadius!)
                    : Radius.circular(5)),
                //borderRadius: widget.dialogRadius!=null?BorderRadius.circular(widget.dropDownRadius!):BorderRadius.circular(14),
                child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context, filteredList[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 18),
                            child: Text(
                              filteredList[index].toString(),
                              style: widget.itemStyle != null
                                  ? widget.itemStyle
                                  : TextStyle(fontSize: 14),
                            ),
                          ));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  /// Creates a dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  const CustomDialog({
    Key? key,
    this.child,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
    this.constraints = const BoxConstraints(
        minWidth: 280.0, minHeight: 280.0, maxHeight: 400.0, maxWidth: 400.0),
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to 100 milliseconds.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve insetAnimationCurve;

  /// {@template flutter.material.dialog.shape}
  /// The shape of this dialog's border.
  ///
  /// Defines the dialog's [Material.shape].
  ///
  /// The default shape is a [RoundedRectangleBorder] with a radius of 2.0.
  /// {@endtemplate}
  final ShapeBorder? shape;
  final BoxConstraints constraints;

  Color _getColor(BuildContext context) {
    return Theme.of(context).dialogBackgroundColor;
  }

  // TODO(johnsonmh): Update default dialog border radius to 4.0 to match material spec.
  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)));

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: constraints,
            child: Material(
              elevation: 15.0,
              color: _getColor(context),
              type: MaterialType.card,
              child: child,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
            ),
          ),
        ),
      ),
    );
  }
}
