import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../sip_ua.dart';

class RegisterWidget extends StatefulWidget {
  final SIPUAHelper _helper;
  RegisterWidget(this._helper, {Key? key}) : super(key: key);
  @override
  _MyRegisterWidget createState() => _MyRegisterWidget();
}

class _MyRegisterWidget extends State<RegisterWidget>
    implements SipUaHelperListener {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _wsUriController = TextEditingController();
  final TextEditingController _sipUriController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _authorizationUserController = TextEditingController();
  final Map<String, String> _wsExtraHeaders = {
    'Origin': 'http://cld.alovoice.uz',
    'Host': 'cld.alovoice.uz:61040'
  };
  late SharedPreferences _preferences;
  late RegistrationState _registerState;

  SIPUAHelper get helper => widget._helper;

  @override
  initState() {
    super.initState();
    _registerState = helper.registerState;
    helper.addSipUaHelperListener(this);
    // _loadSettings();
  }

  @override
  deactivate() {
    super.deactivate();
    helper.removeSipUaHelperListener(this);
    // _saveSettings();
  }
  //
  // void _loadSettings() async {
  //   _preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     _wsUriController.text =
  //         _preferences.getString('ws_uri') ?? 'wss://cld.alovoice.uz:61040';
  //     _sipUriController.text =
  //         _preferences.getString('sip_uri') ?? 'https://cld.alovoice.uz:65040';
  //     _displayNameController.text =
  //         _preferences.getString('display_name') ?? 'Flutter SIP UA';
  //     _passwordController.text = _preferences.getString('password') ?? '8b1e39';
  //     _authorizationUserController.text = _preferences.getString('auth_user') ?? "3006";
  //   });
  // }
  //
  // void _saveSettings() {
  //   _preferences.setString('ws_uri', _wsUriController.text);
  //   _preferences.setString('sip_uri', _sipUriController.text);
  //   _preferences.setString('display_name', _displayNameController.text);
  //   _preferences.setString('password', _passwordController.text);
  //   _preferences.setString('auth_user', _authorizationUserController.text);
  // }

  @override
  void registrationStateChanged(RegistrationState state) {
    setState(() {
      _registerState = state;
    });
  }

  void _alert(BuildContext context, String alertFieldName) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$alertFieldName is empty'),
          content: Text('Please enter $alertFieldName!'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void registeredSip() async {
    UaSettings settings = UaSettings();
    settings.webSocketUrl = 'wss://cld.alovoice.uz:61040/ws';
    settings.webSocketSettings.allowBadCertificate = true;
    settings.webSocketSettings.extraHeaders = _wsExtraHeaders;
    var uri = 'sip:3006@cld.alovoice.uz';
    settings.uri = uri;
    settings.authorizationUser =  "3006";
    settings.password = "8b1e39";
    settings.displayName = "3006";
    settings.iceGatheringTimeout = 1000;
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;
    helper.start(settings);
  }



  void _handleSave(BuildContext context) {


    UaSettings settings = UaSettings();

    settings.webSocketUrl = _wsUriController.text;
    settings.webSocketSettings.extraHeaders = _wsExtraHeaders;
    settings.webSocketSettings.allowBadCertificate = true;
    //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';

    settings.uri = _sipUriController.text;
    settings.authorizationUser = _authorizationUserController.text;
    settings.password = _passwordController.text;
    settings.displayName = _displayNameController.text;
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;

    helper.start(settings);
  }

  // void _handleSave(BuildContext context) {
  //
  //   UaSettings settings = UaSettings();
  //   settings.webSocketUrl = "wss://cld.alovoice.uz:61040";
  //   settings.webSocketSettings.extraHeaders = _wsExtraHeaders;
  //   settings.webSocketSettings.allowBadCertificate = true;
  //   settings.uri = "sip:3006@cld.alovoice.uz";
  //   settings.authorizationUser = "3006";
  //   settings.password = "8b1e39";
  //   settings.displayName = "3006";
  //   settings.userAgent = 'Dart SIP Client v1.0.0';
  //   settings.dtmfMode = DtmfMode.RFC2833;
  //
  //   helper.start(settings);
  // }

  // void _handleSave(BuildContext context) {
  //   // if (_wsUriController.text == null) {
  //   //   _alert(context, "WebSocket URL");
  //   // } else if (_sipUriController.text == null) {
  //   //   _alert(context, "SIP URI");
  //   // }
  //
  //   UaSettings settings = UaSettings();
  //
  //   settings.webSocketUrl = "wss://cld.alovoice.uz:61040";
  //   settings.webSocketSettings.extraHeaders = _wsExtraHeaders;
  //   settings.webSocketSettings.allowBadCertificate = true;
  //   // settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';
  //   settings.uri = "3006@cld.alovoice.uz:65040";
  //   settings.authorizationUser = "3006";
  //   settings.password = "8b1e39";
  //   settings.displayName = "8b1e39";
  //   settings.userAgent = 'Dart SIP Client';
  //   settings.dtmfMode = DtmfMode.RFC2833;
  //
  //   helper.start(settings);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SIP Account"),
        ),
        body: Align(
            alignment: const Alignment(0, 0),
            child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(48.0, 18.0, 48.0, 18.0),
                        child: Center(
                            child: Text(
                              'Register Status: ${EnumHelper.getName(_registerState.state)}',
                              style: const TextStyle(fontSize: 18, color: Colors.black54),
                            )),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(48.0, 18.0, 48.0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('WebSocket:'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextFormField(
                          controller: _wsUriController,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('SIP URI:'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextFormField(
                          controller: _sipUriController,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Authorization User:'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextFormField(
                          controller: _authorizationUserController,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            hintText:
                            _authorizationUserController.text?.isEmpty ??
                                true
                                ? '[Empty]'
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Password:'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            hintText: _passwordController.text.isEmpty ?? true
                                ? '[Empty]'
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Display Name:'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextFormField(
                          controller: _displayNameController,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 0.0),
                      child: SizedBox(
                        height: 48.0,
                        width: 160.0,
                        child: MaterialButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () => registeredSip(),
                          child: const Text(
                            'Register',
                            style:
                            TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      ))
                ])));
  }

  @override
  void callStateChanged(Call call, CallState state) {
    //NO OP
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void onNewMessage(SIPMessageRequest msg) {
    // NO OP
  }

  @override
  void onNewNotify(Notify ntf) {
    // TODO: implement onNewNotify
  }
}
