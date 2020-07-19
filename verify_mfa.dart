import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerfiyMfa extends StatefulWidget {
  const VerfiyMfa();

  @override
  VerfiyMfaState createState() => VerfiyMfaState();
}

class VerfiyMfaState extends State<VerfiyMfa> {
  String code;
  bool loaded;
  bool shake;
  bool valid;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textNode = FocusNode();

  @override
  void initState() {
    super.initState();
    code = '';
    loaded = true;
    shake = false;
    valid = true;
  }

  void onCodeInput(String value) {
    setState(() {
      code = value;
    });
  }

  Future<void> verifyMfaAndNext() async {
    setState(() {
      loaded = false;
    });
    const bool result = false; //backend call
    setState(() {
      loaded = true;
      valid = result;
    });

    if (valid) {
      // do next
    } else {
      setState(() {
        shake = true;
      });
      await Future<String>.delayed(
          const Duration(milliseconds: 300), () => '1');
      setState(() {
        shake = false;
      });
    }
  }

  List<Widget> getField() {
    final List<Widget> result = <Widget>[];
    for (int i = 1; i <= 6; i++) {
      result.add(
        ShakeAnimatedWidget(
          enabled: shake,
          duration: const Duration(
            milliseconds: 100,
          ),
          shakeAngle: Rotation.deg(
            z: 20,
          ),
          curve: Curves.linear,
          child: Column(
            children: <Widget>[
              if (code.length >= i)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Text(
                    code[i - 1],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Container(
                  height: 5.0,
                  width: 30.0,
                  color: shake ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          SystemChannels.textInput.invokeMethod<String>('TextInput.hide');
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 80),
                child: Text(
                  'Verify your phone',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Text(
                'Please enter the 6 digit pin.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              if (!valid)
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(
                        'Whoops!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: valid ? 68 : 10,
              ),
              if (!valid)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    'It looks like you entered the wrong pin. Please try again.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 90,
                width: 300,
                // color: Colors.amber,
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1.0,
                      child: TextFormField(
                        controller: _controller,
                        focusNode: _textNode,
                        keyboardType: TextInputType.number,
                        onChanged: onCodeInput,
                        maxLength: 6,
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: getField(),
                      ),
                    )
                  ],
                ),
              ),
              CupertinoButton(
                onPressed: verifyMfaAndNext,
                color: Colors.grey,
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
