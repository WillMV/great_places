import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/utils/routers.dart';
import 'package:provider/provider.dart';

class MyPlacesPage extends StatefulWidget {
  const MyPlacesPage({super.key});

  @override
  State<MyPlacesPage> createState() => _MyPlacesPageState();
}

class _MyPlacesPageState extends State<MyPlacesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Meus Lugares',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.PLACE_FORM);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder(
          future:
              Provider.of<GreatPlaces>(context, listen: false).getItemsByDb(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<GreatPlaces>(
                builder: (context, places, child) => ListView.builder(
                  itemCount: places.items.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(places.getByIndex(index).title),
                    subtitle: Text(places.getByIndex(index).location.address),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.PLACE_DETAIL,
                      arguments: places.getByIndex(index),
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.file(
                          places.getByIndex(index).image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
