import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileCubit extends Cubit<bool> {
  EditProfileCubit() : super(false);

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String? selectedGender;
  String? selectedCountry;
File? pickedImage; // store the picked image temporarily

  void setPickedImage(File? file) {
    pickedImage = file;
    emit(state); // triggers UI rebuilds that read cubit.pickedImage
  }
  void toggleEditing() => emit(!state);

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    return super.close();
  }
}
