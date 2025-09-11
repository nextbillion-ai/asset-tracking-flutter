import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

typedef InputDialogCallback = void Function(
    String title, String description, String tripId);

void showInputDialog(BuildContext context, InputDialogCallback callback) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController tripIdController =
      TextEditingController(text: const Uuid().v4().toString());
  final TextEditingController tripNameController = TextEditingController();
  final TextEditingController tripDescriptionController =
      TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Create Trip'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextFormField(
                controller: tripNameController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tripDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tripIdController,
                decoration: const InputDecoration(labelText: 'Custom Trip ID'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a custom trip ID';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              callback(tripNameController.text, tripDescriptionController.text,
                  tripIdController.text);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}
