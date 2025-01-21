// lib/features/incident/presentation/pages/incident_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident_reporting_app/features/incident/presentation/cubit/incident_cubit.dart';
import 'package:incident_reporting_app/features/incident/presentation/cubit/incident_state.dart';
import 'package:incident_reporting_app/features/incident/domain/entities/incident.dart';
import 'package:intl/intl.dart';
import 'create_incident_page.dart';

class IncidentListPage extends StatefulWidget {
  const IncidentListPage({super.key});

  @override
  IncidentListPageState createState() => IncidentListPageState();
}

class IncidentListPageState extends State<IncidentListPage> {
  DateTime? _selectedDate;
  int? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.wait([
      context.read<IncidentCubit>().fetchIncidentsType(),
      context.read<IncidentCubit>().fetchIncidents('2025-01-01')
    ]);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _applyFilters();
    }
  }

  void _applyFilters() {
    context.read<IncidentCubit>().filterIncidents(
          date: _selectedDate,
          status: _selectedStatus,
        );
  }

  void _clearFilters() {
    setState(() {
      _selectedDate = null;
      _selectedStatus = null;
    });
    context.read<IncidentCubit>().filterIncidents(); // No filters
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateIncidentPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildIncidentList()),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDate != null
                        ? DateFormat.yMd().format(_selectedDate!)
                        : 'Select Date',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedStatus,
                  items: [
                    DropdownMenuItem(value: 0, child: const Text('Open')),
                    DropdownMenuItem(
                        value: 1, child: const Text('In Progress')),
                    DropdownMenuItem(value: 2, child: const Text('Closed')),
                  ],
                  onChanged: (status) {
                    setState(() {
                      _selectedStatus = status;
                    });
                    _applyFilters();
                  },
                  hint: const Text('Select Status'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearFilters,
                tooltip: 'Clear Filters',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentList() {
    return BlocBuilder<IncidentCubit, IncidentState>(
      builder: (context, state) {
        List<Incident> incidents = [];

        if (state is IncidentsLoaded) {
          incidents = state.incidents;
        } else if (state is IncidentsFiltered) {
          incidents = state.filteredIncidents;
        } else if (state is IncidentError) {
          return Center(child: Text(state.message));
        }

        if (incidents.isEmpty) {
          return const Center(child: Text('No incidents found.'));
        }

        return ListView.builder(
          itemCount: incidents.length,
          itemBuilder: (context, index) {
            final incident = incidents[index];
            return ListTile(
              title: Text(incident.description),
              subtitle: Text(
                  'Date: ${DateFormat.yMd().format(incident.createdAt)}, Status: ${_statusToString(incident.status)}'),
              onTap: () {
                // Implement onTap functionality, e.g., view details or edit
              },
            );
          },
        );
      },
    );
  }

  String _statusToString(int status) {
    switch (status) {
      case 0:
        return 'Open';
      case 1:
        return 'In Progress';
      case 2:
        return 'Closed';
      default:
        return 'Unknown';
    }
  }
}
