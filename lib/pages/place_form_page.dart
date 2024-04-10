import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/image_input.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/providers/location_provider.dart';
import 'package:great_places/utils/routers.dart';
import 'package:provider/provider.dart';

class PlaceFormPage extends StatefulWidget {
  const PlaceFormPage({super.key});

  @override
  State<PlaceFormPage> createState() => _PlaceFormPageState();
}

class _PlaceFormPageState extends State<PlaceFormPage> {
  File? _imageFile;

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  void _submitForm() {
    final validade = _formKey.currentState!.validate();
    final LocationProvider location = Provider.of(context, listen: false);

    if (validade && _imageFile != null && location.position != null) {
      location.getAddressByLocation().then((address) {
        Provider.of<GreatPlaces>(context, listen: false).addItem({
          'title': _titleController.text,
          'image': _imageFile,
          'latitude': location.position!.latitude,
          'longitude': location.position!.longitude,
          'address': address,
        });

        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final LocationProvider local = Provider.of(context);

    final appBar = AppBar(title: const Text('Novo Lugar'));

    final media = MediaQuery.of(context);

    final availableHeight =
        media.size.height - media.padding.top - appBar.preferredSize.height;

    final bool isValidate = (_titleController.text.isNotEmpty &&
        _imageFile != null &&
        local.staticMapUrl.isNotEmpty);

    return Scaffold(
      appBar: appBar,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: availableHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        onChanged: (text) {
                          setState(() {});
                        },
                        validator: (value) {
                          final title = value ?? '';
                          if (title.isEmpty) {
                            return 'O título é obrigatório';
                          }
                          if (title.length < 4) {
                            return 'Deve ter ao menos 4 letras';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text('Título'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: _imageFile != null
                                ? Image.file(
                                    _imageFile!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(child: Text('Nenhuma imagem!')),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.camera),
                                  label: const Text('Tirar foto'),
                                  onPressed: () async {
                                    final imageFile =
                                        await ImageInput().takePicture();
                                    if (imageFile != null) {
                                      setState(() {
                                        _imageFile = imageFile;
                                      });
                                    }
                                  },
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.image),
                                  label: const Text('Galeria'),
                                  onPressed: () async {
                                    final imageFile =
                                        await ImageInput().galleryPicture();
                                    if (imageFile != null) {
                                      setState(() {
                                        _imageFile = imageFile;
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: local.staticMapUrl.isEmpty
                            ? const Center(
                                child: Text('Locazação não informada!'))
                            : Image.network(
                                local.staticMapUrl,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: TextButton.icon(
                              icon: const Icon(Icons.location_on),
                              label: const Text('Localização atual'),
                              onPressed: () => local.setMapCurrentLocation(),
                            ),
                          ),
                          Flexible(
                            child: TextButton.icon(
                              label: const Text('Selecione no Mapa'),
                              icon: const Icon(Icons.map),
                              onPressed: () async {
                                final location = await Navigator.of(context)
                                    .pushNamed(AppRoutes.MAP_PAGE);
                                if (location != null) {
                                  local.setMapSelectedLocation(
                                      location as LatLng);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        isValidate ? Colors.blue.shade900 : Colors.grey),
                    shape: const MaterialStatePropertyAll(
                        BeveledRectangleBorder()),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  label: const Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: isValidate ? _submitForm : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
