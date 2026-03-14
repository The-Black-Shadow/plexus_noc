import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:plexus_noc/core/constant/app_strings.dart';
import 'package:plexus_noc/features/device_monitoring/presentation/bloc/device_list/device_list_bloc.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;

  // Centering the map roughly around Dhaka (based on our mock data coordinates)
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 12.0,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceListBloc, DeviceListState>(
      builder: (context, state) {
        if (state is DeviceListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DeviceListLoaded) {
          // Convert device list into Google Map Markers
          final Set<Marker> markers = state.devices.map((device) {
            final isOnline = device.isOnline;

            return Marker(
              markerId: MarkerId(device.id),
              position: LatLng(device.latitude, device.longitude),
              // Green for online, Red for offline
              icon: BitmapDescriptor.defaultMarkerWithHue(
                isOnline ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
              ),
              infoWindow: InfoWindow(
                title: device.name,
                snippet:
                    '${device.ipAddress} - ${isOnline ? AppStrings.onlineStatus : AppStrings.offlineStatus}',
                onTap: () {
                  // Navigate to details when the info window is tapped!
                  context.goNamed(
                    'device_details',
                    pathParameters: {'id': device.id},
                  );
                },
              ),
            );
          }).toSet();

          return GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: true,
          );
        }

        return Center(child: Text(AppStrings.mapDataUnavailable));
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
