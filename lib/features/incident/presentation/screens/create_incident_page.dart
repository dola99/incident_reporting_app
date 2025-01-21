import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident_reporting_app/features/incident/data/models/sub_type_model.dart';
import 'package:incident_reporting_app/features/incident/presentation/cubit/incident_cubit.dart';
import 'package:incident_reporting_app/features/incident/presentation/cubit/incident_state.dart';
import 'package:incident_reporting_app/features/incident/data/models/type_model.dart';
import 'package:incident_reporting_app/core/utils/form_validator.dart';
import 'package:incident_reporting_app/injection_container.dart';

class CreateIncidentPage extends StatefulWidget {
  const CreateIncidentPage({super.key});

  @override
  CreateIncidentPageState createState() => CreateIncidentPageState();
}

class CreateIncidentPageState extends State<CreateIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  double _latitude = 0.0;
  double _longitude = 0.0;
  int? _selectedStatus;
  final String issuerId = 'dolla';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Incident'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Description Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val) => _description = val!.trim(),
                  validator: (val) {
                    return FormValidator.validateDescription(val);
                  },
                ),
                const SizedBox(height: 20),

                // Latitude Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSaved: (val) => _latitude = double.parse(val!.trim()),
                  validator: (val) {
                    return FormValidator.validateLatitude(val);
                  },
                ),
                const SizedBox(height: 20),

                // Longitude Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSaved: (val) => _longitude = double.parse(val!.trim()),
                  validator: (val) {
                    return FormValidator.validateLongitude(val);
                  },
                ),
                const SizedBox(height: 20),

                // Status Dropdown
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedStatus,
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Open')),
                    DropdownMenuItem(value: 1, child: Text('In Progress')),
                    DropdownMenuItem(value: 2, child: Text('Closed')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedStatus = val;
                    });
                  },
                  onSaved: (val) {
                    if (val != null) {
                      _selectedStatus = val;
                    }
                  },
                  validator: (val) {
                    if (val == null) {
                      return 'Please select a status';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                BlocConsumer<IncidentCubit, IncidentState>(
                  listener: (context, state) {
                    if (state is IncidentError) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is IncidentSubmitted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Incident submitted successfully')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<IncidentCubit>();
                    if (state is IncidentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return DropdownButtonFormField<IncidentTypeModel>(
                      decoration: const InputDecoration(
                        labelText: 'Incident Type',
                        border: OutlineInputBorder(),
                      ),
                      value: cubit.selectedType,
                      items: cubit.incidentsType.map((type) {
                        return DropdownMenuItem<IncidentTypeModel>(
                          value: type,
                          child: Text(type.englishName),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          getIt<IncidentCubit>().selectIncidentType(val);
                        }
                      },
                      onSaved: (val) {
                        if (val != null) {
                          getIt<IncidentCubit>().selectIncidentType(val);
                        }
                      },
                      validator: (val) {
                        if (val == null) {
                          return 'Please select an incident type';
                        }
                        return null;
                      },
                    );
                  },
                ),
                if (getIt<IncidentCubit>().selectedSubTypeList != null)
                  DropdownButtonFormField<SubTypeModel>(
                    decoration: const InputDecoration(
                      labelText: 'Incident Sub Type',
                      border: OutlineInputBorder(),
                    ),
                    value: getIt<IncidentCubit>().subTypeModel,
                    items:
                        getIt<IncidentCubit>().selectedSubTypeList?.map((type) {
                      return DropdownMenuItem<SubTypeModel>(
                        value: type,
                        child: Text(type.englishName),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {}
                    },
                    onSaved: (val) {
                      if (val != null) {}
                    },
                    validator: (val) {
                      if (val == null) {
                        return 'Please select an incident Sub type';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context.read<IncidentCubit>().submitIncident(
                            description: _description,
                            latitude: _latitude,
                            longitude: _longitude,
                            status: _selectedStatus!,
                            issuerId: issuerId,
                          );
                    }
                  },
                  child: const Text('Submit Incident'),
                ),
                const SizedBox(height: 20),

                // Loading Indicator
              ],
            ),
          )),
    );
  }
}
