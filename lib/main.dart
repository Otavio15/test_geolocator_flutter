import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Position
      _localizacao; //Position dentro do pacote geolocator.dart (latitude e longtude)
  String _endereco = "";
  String _cep = "";
  String _estado = "";
  String _rua = "";
  String _numero = "";
  String _latitude = "";
  String _longetude = "";
  String _bairro = "";
  String _cidade = "";
  String _tudo = "";

  _carregarLocalizacao() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnable) {
      Fluttertoast.showToast(msg: "Por favor ativar sua localização");
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Permissão não ateita para obter localização");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Permissão para obter localização bloqueada");
    }

    Position posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //Até aqui carregamos a Latitude e Longitude
    try {
      List<Placemark> placemark =
          await placemarkFromCoordinates(posicao.latitude, posicao.longitude);
      Placemark place = placemark[0];
      setState(() {
        _latitude = posicao.latitude.toString();
        _longetude = posicao.longitude.toString();
        _endereco = place.locality.toString();
        _rua = place.street.toString();
        _estado = place.administrativeArea.toString();
        _cep = place.postalCode.toString();
        _numero = place.name.toString();
        _bairro = place.subLocality.toString();
        _cidade = place.subAdministrativeArea.toString();
        _tudo = place.toString();
      });
    } catch (exept) {}
  }

  @override
  void initState() {
    super.initState();
    _carregarLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Latitude: ${_latitude}"),
                      Text("Longitude: ${_longetude}"),
                      Text("Endereço: ${_endereco}"),
                      Text("Rua: ${_rua}"),
                      Text("Estado: ${_estado}"),
                      Text("CEP: ${_cep}"),
                      Text("Numero: ${_numero}"),
                      Text("Bairro: ${_bairro}"),
                      Text("Cidade: ${_cidade}"),
                      Text(""),
                      Text(_tudo)
                    ],
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _carregarLocalizacao();
                },
                child: Text("Atualizar"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
