// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:prueba/domain/entities/image.dart';
import 'package:prueba/domain/entities/product.dart';

class DashboardAddProduct extends StatefulWidget {
  const DashboardAddProduct({super.key});

  @override
  State<DashboardAddProduct> createState() => _DashboardAddProductState();
}

class _DashboardAddProductState extends State<DashboardAddProduct> {
  File? _file;
  late dynamic result;
  var product = Product.empty();

  final formKey = GlobalKey<FormState>();

  pickImage(ImageSource source) {
    MyImage(source: source).pick(onPick: (File? file) {
      setState(() {
        _file = file;
        print("estado:");
        print(_file!.path);
      });
    });
  }

  Future<void> fetchData2() async {
    print("hola");
    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(
        Uri.parse('http://192.168.0.3:3001/api/auth/login'),
        headers: headers,
        body: jsonEncode(
            {"email": "naya.sports@gmail.com", "password": "Admin2023!"}));
    print(response);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> fetchData() async {
    print("hola fetch");
   
    if (_file == null) return print("no hoy foto");

    var headers = {'Content-Type': 'multipart/form-data'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.0.3:3001/api/productos'));
    request.fields.addAll({
      'referencia': product.ref,
      'precio_int': product.cost.toString(),
      'precio_venta': product.sellingPrice.toString(),
      'dimensiones': product.size,
      'nombre': product.productName,
      'descripcion': product.description,
      'marca': product.brand,
      'Categoria_idCategoria': product.category.toString()
    });
    request.files.add(await http.MultipartFile.fromPath('imagen', _file!.path));
request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print("res");
    print(response);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print("exito");
    } else {
      print(response.reasonPhrase);
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BackgroundWhite.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("NayaSport - Dashboard"),
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            const Text("Añadir Nuevo Producto",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 0, 116, 131))),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Nombre Producto",
                              ),
                              onSaved: (value) {
                                product.productName = value.toString();
                              },
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Complete la información";
                                }
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Ref",
                              ),
                              onSaved: (value) {
                                product.ref = value.toString();
                              },
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Complete la información";
                                }
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Costo",
                              ),
                              onSaved: (value) {
                                product.cost = int.parse(value.toString());
                              },
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Complete la información";
                                }
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Precio",
                              ),
                              onSaved: (value) {
                                product.sellingPrice =
                                    int.parse(value.toString());
                              },
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Complete la información";
                                }
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Categoria",
                              ),
                              onSaved: (value) {
                                product.category =
                                    int.parse(value.toString());
                              },
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Complete la información";
                                }
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Tamaño",
                              ),
                              onSaved: (value) {
                                product.size = value.toString();
                              },
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Complete la información";
                                }
                              },
                            ),
                            const Row(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 5),
                                  child: Text("Imagen",
                                      textAlign: TextAlign.right))
                            ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: ElevatedButton(
                                        child: const Text("Tomar Foto"),
                                        onPressed: () {
                                          pickImage(ImageSource.camera);
                                        },
                                      )),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: OutlinedButton(
                                        child: const Text("Galeria"),
                                        onPressed: () {
                                          pickImage(ImageSource.gallery);
                                        },
                                      ))
                                ]),
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.amber),
                              ),
                              child: const Text("Enviar"),
                              onPressed: () {
                                fetchData();
                              },
                            ),
                            if (_file != null) Image.file(_file!)
                          ],
                        ))))));
  }

  void _showData(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();

      // ignore: avoid_print
      print(product.cost);
      // ignore: avoid_print
      print(product.productName);
    }
  }
}