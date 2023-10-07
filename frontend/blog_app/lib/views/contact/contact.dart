import 'package:flutter/material.dart';

import 'package:blog_app/api/firestoreAPI.dart';
import 'package:blog_app/model/contact.dart';
import 'package:blog_app/widgets/common/common_snackbar.dart';
import 'package:blog_app/widgets/common/custom_loader.dart';
import 'package:blog_app/widgets/common/cutom_input_field_widget.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Contact",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(223, 41, 88, 127),
                ),
              ),
            ),
            _ContactForm(),
          ],
        ),
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInputFieldWidget(
            labelText: "Email",
            obscureText: false,
            controller: _emailController,
            maxLine: 1,
          ),
          CustomInputFieldWidget(
            labelText: "Title",
            obscureText: false,
            controller: _titleController,
            maxLine: 1,
          ),
          CustomInputFieldWidget(
            labelText: "Description",
            obscureText: false,
            controller: _descriptionController,
            maxLine: null,
          ),
          loading
              ? CustomLoader()
              : Container(
                  width: MediaQuery.of(context).size.width - 90,
                  height: 45,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 163, 213, 254),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          setState(() {
                            loading = true;
                          });
                          final contactDetails = ContactModel(
                            email: _emailController.text,
                            title: _titleController.text,
                            description: _descriptionController.text,
                          );
                          await addCotactUsDetails(contactDetails);
                          _emailController.clear();
                          _titleController.clear();
                          _descriptionController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                              CommonSnackBar.buildSnackBar(
                                  context,
                                  "Contact Details Submitted Successfully",
                                  "success"));
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              CommonSnackBar.buildSnackBar(
                                  context, error.toString(), "error"));
                        } finally {
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(223, 41, 88, 127),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
