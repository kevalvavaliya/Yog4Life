import 'package:http/http.dart' as http;
import 'dart:io';
import './secrets.dart';
import 'dart:convert';

class IpfsModel {
  final String? _cid;
  final int _statusCode;
  final String _status;

  int get getStatusCode => _statusCode;
  String get getStatus => _status;
  String? get getCid => _cid;

  IpfsModel({required cid, required statusCode, required status})
      : this._cid = cid,
        this._statusCode = statusCode,
        this._status = status;
}

class IpfsUtil {
  static Future<IpfsModel> uplodeImageToIPFS(File image) async {
    // upload image to estuary filecoin
    var estuaryUplodeData =
        Uri.parse("https://shuttle-4.estuary.tech/content/add");

    var multipart_request = http.MultipartRequest('POST', estuaryUplodeData);

    multipart_request.files
        .add(await http.MultipartFile.fromPath('data', image.path));
    multipart_request.headers.addAll({
      'Authorization': 'Bearer ${Secretes.API_KEY}',
      'Content-Type': 'multipart/form-data',
    });
    var response =
        await http.Response.fromStream(await multipart_request.send());
    print('img sent ipfs api called'+response.statusCode.toString());
    // print(response.body);
    var data = jsonDecode(response.body);

    //pinning data to ipfs
    var finalResponse =
        await _addPin(data['cid'], data['providers'][0].toString());

    return finalResponse;
  }

  static Future<IpfsModel> _addPin(String cid, String origin) async {
    var estuaryPinData = Uri.parse("https://api.estuary.tech/pinning/pins");

    var response = await http.post(
      estuaryPinData,
      headers: {
        'Authorization': 'Bearer ${Secretes.API_KEY}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "name": "feed_${cid}_.png",
        "cid": cid,
        "origins": [origin],
      }),
    );
    print("add pin api called" + response.statusCode.toString());
    // print('sts ' + response.statusCode.toString());
    // print('resp \n' + response.body);

    var data = jsonDecode(response.body);
    if (response.statusCode == 202) {
      IpfsModel ipfsModel = IpfsModel(
          cid: data['pin']['cid'],
          statusCode: response.statusCode,
          status: data['status']);
      return ipfsModel;
    } else {
      IpfsModel ipfsModel = IpfsModel(
          cid: null,
          statusCode: response.statusCode,
          status: data['error']['reason']);
      return ipfsModel;
    }
  }
}
